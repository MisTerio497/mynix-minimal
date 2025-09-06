{ pkgs, lib, inputs, ...}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];
  programs.spicetify = {
      enable = true;
      wayland = true;
      theme = lib.mkForce spicePkgs.themes.catppuccin;
      enabledExtensions = with spicePkgs.extensions; [ adblock ];
      colorScheme = lib.mkForce "mocha";
    };
}