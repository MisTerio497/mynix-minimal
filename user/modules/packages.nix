{
  pkgs,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;

  programs.chromium.enable = true;
  
  home.packages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.system}.default
    prismlauncher
    qbittorrent
    krita
    blender
    jetbrains.idea-community-bin
    _64gram
    mpv
    usbutils
    pciutils
    system-config-printer
  ];
}
