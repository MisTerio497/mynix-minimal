{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tun2socks;

  resolvedIpsScript = pkgs.writeScript "resolve-domains.sh" ''
    #!/bin/sh
    for domain in ${toString cfg.whitelist}; do
      ${pkgs.dnsutils}/bin/dig +short "$domain" | \
        grep -E '^[0-9]+(\.[0-9]+){3}$' || echo "Failed to resolve $domain" >&2
    done
  '';

  startupScript = pkgs.writeScript "tun2socks-start.sh" ''
    #!/bin/sh
    echo 1 > /proc/sys/net/ipv4/ip_forward

    # Setup TUN interface if not present
    if ! ${pkgs.iproute2}/bin/ip link show ${cfg.interface} >/dev/null 2>&1; then
      ${pkgs.iproute2}/bin/ip tuntap add mode tun dev ${cfg.interface}
      ${pkgs.iproute2}/bin/ip addr add 10.0.0.1/24 dev ${cfg.interface}
      ${pkgs.iproute2}/bin/ip link set dev ${cfg.interface} up
    fi

    for ip in $(${resolvedIpsScript}); do
      echo "[tun2socks] Routing $ip via ${cfg.interface}"
      ${pkgs.iproute2}/bin/ip route replace $ip via 10.0.0.2 dev ${cfg.interface} || true
      ${pkgs.iptables}/bin/iptables -t mangle -A OUTPUT -d $ip -j MARK --set-mark 100 || true
    done

    ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o ${cfg.interface} -j MASQUERADE || true
    ${pkgs.iptables}/bin/iptables -A OUTPUT -t mangle -m mark --mark 100 -j ACCEPT || true
  '';

  shutdownScript = pkgs.writeScript "tun2socks-stop.sh" ''
    #!/bin/sh
    for ip in $(${resolvedIpsScript}); do
      ${pkgs.iptables}/bin/iptables -t mangle -D OUTPUT -d $ip -j MARK --set-mark 100 2>/dev/null || true
      ${pkgs.iproute2}/bin/ip route del $ip via 10.0.0.2 dev ${cfg.interface} 2>/dev/null || true
    done

    ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o ${cfg.interface} -j MASQUERADE 2>/dev/null || true
    ${pkgs.iptables}/bin/iptables -D OUTPUT -t mangle -m mark --mark 100 -j ACCEPT 2>/dev/null || true

    ${pkgs.iproute2}/bin/ip link delete ${cfg.interface} 2>/dev/null || true
  '';

in
{
  options.services.tun2socks = {
    enable = mkEnableOption "Enable tun2socks tunneling";

    package = mkOption {
      type = types.package;
      default = pkgs.tun2socks;
      defaultText = literalExpression "pkgs.tun2socks";
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
      description = "SOCKS5 proxy address used by tun2socks";
    };

    whitelist = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Domains to tunnel traffic through the SOCKS proxy";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Additional arguments passed to tun2socks";
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
      description = "tun2socks dynamic tunnel routing service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      requires = [ "network.target" ];

      serviceConfig = {
        ExecStartPre = startupScript;
        ExecStart = ''
          ${cfg.package}/bin/tun2socks \
            -device ${cfg.interface} \
            -proxy ${cfg.proxy} \
            -fwmark 100 \
            ${toString cfg.extraArgs}
        '';
        ExecStopPost = shutdownScript;
        Restart = "on-failure";
        RestartSec = "5s";
        Type = "simple";
        User = "root";
        AmbientCapabilities = [
          "CAP_NET_ADMIN"
          "CAP_NET_RAW"
        ];
        CapabilityBoundingSet = [
          "CAP_NET_ADMIN"
          "CAP_NET_RAW"
        ];
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };
  };
}
