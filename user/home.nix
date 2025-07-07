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
    xdg.desktopEntries.vesktop = {
      name = "Vencord Desktop";
      exec = "vesktop --disable-gpu-sandbox --proxy-server=socks5://127.0.0.1:10808";
      icon = "vesktop";
      type = "Application";
      categories = [ "Network" "InstantMessaging" "Chat"];
      settings = {
        StartupWMClass = "vesktop";
      };
    };
    xdg.desktopEntries.protontricks = {
      name = "Protontricks";
      exec = "protontricks --no-term --gui";
      comment = "A simple wrapper that does winetricks things for Proton enabled games";
      type = "Application";
      terminal = false;
      categories = [ "Utility" ];
      icon = "protontricks";
    };
  programs.home-manager.enable = true;
}
