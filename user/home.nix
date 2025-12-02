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
    stateVersion = "25.11";
  };
  
  home.pointerCursor = {
    x11.enable = true;             # включить X11 курсор
    name = "capitaine-cursors";          # имя темы курсора
    size = 30;                     # размер курсора
    package = pkgs.capitaine-cursors; # пакет с иконками/темой
  };

  
  nixpkgs.overlays = [
    (import ./overlays/prism-launcher.nix)
  ]
  ;

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
    # desktopEntries = {
    #   protontricks = {
    #     name = "Protontricks";
    #     exec = "protontricks --no-term --gui";
    #     comment = "A simple wrapper that does winetricks things for Proton enabled games";
    #     type = "Application";
    #     terminal = false;
    #     categories = [ "Utility" ];
    #     icon = "protontricks";
    #   };
    # };
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
      russianDirs = [
        "Рабочий стол"
        "Документы"
        "Загрузки" 
        "Музыка"
        "Изображения"
        "Видео"
        "Общедоступные"
        "Шаблоны"
      ];
    in
    lib.hm.dag.entryAfter [ "writeBoundary" ] (
      builtins.concatStringsSep "\n" (
        (map (dir: "mkdir -p ${dir}") dirs) ++
        (map (dir: "rm -rf ${dir}") russianDirs)
      )
    );

    gtk = {
        enable = true;
        theme = {
          name = "Breeze-Dark"; # или "Breeze"
          package = pkgs.kdePackages.breeze-gtk;
        };
        iconTheme = {
          name = "breeze";
          package = pkgs.kdePackages.breeze-icons;
        };
      };
  programs.home-manager.enable = true;
}
