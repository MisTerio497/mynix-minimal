{ pkgs, lib, ... }:
{
  imports = [ ./network-connections.nix ];

  services.zerotierone.enable = true;
  networking = {
    hostName = "nixos";
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
    network-connections = {
      enable = true;
      wifi = [
        {
          name = "Home-WiFi-5G";
          ssid = "RT-5GPON-4957";
          password = "4FmW9pVw";
          priority = 100;
        }
        {
          name = "Home-WiFi";
          ssid = "RT-GPON-4957";
          password = "4FmW9pVw";
          priority = 80;
        }
      ];
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
    hosts = {
      "0.0.0.0" = [
        "pubads.g.doubleclick.net"
        "securepubads.g.doubleclick.net"
        "gads.pubmatic.com"
        "ads.pubmatic.com"
        "spclient.wg.spotify.com"
      ];
    };
  };
}
