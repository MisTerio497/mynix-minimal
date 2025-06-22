{ config, pkgs, inputs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    usbutils
    pciutils
    system-config-printer
    chromium
    kitty
  ];
}
