{ lib, pkgs, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;

  programs.chromium.enable = true;

  programs.spicetify = {
    enable = true;
    theme = lib.mkForce spicePkgs.themes.catppuccin;
    enabledExtensions = with spicePkgs.extensions; [ adblock ];
    colorScheme = lib.mkForce "mocha";
  };
  programs.vesktop.enable = true;

  home.packages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.system}.default
    prismlauncher
    krita
    _64gram
    mpv
    usbutils
    pciutils
    system-config-printer
  ];
  programs.gnome-shell = {
    enable = true;
    extensions = with pkgs; [  ];
  };
}
