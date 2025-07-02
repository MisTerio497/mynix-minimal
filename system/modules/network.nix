{ pkgs, lib, ... }:
{
  services.zerotierone.enable = true;
  networking = {
    hostName = "nixos";
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    networkmanager = {
      enable = false;
      wifi.powersave = false;
    };
    wireless = {
      enable = true;
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
  };
}
