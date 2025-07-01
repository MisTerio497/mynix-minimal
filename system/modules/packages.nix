{ config, pkgs, inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  fonts.packages = with pkgs; [
    corefonts
  ];
  environment.systemPackages = with pkgs; [
    pciutils
    package-version-server
    git
    openssl
    curl
    wget
  ];
}
