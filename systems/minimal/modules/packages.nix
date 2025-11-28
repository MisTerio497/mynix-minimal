{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

let
  agenix = inputs.agenix.packages."${pkgs.system}".default;
in
{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];
  nixpkgs.config.allowUnfree = true;

  programs.amnezia-vpn.enable = true;
  services.hardware.openrgb.enable = true;
  environment.systemPackages = with pkgs; [
    pciutils
    age
    unrar-free
    libsecret
    mesa-demos
    efibootmgr
    agenix
    tree
    nixG
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
