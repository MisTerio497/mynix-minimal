{ pkgs, lib, ... }:
{

  services.zerotierone.enable = true;
  networking = {
    hostName = "nixos";
    nameservers = [
      "1.1.1.1"
    ];
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
      enable = false;
      allowedTCPPorts = [
        22
        80
        443
      ];
      allowedUDPPortRanges = [
        {
          from = 3074;
          to = 3076;
        }
      ];
      allowedUDPPorts = [ 1900 ]; # Необходимо для UPnP
    };
  };
}
