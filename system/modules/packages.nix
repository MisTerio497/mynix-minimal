{ config, pkgs, inputs, ... }:

let
  winapps = inputs.winapps.packages."${pkgs.system}".winapps;
in{
  
  nixpkgs.config.allowUnfree = true;
  fonts.packages = with pkgs; [
    corefonts
  ];
  environment.systemPackages = with pkgs; [
    pciutils
    winapps
    package-version-server
    git
    openssl
    curl
    wget
  ];
}
