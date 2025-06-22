{ pkgs, lib, ... }:
{
  networking = {
    hostName = "nixos";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };
}
