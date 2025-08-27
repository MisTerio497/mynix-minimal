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

  services.hardware.openrgb.enable = true;
  environment.systemPackages = with pkgs; [
    pciutils
    age
    mesa-demos
    efibootmgr
    agenix
    tree
    package-version-server
    git
    curl
    wget
  ];
}
