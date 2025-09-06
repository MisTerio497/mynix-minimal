{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tun2socks;

  # Резолвим домены → получаем IPv4
  resolvedIpsScript = pkgs.writeScript "resolve-domains.sh" ''
    #!/bin/sh
    for domain in ${toString cfg.whitelist}; do
      ${pkgs.dnsutils}/bin/dig +short "$domain" A | \
        grep -E '^[0-9]{1,3}(\.[0-9]{1,3}){3}$' | sort -u
    done
  '';

  nftTableName = "tun2socks";

  startupScript = pkgs.writeScript "tun2socks-start.sh" ''
    #!/bin/sh
    set -e

    echo 1 > /proc/sys/net/ipv4/ip_forward

    # Создаём TUN-интерфейс, если его нет
    if ! ${pkgs.iproute2}/bin/ip link show ${cfg.interface} >/dev/null 2>&1; then
      ${pkgs.iproute2}/bin/ip tuntap add mode tun dev ${cfg.interface}
      ${pkgs.iproute2}/bin/ip addr add 10.0.0.1/24 dev ${cfg.interface}
      ${pkgs.iproute2}/bin/ip link set dev ${cfg.interface} up
    fi

    # Настраиваем таблицу маршрутов 100 для помеченного трафика
    ${pkgs.iproute2}/bin/ip rule add fwmark 100 table 100 || true
    ${pkgs.iproute2}/bin/ip route add default dev ${cfg.interface} table 100 || true

    # Инициализируем nftables
    ${pkgs.nftables}/bin/nft flush table inet ${nftTableName} 2>/dev/null || true
    ${pkgs.nftables}/bin/nft add table inet ${nftTableName}
    ${pkgs.nftables}/bin/nft add chain inet ${nftTableName} output '{ type filter hook output priority -150; }'

    # Маркируем пакеты для whitelist-доменов
    for ip in $(${resolvedIpsScript}); do
      echo "[tun2socks] Marking $ip"
      ${pkgs.nftables}/bin/nft add rule inet ${nftTableName} output ip daddr $ip meta mark set 100
    done
  '';

  shutdownScript = pkgs.writeScript "tun2socks-stop.sh" ''
    #!/bin/sh
    set +e
    echo "🧹 Cleaning up tun2socks..."

    ${pkgs.nftables}/bin/nft delete table inet ${nftTableName} 2>/dev/null || true
    ${pkgs.iproute2}/bin/ip rule del fwmark 100 table 100 2>/dev/null || true
    ${pkgs.iproute2}/bin/ip route flush table 100 2>/dev/null || true
    ${pkgs.iproute2}/bin/ip link delete ${cfg.interface} 2>/dev/null || true

    echo "✅ tun2socks stopped."
  '';
in
{
  options.services.tun2socks = {
    enable = mkEnableOption "Enable tun2socks tunneling with nftables";

    package = mkOption {
      type = types.package;
      default = pkgs.tun2socks;
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
      pkgs.nftables
      pkgs.iproute2
      pkgs.dnsutils
    ];

    boot.kernelModules = [ "tun" ];
    networking.nftables.enable = lib.mkDefault true;
    systemd.services.tun2socks = {
      description = "tun2socks split-tunnel routing service (fwmark)";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

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
        AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_NET_RAW" ];
        CapabilityBoundingSet = [ "CAP_NET_ADMIN" "CAP_NET_RAW" ];
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };
  };
}
