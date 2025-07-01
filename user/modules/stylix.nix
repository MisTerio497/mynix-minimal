{ pkgs, ...}:
{
  stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
      image = ./../walpapers/anime-tayn.jpg;
      polarity = "dark";
      cursor = {
        package = pkgs.google-cursor;
        name = "GoogleDot-Red";
        size = 20;
      };
  
      # Целевые компоненты
      targets = {
        gtk.enable = true;
        qt.enable = true;
      };
    };
}