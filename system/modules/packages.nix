{
  config,
  pkgs,
  inputs,
  ...
}:

let
  winapps = inputs.winapps.packages."${pkgs.system}".winapps;
  agenix = inputs.agenix.packages."${pkgs.system}".default;
in
{

  nixpkgs.config.allowUnfree = true;
  fonts.packages = with pkgs; [
    corefonts
  ];
  programs.java = {
    enable = true;
  };
  services.hardware.openrgb.enable = true;
  environment.systemPackages = with pkgs; [
    pciutils
    home-manager
    efibootmgr
    ventoy-full
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
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
