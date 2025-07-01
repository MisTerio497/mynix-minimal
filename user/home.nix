{ pkgs, lib, ... }:
{
  imports = [
    ./modules
  ];
  home = {
    username = "ivan";
    homeDirectory = "/home/ivan";
    stateVersion = "25.05";
  };
  programs.home-manager.enable = true;
}
