{
  pkgs,
  inputs,
  ...
}:
let
  zen-browser = inputs.zen-browser.packages.${pkgs.system}.default;
in {
  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;
  programs.chromium = {
    enable = true;
  };
  programs.spicetify = {
    enable = true;
  };
  home.packages = with pkgs; [
    zen-browser
    vesktop
    prismlauncher
    krita
    _64gram
    mpv
    usbutils
    pciutils
    system-config-printer
    kitty
  ];
}
