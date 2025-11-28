{
  config,
  username,
  pkgs,
  lib,
  inputs,
  programs-sqlite-db,
  ...
}:

{
  imports = [
    ./modules
    ./hardware-configuration.nix
  ];

  system.autoUpgrade = {
    enable = true;
    flake = "/home/${username}/mynix-minimal";
    dates = "weekly";
    allowReboot = false;
    randomizedDelaySec = "30min"; # случайная задержка
  };
  # programs.ssh = {
  #   package = pkgs.openssh; # Явное указание пакета
  #   startAgent = true; # Автозапуск ssh-agent
  # };
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Enable the X11 windowing system.
  services.libinput.enable = true;
  services.xserver = {
    enable = true;
    xkb.layout = "us,ru";
    xkb.variant = "";
    xkb.options = "grp:alt_shift_toggle,ctrl:nocaps";
  };

  programs.fish.enable = true;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
    };
  };

  users.users.ivan = {
    isNormalUser = true;
    description = "Ivan_Pirat";
    uid = 1000;
    hashedPassword = "$6$GBmyYg5sZUOA2AlO$MfIpp6XDGgLsDZEBETIrxcSpgBPRfNtXgGJ3GZ3DBYQ4tspWu/DvGCQQ8H1r4YD0JxSaNbM20mlwXjbhRXv0b.";
    extraGroups = [
      "wheel"
      "video"
      "render"
      "input"
      "audio"
      "pipewire"
      "networkmanager"
    ];
    shell = pkgs.fish;
    createHome = true;
    home = "/home/ivan";
  };
  # Install firefox.
  programs.firefox.enable = true;
  programs.command-not-found.enable = true;
  programs.command-not-found.dbPath = programs-sqlite-db;
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05";
}
