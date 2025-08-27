{ config, pkgs, ... }:

{
  imports = [
    ./modules
    ./hardware-configuration.nix
  ];

  system.autoUpgrade = {
    enable = true;
    flake = "/home/ivan/mynix-minimal";
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

  # programs.nh = {
  #   enable = true;
  #   # clean.enable = true;
  #   # clean.extraArgs = "--keep-since 4d --keep 3";
  #   flake = "/home/ivan/mynix-minimal"; # sets NH_OS_FLAKE variable for you
  # };
  
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
    };
    amdgpu.amdvlk = {
      enable = true;
      support32Bit.enable = true;
    };
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
  programs.fish.enable = true;

  # Конфигурация пользователя (исправленная)
  users.users.ivan = {
    isNormalUser = true;
    description = "ivan";
    uid = 1000;
    hashedPassword = "$6$GBmyYg5sZUOA2AlO$MfIpp6XDGgLsDZEBETIrxcSpgBPRfNtXgGJ3GZ3DBYQ4tspWu/DvGCQQ8H1r4YD0JxSaNbM20mlwXjbhRXv0b.";
    extraGroups = [
      "wheel"
      "video"
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
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05";
}
