{ pkgs, inputs, ... }:
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
    theme = spicePkgs.themes.catppuccin;
    enabledExtensions = with spicePkgs.extensions; [ adblock ];
    colorScheme = "mocha";  # опционально
  };

  home.packages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.system}.default
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
