{ pkgs, inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;
  programs = {
    mpv.enable = true;
    chromium.enable = true;
    direnv.enable = true;
    emacs.enable = true;
    onlyoffice.enable = true;
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-vkcapture
        obs-pipewire-audio-capture
        obs-vaapi
      ];
    };
  };

  home.packages = with pkgs; [
    inputs.nix-photogimp3.packages.${pkgs.system}.default
    inputs.zen-browser.packages.${pkgs.system}.default
    vlc
    prismlauncher
    qbittorrent
    krita
    blender
    libreoffice-qt6
    jetbrains.idea-community-bin
    _64gram
    system-config-printer
  ];
}
