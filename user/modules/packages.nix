{
  pkgs,
  inputs,
  ...
}:
let
  zen-browser = inputs.zen-browser.packages.${pkgs.system}.default;
  affinity-photo = inputs.affinity-nix.packages.${pkgs.system}.photo;
in {
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;
  programs.chromium = {
    enable = true;
  };
  home.packages = with pkgs; [
    zen-browser
    affinity-photo
    usbutils
    pciutils
    system-config-printer
    kitty
  ];
}
