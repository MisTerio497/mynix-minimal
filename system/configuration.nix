{ config, pkgs, ... }:

{
  imports = [
    ./modules
    ./hardware-configuration.nix
  ];
  
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
  

  services.power-profiles-daemon.enable = true;
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
