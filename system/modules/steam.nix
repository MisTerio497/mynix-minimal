{ inputs, pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    protontricks.enable = true;
    # extraCompatPackages = with pkgs; [
    #   inputs.nix-proton-cachyos.packages.${pkgs.system}.proton-cachyos
    # ]
    ;
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protonup
    heroic
    steam-run
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/ivan/.steam/root/compatibilitytools.d";
  };
}
