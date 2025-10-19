{ pkgs, ... }:
{
  # Enable the GNOME Desktop Environment
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      gnome-tweaks
    ];

    # Более правильное объявление исключаемых пакетов
    gnome.excludePackages =
      (with pkgs; [
        gnome-tour
        epiphany
        gnome-connections
        gnome-contacts
        gnome-maps
        gnome-software
        gnome-weather
        gnome-music
        cheese
      ])
      ++ (with pkgs; [
        # Дополнительные пакеты для исключения
        yelp # Документация
        geary # Почтовый клиент
        totem # Видеоплеер
        tali # Игра
        iagno # Игра
        hitori # Игра
        atomix # Игра
      ]);
  };

  # Enable automatic login
  services.displayManager = {
    autoLogin = {
      enable = false;
      user = "ivan";
    };
  };

  # Workaround for GNOME autologin
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Дополнительные рекомендуемые настройки для GNOME
  programs.dconf.enable = true;
}
