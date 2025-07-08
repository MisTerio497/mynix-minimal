{ pkgs, lib, ... }:

let
  username = "ivan";
  homeDirectory = "/home/${username}";
in
{
  imports = [
    ./modules
    #./wm/hypr.nix
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "25.05"; # Рекомендуется указывать актуальную версию
  };

  xdg = {
    userDirs = {
      enable = true;
      desktop = "${homeDirectory}/Desktop";
      documents = "${homeDirectory}/Documents";
      download = "${homeDirectory}/Downloads";
      music = "${homeDirectory}/Music";
      pictures = "${homeDirectory}/Pictures";
      videos = "${homeDirectory}/Videos";
      extraConfig = {
        XDG_TEMPLATES_DIR = "${homeDirectory}/Templates";
        XDG_PUBLICSHARE_DIR = "${homeDirectory}/Public";
      };
    };

    desktopEntries = {
      vesktop = {
        name = "Vencord Desktop";
        exec = "vesktop --disable-gpu-sandbox --proxy-server=socks5://127.0.0.1:10808";
        icon = "vesktop";
        type = "Application";
        categories = [
          "Network"
          "InstantMessaging"
          "Chat"
        ];
        settings = {
          StartupWMClass = "vesktop";
        };
      };

      protontricks = {
        name = "Protontricks";
        exec = "protontricks --no-term --gui";
        comment = "A simple wrapper that does winetricks things for Proton enabled games";
        type = "Application";
        terminal = false;
        categories = [ "Utility" ];
        icon = "protontricks";
      };
    };
  };
  # Дополнительно: гарантированное создание директорий
  home.activation.createXdgDirs =
    let
      dirs = [
        "Desktop"
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"
        "Templates"
        "Public"
      ];
    in
    lib.hm.dag.entryAfter [ "writeBoundary" ] (
      # ← Используйте lib.hm.dag вместо pkgs.lib.hm.dag
      builtins.concatStringsSep "\n" (map (dir: "mkdir -p ${dir}") dirs)
    );

  programs.home-manager.enable = true;
}
