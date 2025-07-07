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
  xdg.userDirs = {
      enable = true;
      desktop = "$HOME/Desktop";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      videos = "$HOME/Videos";
      extraConfig = {
        XDG_TEMPLATES_DIR = "$HOME/Templates";
        XDG_PUBLICSHARE_DIR = "$HOME/Public";
      };
    };
  programs.home-manager.enable = true;
}
