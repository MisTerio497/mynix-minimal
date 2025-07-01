{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tun2socks;

  resolveDomains = pkgs.writeScript "resolve-domains.sh" ''
    #!/bin/sh
    ${pkgs.dnsutils}/bin/dig +short ${toString cfg.whitelist} | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'
  '';

  startupScript = pkgs.writeScript "tun2socks-start.sh" ''
    #!/bin/sh
    echo 1 > /proc/sys/net/ipv4/ip_forward

    # Создаем TUN-интерфейс если его нет
    if ! ${pkgs.iproute2}/bin/ip link show ${cfg.interface} >/dev/null 2>&1; then
      ${pkgs.iproute2}/bin/ip tuntap add mode tun dev ${cfg.interface}
      ${pkgs.iproute2}/bin/ip addr add 10.0.0.1/24 dev ${cfg.interface}
      ${pkgs.iproute2}/bin/ip link set dev ${cfg.interface} up
    fi

    # Добавляем маршруты для доменов из whitelist
    for ip in $(${resolveDomains}); do
      ${pkgs.iproute2}/bin/ip route add $ip via 10.0.0.2 dev ${cfg.interface} || true
    done

    # NAT и маркировка пакетов
    ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o ${cfg.interface} -j MASQUERADE
    ${pkgs.iptables}/bin/iptables -A OUTPUT -t mangle -m mark --mark 100 -j ACCEPT

    for ip in $(${resolveDomains}); do
      ${pkgs.iptables}/bin/iptables -t mangle -A OUTPUT -d $ip -j MARK --set-mark 100
    done
  '';

  shutdownScript = pkgs.writeScript "tun2socks-stop.sh" ''
    #!/bin/sh
    ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o ${cfg.interface} -j MASQUERADE 2>/dev/null || true
    ${pkgs.iptables}/bin/iptables -D OUTPUT -t mangle -m mark --mark 100 -j ACCEPT 2>/dev/null || true

    for ip in $(${resolveDomains}); do
      ${pkgs.iptables}/bin/iptables -t mangle -D OUTPUT -d $ip -j MARK --set-mark 100 2>/dev/null || true
      ${pkgs.iproute2}/bin/ip route del $ip via 10.0.0.2 dev ${cfg.interface} 2>/dev/null || true
    done
  '';
in
{
  options.services.tun2socks = {
    enable = mkEnableOption "tun2socks configuration";

    package = mkOption {
      type = types.package;
      default = pkgs.badvpn;
      defaultText = literalExpression "pkgs.badvpn";
      description = "Package providing tun2socks";
    };

    interface = mkOption {
      type = types.str;
      default = "tun0";
      description = "TUN interface name";
    };

    proxy = mkOption {
      type = types.str;
      example = "socks5://127.0.0.1:1080";
      description = "Proxy address (e.g., SOCKS5)";
    };

    whitelist = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of domains to route through the tunnel";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional CLI arguments for tun2socks";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
      pkgs.iptables
      pkgs.iproute2
      pkgs.dnsutils
    ];

    boot.kernelModules = [ "tun" ];

    systemd.services.tun2socks = {
      description = "tun2socks service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      requires = [ "network.target" ];

      serviceConfig = {
        ExecStartPre = startupScript;
        ExecStart = ''
          ${cfg.package}/bin/tun2socks \
            --tundev ${cfg.interface} \
            --netif-ipaddr 10.0.0.2 \
            --netif-netmask 255.255.255.0 \
            --socks-server-addr ${cfg.proxy} \
            ${toString cfg.extraArgs}
        '';
        ExecStopPost = shutdownScript;
        Restart = "on-failure";
        RestartSec = "5s";
        Type = "simple";
        User = "root";
        AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_NET_RAW" ];
        CapabilityBoundingSet = [ "CAP_NET_ADMIN" "CAP_NET_RAW" ];
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };
  };
}