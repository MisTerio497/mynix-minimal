{ pkgs, lib, ... }:
{
  imports = [
    ./modules
    #./wm/hypr.nix
  ];
  home = {
    username = "ivan";
    homeDirectory = "/home/ivan";
    stateVersion = "25.05";
  };
  programs.home-manager.enable = true;
}
