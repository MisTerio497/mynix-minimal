{ config, pkgs, ... }:

{
  imports = [
    ./modules
    ./hardware-configuration.nix
  ];
  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
    "https://winapps.cachix.org"
    "https://cachix.org/api/v1/cache/wine"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "winapps.cachix.org-1:HI82jWrXZsQRar/PChgIx1unmuEsiQMQq+zt05CD36g="
    "wine.cachix.org-1:6hEYg6JbQ9ZQ6bFSQZx1z6QdCbY50q1T6K3XV8ZQ6b8="
  ];
  nix.gc = {
    automatic = true;
    dates = "weekly"; # Очистка раз в неделю
    options = "--delete-older-than 7d"; # Удалить всё старше 7 дней
  };
  system.autoUpgrade = {
    enable = true;
    flake = "/home/ivan/mynix-minimal";
    flags = [
      "--update-input"
      "nixpkgs"
    ];
    dates = "weekly";
    allowReboot = false;
    randomizedDelaySec = "30min"; # случайная задержка
  };
  programs.ssh = {
    package = pkgs.openssh; # Явное указание пакета
    startAgent = true; # Автозапуск ssh-agent
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # Bootloader.
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "max";
    };
    efi.canTouchEfiVariables = true;
  };
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelParams = [
    # Уменьшить уровень логов ACPI
    "loglevel=4" # 3 (только ошибки), 4 (предупреждения + ошибки)
    "quiet" # скрыть большинство сообщений ядра
  ];

  services.power-profiles-daemon.enable = true;
  nix.optimise.automatic = true;
  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "ru_RU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };
  programs.dconf.enable = true;
  # Enable the X11 windowing system.
  services.libinput.enable = true;
  services.xserver = {
    enable = true;
    xkb.layout = "us,ru";
    xkb.variant = "";
    xkb.options = "grp:alt_shift_toggle,ctrl:nocaps";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  programs.fish.enable = true;

  # Конфигурация пользователя (исправленная)
  users.users.ivan = {
    isNormalUser = true;
    description = "ivan";
    hashedPassword = "$6$GBmyYg5sZUOA2AlO$MfIpp6XDGgLsDZEBETIrxcSpgBPRfNtXgGJ3GZ3DBYQ4tspWu/DvGCQQ8H1r4YD0JxSaNbM20mlwXjbhRXv0b.";
    extraGroups = [
      "wheel"
    ];
    shell = pkgs.fish;
    createHome = true;
    home = "/home/ivan";
  };

  # Install firefox.
  programs.firefox.enable = true;
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05";
}
