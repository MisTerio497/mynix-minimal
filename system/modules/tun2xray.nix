{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tun2socks;
  interface = cfg.interface;

  resolveDomains = pkgs.writeScriptBin "resolve-domains" ''
    #!/bin/sh
    for domain in ${concatStringsSep " " cfg.whitelist}; do
      ${pkgs.dnsutils}/bin/dig +short "$domain" |
        grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' || true
    done | sort -u
  '';

  startupScript = pkgs.writeScriptBin "tun2socks-start" ''
    #!/bin/sh
    set -e
    ip tuntap add mode tun dev $interface
    ip addr add 198.18.0.1/15 dev $interface
    ip link set dev $interface up
    echo "Enabling IP forwarding..."
    echo 1 > /proc/sys/net/ipv4/ip_forward

    echo "Waiting for DNS to be available..."
    for i in $(seq 1 30); do
      ${pkgs.dnsutils}/bin/dig +short google.com >/dev/null && break
      sleep 1
    done

    echo "Setting routes and iptables rules for whitelist..."
    for ip in $(${resolveDomains}/bin/resolve-domains); do
      echo "Adding route to $ip via 10.0.0.2"
      ${pkgs.iproute2}/bin/ip route add "$ip" via 10.0.0.2 dev "${interface}" 2>/dev/null || true

      echo "Marking traffic to $ip"
      ${pkgs.iptables}/bin/iptables -t mangle -A OUTPUT -d "$ip" -j MARK --set-mark 100 2>/dev/null || true
    done

    ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o ${interface} -j MASQUERADE 2>/dev/null || true
    ${pkgs.iptables}/bin/iptables -A OUTPUT -t mangle -m mark --mark 100 -j ACCEPT 2>/dev/null || true

    echo "tun2socks setup complete."
  '';

  shutdownScript = pkgs.writeScriptBin "tun2socks-stop" ''
    #!/bin/sh
    echo "Tearing down tun2socks routes and iptables rules..."

    ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o ${interface} -j MASQUERADE 2>/dev/null || true
    ${pkgs.iptables}/bin/iptables -D OUTPUT -t mangle -m mark --mark 100 -j ACCEPT 2>/dev/null || true

    for ip in $(${resolveDomains}/bin/resolve-domains); do
      echo "Removing route to $ip"
      ${pkgs.iproute2}/bin/ip route del "$ip" via 10.0.0.2 dev "${interface}" 2>/dev/null || true

      echo "Removing mangle rule for $ip"
      ${pkgs.iptables}/bin/iptables -t mangle -D OUTPUT -d "$ip" -j MARK --set-mark 100 2>/dev/null || true
    done

    echo "tun2socks teardown complete."
  '';
in
{
  options.services.tun2socks = {
    enable = mkEnableOption "tun2socks routing service";

    package = mkOption {
      type = types.package;
      default = pkgs.tun2socks;
      defaultText = literalExpression "pkgs.tun2socks";
      description = "tun2socks binary package";
    };

    interface = mkOption {
      type = types.str;
      default = "tun0";
      description = "Name of the TUN interface (e.g., tun0)";
    };

    proxy = mkOption {
      type = types.str;
      example = "socks5://127.0.0.1:1080";
      description = "SOCKS5 proxy address to use with tun2socks";
    };

    whitelist = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of domain names whose IPs should be routed through tun2socks";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Additional CLI arguments to pass to tun2socks";
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

    # networking.interfaces.${interface} = {
    #   virtual = true;
    #   virtualType = "tun";
    #   ipv4.addresses = [
    #     {
    #       address = "198.18.0.1/15";
    #       prefixLength = 24;
    #     }
    #   ];
    # };

    systemd.services.tun2socks = {
      description = "Route selected traffic through tun2socks";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "nss-lookup.target" ];
      requires = [ "network.target" ];

      path = with pkgs; [ iproute2 iptables dnsutils ];

      serviceConfig = {
        ExecStartPre = "${startupScript}/bin/tun2socks-start";
        ExecStart = ''
          ${cfg.package}/bin/tun2socks \
            -device ${cfg.interface} \
            -proxy ${cfg.proxy} \
            -fwmark 100 \
            ${concatStringsSep " " cfg.extraArgs}
        '';
        ExecStopPost = "${shutdownScript}/bin/tun2socks-stop";
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
