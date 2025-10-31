{ pkgs, ...}:
{
  fonts.packages = with pkgs; [
    darwin.apple_sf_compact
    darwin.apple_sf_mono
    darwin.apple_sf_pro

    # Или другие шрифты с поддержкой символов Apple
    noto-fonts
    noto-fonts-emoji
    dejavu_fonts

    # Шрифты с хорошей поддержкой Unicode
    freefont_ttf
    corefonts
  ];
  fonts.fontDir.enable = true;
}