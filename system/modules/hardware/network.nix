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
    # hosts = {
    #   "0.0.0.0" = [
    #     "pubads.g.doubleclick.net"
    #     "securepubads.g.doubleclick.net"
    #     "gads.pubmatic.com"
    #     "ads.pubmatic.com"
    #     "spclient.wg.spotify.com"
    #   ];
    # };
  };
  services.zapret = {
    enable = false;
    params = [
      "--dpi-desync=fake,disorder2"
      "--dpi-desync-ttl=1"
      "--dpi-desync-autottl=2"
    ];
  };
}
