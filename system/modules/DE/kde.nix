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
  environment.systemPackages = with pkgs; [
    kdePackages.kcalc # Calculator
    kdePackages.ksystemlog # KDE SystemLog Application
    kdePackages.sddm-kcm # Configuration module for SDDM
    kdePackages.partitionmanager # Optional Manage the dis
  ];
}
