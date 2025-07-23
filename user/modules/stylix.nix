{ pkgs, inputs, ... }:
{
  stylix = {
    enable = true;
    autoEnable = false;
    image = ./../wallpapers/anime-tayn.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";
    polarity = "dark";
    targets = {
      gtk.enable = true;
      qt.enable = true;
      kde.enable = true;
    };
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        name = "JetBrainsMono Nerd Font Mono";
      };
      # sansSerif = {
      #   package = pkgs.dejavu_fonts;
      #   name = "DejaVu Sans";
      # };
      # serif = {
      #   package = pkgs.dejavu_fonts;
      #   name = "DejaVu Serif";
      # };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
