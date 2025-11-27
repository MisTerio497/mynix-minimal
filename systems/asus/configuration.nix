{
  config,
  username,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ./modules
    ./hardware-configuration.nix
    inputs.nixos-facter-modules.nixosModules.facter
  ];
  
  facter.reportPath = ./facter.json;
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
  # services.autossh.sessions = [
  #   {
  #     extraArguments = "-N -D 10808 -L 33399:localhost:33399 root@91.184.240.220";
  #     name = "socks-peer";
  #     user = "ivan";
  #   }
  # ];
  
  # security.pam.services= {
  #   login = {
  #     enableGnomeKeyring = true;
  #     kwallet.enable = true;
  #   };
  #   passwd = {
  #     enableGnomeKeyring = true;
  #   };
  # };
  services.gnome.gnome-keyring.enable = true;
  services.fwupd = {
    enable = true;
  };
  services.power-profiles-daemon.enable = false;
  # services.auto-cpufreq.enable = true;
  programs.dconf.enable = true;
  # Enable the X11 windowing system.
  services.libinput.enable = true;
  services.xserver = {
    enable = true;
    xkb.layout = "us,ru";
    xkb.variant = "";
    xkb.options = "grp:alt_shift_toggle,ctrl:nocaps";
  };
  
  hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  
  
  # Enable CUPS to print documents.
  services.printing.enable = true;
  programs.fish.enable = true;
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland";
  };

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
  programs.adb.enable = true;
  # Install firefox.
  programs.firefox.enable = true;
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05";
}
