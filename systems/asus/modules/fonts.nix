{ inputs, pkgs, ...}:
{
  fonts.packages = with pkgs; [
    inputs.apple-fonts.packages.${pkgs.system}.sf-pro
    inputs.apple-fonts.packages.${pkgs.system}.sf-mono
    inputs.apple-fonts.packages.${pkgs.system}.sf-compact

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