{ config, pkgs, inputs, ... }:

let
  winapps = inputs.winapps.packages."${pkgs.system}".winapps;
  agenix = inputs.agenix.packages."${pkgs.system}".default;
in{
  
  nixpkgs.config.allowUnfree = true;
  fonts.packages = with pkgs; [
    corefonts
  ];
  programs.java = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [
    pciutils
    jdk8
    jdk17
    winapps
    agenix
    package-version-server
    git
    openssl
    curl
    wget
  ];
}
