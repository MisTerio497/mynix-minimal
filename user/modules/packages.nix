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
    # inputs.zen-browser.packages.${pkgs.system}.default
    inputs.winapps.packages.${pkgs.system}.winapps
    # (blender.override {
    #   cudaSupport = true;
    # })
    # (pkgs.callPackage ./../pkgs/davinci-resolve-paid.nix  {})
    # (pkgs.callPackage ./../pkgs/xmcl.appimage.nix  {})
    # (pkgs.wrapProgram pkgs.zoom-us {
    #   extraEnv = {
    #     CURSOR_THEME = "Breeze";
    #     XCURSOR_SIZE = "24";
    #   };
    # })
    vlc
    unrar-free
    prismlauncher
    figma-linux
    clang
    cmake
    clang-tools
    ninja
    zoom-us
    handbrake

    # jetbrains-toolbox
    jetbrains.idea-community-bin
    jetbrains.webstorm
    jetbrains.clion
    typescript
    _64gram
    libreoffice-qt6
    hunspellDicts.ru_RU
    # fragments
    qbittorrent
    krita
  ];
  # ++ lib.optionals config.services.desktopManager.plasma6.enable [
  #
  # ]
  # ++ lib.optionals config.services.xserver.desktopManager.gnome.enable [
  #
  # ];
  # xdg.autostart = {
  #   enable = true;
  #   entries = [
  #     "${pkgs._64gram}/share/applications/io.github.tdesktop_x64.TDesktop.desktop"
  #   ];
  # };
}
