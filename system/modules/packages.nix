{ config, pkgs, inputs, ... }:

let
  winapps = inputs.winapps.packages."${pkgs.system}".winapps;
  agenix = inputs.agenix.packages."${pkgs.system}".default;
in{
  
  nixpkgs.config.allowUnfree = true;
  fonts.packages = with pkgs; [
    corefonts
  ];
  environment.systemPackages = with pkgs; [
    pciutils
    winapps
    agenix
    package-version-server
    git
    openssl
    curl
    wget
  ];
}
