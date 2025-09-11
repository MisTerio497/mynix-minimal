{
  pkgs,
  inputs,
  username,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;
  programs = {
    mpv.enable = true;
    chromium.enable = true;
    direnv.enable = true;
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
    inputs.zen-browser.packages.${pkgs.system}.default
    # (blender.override {
    #   cudaSupport = true;
    # })
    # (pkgs.callPackage ./../pkgs/davinci-resolve-paid.nix  {})
    # (pkgs.callPackage ./../pkgs/xmcl.appimage.nix  {})
    vlc
    unrar-free
    prismlauncher
    qbittorrent
    krita
    libreoffice-qt6
    # jetbrains-toolbox
    jetbrains.idea-community-bin
    jetbrains.webstorm
    typescript
    _64gram
    system-config-printer
  ];
  xdg.autostart = {
    enable = true;
    entries = [
      "${pkgs._64gram}/share/applications/io.github.tdesktop_x64.TDesktop.desktop"
    ];
  };
}
