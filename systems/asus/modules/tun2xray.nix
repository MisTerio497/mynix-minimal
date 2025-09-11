{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tun2socks;
  nftTableName = "tun2socks";

  startupScript = pkgs.writeScript "tun2socks-start.sh" ''
    #!/bin/sh
    set -e

    echo 1 > /proc/sys/net/ipv4/ip_forward

    # Создаём ipset для whitelist (если не существует)
    ${pkgs.ipset}/bin/ipset create whitelist hash:ip 2>/dev/null || true

    # Создаём TUN-интерфейс, если его нет
    if ! ${pkgs.iproute2}/bin/ip link show ${cfg.interface} >/dev/null 2>&1; then
      ${pkgs.iproute2}/bin/ip tuntap add mode tun dev ${cfg.interface}
      ${pkgs.iproute2}/bin/ip addr add 10.0.0.1/24 dev ${cfg.interface}
      ${pkgs.iproute2}/bin/ip link set dev ${cfg.interface} up
    fi

    # Настраиваем политику маршрутизации
    ${pkgs.iproute2}/bin/ip rule add fwmark 100 table 100 2>/dev/null || true
    ${pkgs.iproute2}/bin/ip route add default dev ${cfg.interface} table 100 2>/dev/null || true

    # Инициализируем nftables
    ${pkgs.nftables}/bin/nft flush table inet ${nftTableName} 2>/dev/null || true
    ${pkgs.nftables}/bin/nft add table inet ${nftTableName}

    # Создаём динамический set для IP
    ${pkgs.nftables}/bin/nft add set inet ${nftTableName} whitelist { type ipv4_addr\; flags dynamic\; }

    # Создаём цепочки
    ${pkgs.nftables}/bin/nft add chain inet ${nftTableName} prerouting '{ type nat hook prerouting priority -100; }'
    ${pkgs.nftables}/bin/nft add chain inet ${nftTableName} postrouting '{ type nat hook postrouting priority 100; }'
    ${pkgs.nftables}/bin/nft add chain inet ${nftTableName} output '{ type route hook output priority -150; }'

    # Правила: помечаем трафик к IP из whitelist
    ${pkgs.nftables}/bin/nft add rule inet ${nftTableName} output ip daddr @whitelist meta mark set 100

    # NAT для трафика, уходящего через TUN
    ${pkgs.nftables}/bin/nft add rule inet ${nftTableName} postrouting oifname "${cfg.interface}" masquerade

    echo "[tun2socks] ✅ nftables and routing configured."
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
    enable = mkEnableOption "Enable tun2socks tunneling with nftables + dnsmasq/ipset";

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
    # --- Установка необходимых пакетов ---
    environment.systemPackages = [
      cfg.package
      pkgs.nftables
      pkgs.iproute2
      pkgs.dnsmasq
      pkgs.ipset
    ];

    # --- Загрузка модулей ядра ---
    boot.kernelModules = [
      "tun"
      "ip_set"
      "ip_set_hash_ip"
    ];

    # --- Отключаем systemd-resolved, если он мешает ---
    services.resolved.enable = lib.mkDefault false;

    # --- Настройка dnsmasq ---
    services.dnsmasq = {
      enable = true;
      settings = {
        no-resolv = true;
        server = [ "8.8.8.8" "1.1.1.1" ];
    
        # генерим список строк "ipset=/domain/whitelist"
        ipset = map (d: "/${d}/whitelist") cfg.whitelist;
      };
    };
    # systemd.services.dnsmasq.serviceConfig.ExecStartPre = [
    #   "${pkgs.ipset}/bin/ipset create whitelist hash:ip"
    # ];


    # --- Настройка tun2socks ---
    systemd.services.tun2socks = {
      description = "tun2socks split-tunnel routing service (fwmark + ipset)";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "dnsmasq.service" ];

      serviceConfig = {
        ExecStartPre = startupScript;
        ExecStart = ''
          ${cfg.package}/bin/tun2socks \
            -device ${cfg.interface} \
            -proxy ${cfg.proxy} \
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