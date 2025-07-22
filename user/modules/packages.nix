{ pkgs, inputs, ...}:
{
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;
  programs.mpv.enable = true;
  programs.chromium.enable = true;
  programs.direnv.enable = true;
  programs.emacs.enable = true;
  programs.onlyoffice.enable = true;
  home.packages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.system}.default
    prismlauncher
    qbittorrent
    krita
    blender
    jetbrains.idea-community-bin
    _64gram
    system-config-printer
  ];
}
