{ config, pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./bluetooth.nix
    ./audio.nix
    ./network.nix
  ];
  programs.ssh = {
    package = pkgs.openssh; # Явное указание пакета
    startAgent = true; # Автозапуск ssh-agent
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # Bootloader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "max";
    };
    efi.canTouchEfiVariables = true;
  };

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

  # Enable the X11 windowing system.
  services.libinput.enable = true;
  services.xserver = {
    enable = true;
    xkb.layout = "us,ru";
    xkb.variant = "";
    xkb.options = "grp:alt_shift_toggle,ctrl:nocaps";
  };
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  programs.fish.enable = true;

  # Конфигурация пользователя (исправленная)
  users.users.ivan = {
    isNormalUser = true;
    description = "ivan";
    hashedPassword = "$6$GBmyYg5sZUOA2AlO$MfIpp6XDGgLsDZEBETIrxcSpgBPRfNtXgGJ3GZ3DBYQ4tspWu/DvGCQQ8H1r4YD0JxSaNbM20mlwXjbhRXv0b.";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICsoTnbsIqZmmmmWaIPWpJ7sozpBEYJF7JYDXYDL3XV6 ivan@nixos"
    ];
    extraGroups = [
      "wheel"
    ];
    shell = pkgs.fish;
    createHome = true;
    home = "/home/ivan";
  };
  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "ivan";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.
  programs.firefox.enable = true;
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05";
}
