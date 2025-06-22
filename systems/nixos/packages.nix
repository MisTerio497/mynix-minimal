{ pkgs, ... }:
{
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
