{ pkgs, lib, ... }:
{

  services.zerotierone.enable = true;
  networking = {
    hostName = "nixos";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    nftables.enable = true;
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
    wireless = {
      enable = false;
      networks = {
        "RT-5GPON-4957" = {
          psk = "4FmW9pVw";
          priority = 100;
        };
        "RT-GPON-4957" = {
          psk = "4FmW9pVw";
        };
        "RT-WiFi_AF2F" = {
          psk = "cDUE4UE3";
        };
        "Amogus" = {
          psk = "12345678ggawp";
        };
      };
    };
    firewall = {
      enable = true;
      # Ghost Recon Winlands
      allowedUDPPorts = [ 9103 ]; # Постоянный порт
      allowedUDPPortRanges = [
        {
          from = 40000;
          to = 60000;
        }
      ];
    };
  };
}
