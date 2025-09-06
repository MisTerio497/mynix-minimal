{ config, pkgs, ... }:

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
      trusted_domains = [
        "localhost"
        "91.184.240.220"
      ];
    };
    https = false; # потом можно включить nginx + certbot
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
