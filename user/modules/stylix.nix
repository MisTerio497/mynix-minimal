{ pkgs, inputs, ... }:
{
  imports = [
    inputs.stylix.homeModules.stylix
  ];
  stylix = {
    enable = true;
    image = ./../walpapers/anime-tayn.jpg;
    # cursor = {
    #   package = pkgs.google-cursor;
    #   name = "GoogleDot-Red";
    #   size = 20;
    # };
  };
}
