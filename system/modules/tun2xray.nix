{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tun2socks;

  # Генератор скрипта для разрешения доменов с кэшированием и IPv6 поддержкой
  resolveDomains = pkgs.writeScript "resolve-domains.sh" ''
    #!/bin/sh
    set -o pipefail

    # Логируем ошибки DNS в systemd journal
    exec 3>&1
    DNS_OUTPUT=$(${pkgs.dnsutils}/bin/dig +short A ${toString cfg.whitelist} 2>&1 | tee /dev/fd/3 | \
      ${pkgs.gnused}/bin/sed 's/^/[DNS-A] /' | \
      ${pkgs.systemd}/bin/systemd-cat -t tun2socks)

    ${pkgs.dnsutils}/bin/dig +short AAAA ${toString cfg.whitelist} 2>&1 | \
      ${pkgs.gnused}/bin/sed 's/^/[DNS-AAAA] /' | \
      ${pkgs.systemd}/bin/systemd-cat -t tun2socks

    # Возвращаем только валидные IP-адреса
    echo "$DNS_OUTPUT" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'
    ${pkgs.dnsutils}/bin/dig +short AAAA ${toString cfg.whitelist} | grep -E '^[0-9a-fA-F:]+$'
  '';

  # Улучшенный скрипт инициализации с поддержкой nftables/iptables
  startupScript = pkgs.writeScript "tun2socks-start.sh" ''
    #!/bin/sh
    set -e

    # Проверяем доступность прокси
    if ! ${pkgs.curl}/bin/curl -s --connect-timeout 5 ${cfg.proxy} "http://example.com" >/dev/null; then
      echo "Proxy ${cfg.proxy} is unreachable!" >&2
      exit 1
    fi

    # Включаем IP forwarding
    echo 1 > /proc/sys/net/ipv4/ip_forward
    ${optionalString cfg.enableIpv6 ''
      echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
    ''}

    # Создаем TUN-интерфейс
    ${pkgs.iproute2}/bin/ip tuntap add mode tun user tun2socks group tun2socks dev ${cfg.interface}
    ${pkgs.iproute2}/bin/ip addr add 10.0.0.1/24 dev ${cfg.interface}
    ${optionalString cfg.enableIpv6 ''
      ${pkgs.iproute2}/bin/ip -6 addr add fd00:feed::1/64 dev ${cfg.interface}
    ''}
    ${pkgs.iproute2}/bin/ip link set dev ${cfg.interface} up

    # Кэшируем IP-адреса
    IP_CACHE="/var/lib/tun2socks/ip_cache"
    mkdir -p /var/lib/tun2socks
    ${resolveDomains} > "$IP_CACHE"

    # Добавляем маршруты и правила фаервола
    while read -r ip; do
      if [[ "$ip" == *:* ]]; then
        ${pkgs.iproute2}/bin/ip -6 route add "$ip" via fd00:feed::2 dev ${cfg.interface} || true
      else
        ${pkgs.iproute2}/bin/ip route add "$ip" via 10.0.0.2 dev ${cfg.interface} || true
      fi
    done < "$IP_CACHE"

    # Настройка фаервола (nftables или iptables)
    if ${pkgs.nftables}/bin/nft list ruleset &>/dev/null; then
      ${pkgs.nftables}/bin/nft add table inet tun2socks 2>/dev/null || true
      ${pkgs.nftables}/bin/nft add chain inet tun2socks mangle { type filter hook output priority 0 \; } 2>/dev/null || true
      while read -r ip; do
        ${pkgs.nftables}/bin/nft add rule inet tun2socks mangle ip daddr "$ip" mark set 100 2>/dev/null || true
        ${optionalString cfg.enableIpv6 ''
          ${pkgs.nftables}/bin/nft add rule inet tun2socks mangle ip6 daddr "$ip" mark set 100 2>/dev/null || true
        ''}
      done < "$IP_CACHE"
    else
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o ${cfg.interface} -j MASQUERADE
      ${pkgs.iptables}/bin/iptables -A OUTPUT -t mangle -m mark --mark 100 -j ACCEPT
      while read -r ip; do
        if [[ "$ip" == *:* ]]; then
          ${pkgs.iptables}/bin/ip6tables -t mangle -A OUTPUT -d "$ip" -j MARK --set-mark 100 2>/dev/null || true
        else
          ${pkgs.iptables}/bin/iptables -t mangle -A OUTPUT -d "$ip" -j MARK --set-mark 100 2>/dev/null || true
        fi
      done < "$IP_CACHE"
    fi
  '';

  # Скрипт для очистки при остановке
  shutdownScript = pkgs.writeScript "tun2socks-stop.sh" ''
    #!/bin/sh
    # Очищаем правила фаервола
    if ${pkgs.nftables}/bin/nft list table inet tun2socks &>/dev/null; then
      ${pkgs.nftables}/bin/nft delete table inet tun2socks
    else
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o ${cfg.interface} -j MASQUERADE 2>/dev/null || true
      ${pkgs.iptables}/bin/iptables -D OUTPUT -t mangle -m mark --mark 100 -j ACCEPT 2>/dev/null || true
      ${pkgs.iptables}/bin/ip6tables -D OUTPUT -t mangle -m mark --mark 100 -j ACCEPT 2>/dev/null || true
    fi

    # Удаляем маршруты
    if [ -f "/var/lib/tun2socks/ip_cache" ]; then
      while read -r ip; do
        if [[ "$ip" == *:* ]]; then
          ${pkgs.iproute2}/bin/ip -6 route del "$ip" via fd00:feed::2 dev ${cfg.interface} 2>/dev/null || true
        else
          ${pkgs.iproute2}/bin/ip route del "$ip" via 10.0.0.2 dev ${cfg.interface} 2>/dev/null || true
        fi
      done < "/var/lib/tun2socks/ip_cache"
    fi

    # Удаляем TUN-интерфейс
    ${pkgs.iproute2}/bin/ip link del dev ${cfg.interface} 2>/dev/null || true
  '';

in {
  options.services.tun2socks = {
    enable = mkEnableOption (mdDoc "tun2socks VPN service");

    package = mkOption {
      type = types.package;
      default = pkgs.tun2socks;
      defaultText = literalExpression "pkgs.tun2socks";
      description = mdDoc "tun2socks package to use";
    };

    interface = mkOption {
      type = types.str;
      default = "tun0";
      description = mdDoc "TUN interface name";
    };

    proxy = mkOption {
      type = types.str;
      example = "socks5://user:pass@127.0.0.1:1080";
      description = mdDoc ''
        Proxy address in URI format.
        Supported schemes: socks5, http.
        Example with auth: `socks5://user:pass@127.0.0.1:1080`
      '';
    };

    whitelist = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "example.com" "1.1.1.1" ];
      description = mdDoc "List of domains/IPs to route through the tunnel";
    };

    enableIpv6 = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc "Enable IPv6 support";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "-loglevel" "debug" ];
      description = mdDoc "Extra command-line arguments for tun2socks";
    };
  };

  config = mkIf cfg.enable {
    # Создаем пользователя и группу
    users.users.tun2socks = {
      isSystemUser = true;
      group = "tun2socks";
      extraGroups = [ "network" ];
    };
    users.groups.tun2socks = {};

    # Настройки udev для TUN-устройства
    services.udev.extraRules = ''
      KERNEL=="${cfg.interface}", OWNER="tun2socks", GROUP="tun2socks", MODE="0660"
    '';

    # Необходимые пакеты
    environment.systemPackages = [
      cfg.package
      pkgs.iptables
      pkgs.nftables
      pkgs.iproute2
      pkgs.dnsutils
      pkgs.curl
    ];

    # Загрузка модуля ядра
    boot.kernelModules = [ "tun" ];

    # Сервис tun2socks
    systemd.services.tun2socks = {
      description = "tun2socks VPN service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        Type = "simple";
        User = "tun2socks";
        Group = "tun2socks";
        ExecStartPre = startupScript;
        ExecStart = "${cfg.package}/bin/tun2socks \
          -device ${cfg.interface} \
          -proxy ${cfg.proxy} \
          -fwmark 100 \
          ${toString cfg.extraArgs}";
        ExecStopPost = shutdownScript;
        Restart = "on-failure";
        RestartSec = "5s";
        AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_NET_RAW" ];
        CapabilityBoundingSet = [ "CAP_NET_ADMIN" "CAP_NET_RAW" ];
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        StateDirectory = "tun2socks";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };

    # Сервис для автоматического обновления IP-адресов
    systemd.services.tun2socks-update = {
      description = "Update tun2socks whitelist IPs";
      serviceConfig = {
        Type = "oneshot";
        User = "tun2socks";
        Group = "tun2socks";
        ExecStart = "${resolveDomains} > /var/lib/tun2socks/ip_cache";
      };
    };

    systemd.timers.tun2socks-update = {
      description = "Timer for tun2socks whitelist update";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "hourly";
        Persistent = true;
      };
    };
  };
}