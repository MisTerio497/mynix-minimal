{ config, pkgs, ... }:

let
  YOUR_NETWORK_ID = "8286ac0e473a84fa.";
in
{
  ############################################
  # Основные пакеты
  ############################################
  environment.systemPackages = with pkgs; [
    zeronsd
  ];

  ############################################
  # Nextcloud
  ############################################
  services.nextcloud = {
    enable = true;
    hostName = "nextcloud.zt";                  # домен внутри ZeroTier
    config.adminpassFile = "/var/lib/nextcloud/admin-pass";
    database.createLocally = true;
    https = false;                              # можно потом включить nginx + certbot
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  ############################################
  # ZeroTier
  ############################################
  networking.zerotier = {
    enable = true;
    joinNetworks = [ "${YOUR_NETWORK_ID}" ];       # <- замени на ID своей сети
  };

  ############################################
  # zeronsd (ZeroTier DNS)
  ############################################
  systemd.services.zeronsd = {
    description = "ZeroTier DNS service (zeronsd)";
    after = [ "network.target" "zerotierone.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.zeronsd}/bin/zeronsd --sdomain zt ${YOUR_NETWORK_ID}";
      Restart = "always";
    };
  };
}
