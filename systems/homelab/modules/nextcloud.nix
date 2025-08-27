{ config, pkgs, ... }:

let
  YOUR_NETWORK_ID = "8286ac0e473a84fa"; # замени на свой ID
  ZEROTIER_IP = "172.28.23.9";
in
{
  ############################################
  # Nextcloud
  ############################################
  services.nextcloud = {
    enable = true;
    hostName = "localhost";
    config = {
      adminpassFile = "${pkgs.writeText "root" "test12345"}";
      dbtype = "pgsql";
      dbname = "nextcloud";
      dbuser = "nextcloud";
    };
    database.createLocally = true;
    settings = {
      trusted_proxies = [ ZEROTIER_IP ];
      trusted_domains = [
        "localhost"
        ZEROTIER_IP # IP-адрес ZeroTier сервера
        "nextcloud.local"
      ];
    };
    https = false; # потом можно включить nginx + certbot
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;

    virtualHosts."nextcloud.local" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:80";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };

  services.zerotierone = {
    enable = true;
    joinNetworks = [ "${YOUR_NETWORK_ID}" ];
  };
  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "ztrtazncv5"; # Интерфейс ZeroTier
      listen-address = "127.0.0.1,${ZEROTIER_IP}";
      bind-interfaces = true;
      domain-needed = true;
      address = "/nextcloud.local/${ZEROTIER_IP}";
      domain = "local";
    };
  };
}
