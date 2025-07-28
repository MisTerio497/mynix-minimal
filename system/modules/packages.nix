{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

let
  winapps = inputs.winapps.packages."${pkgs.system}".winapps;
  agenix = inputs.agenix.packages."${pkgs.system}".default;
in
{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];
  nixpkgs.config.allowUnfree = true;
  fonts.packages = with pkgs; [
    corefonts
  ];
  programs.java = {
    enable = true;
  };
  programs.amnezia-vpn.enable = true;
  services.hardware.openrgb.enable = true;
  environment.systemPackages = with pkgs; [
    pciutils
    mesa-demos
    switcheroo-control
    efibootmgr
    jdk8
    jdk17
    winapps
    agenix
    tree
    package-version-server
    git
    openssl
    curl
    wget
  ];
  services.flatpak = {
    enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    packages = [

    ];
    update.auto = {
      enable = true;
      onCalendar = "weekly"; # Default value
    };
  };
}
