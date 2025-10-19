{ pkgs, ... }:
{
  services = {
    desktopManager = {
      plasma6.enable = true;
    };
    displayManager = {
      sddm.enable = true;
      sddm.wayland.enable = true;
      autoLogin.enable = true;
      autoLogin.user = "ivan";
    };
  };
  # security.pam.services = {
  #   sddm.enableKwallet = true;  # Для SDDM

  #   ivan = {
  #     kwallet = {
  #       enable = true;
  #       package = pkgs.kdePackages.kwallet-pam;
  #     };
  #   };
  # };
  environment.systemPackages = with pkgs.kdePackages; [
    kcalc # Calculator
    ksystemlog # KDE SystemLog Application
    sddm-kcm # Configuration module for SDDM
    partitionmanager # Optional Manage the dis
    kcolorchooser # Pick color
  ];
  xdg.portal = {
     enable = true;
     extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
   };
}
