{ pkgs, ... }:
{
  stylix = {
    enable = true;
    autoEnable = false;
    image = ./../wallpapers/anime-tayn.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-sea.yaml";
    targets = {
      kde.enable = true;
      zed.enable = true;
    };
    # fonts = {
    #   monospace = {
    #     package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
    #     name = "JetBrainsMono Nerd Font Mono";
    #   };
    #   sansSerif = {
    #     package = pkgs.noto-fonts;
    #     name = "Noto Sans";
    #   };
    #   serif = {
    #     package = pkgs.noto-fonts;
    #     name = "Noto Serif";
    #   };
    #   emoji = {
    #     package = pkgs.noto-fonts-emoji;
    #     name = "Noto Color Emoji";
    #   };
    # };
  };
}
