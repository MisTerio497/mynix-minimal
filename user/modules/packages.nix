{
  config,
  pkgs,
  inputs,
  ...
}:
let
  zen-browser = inputs.zen-browser.packages.${pkgs.system}.default;
in {
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    zen-browser
    usbutils
    pciutils
    system-config-printer
    chromium
    kitty
  ];
}
