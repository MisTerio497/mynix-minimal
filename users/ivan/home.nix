{ pkgs, lib, ... }:
{
  imports = [
    ./packages.nix
    ./zed.nix
  ];
  home = {
    username = "ivan";
    homeDirectory = "/home/ivan";
    stateVersion = "25.05";
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      zed = "zeditor";
      cls = "clear";
      ll = "ls -la";
      re = "sudo nixos-rebuild switch --flake ~/nix#nixos && sh /home/ivan/nix/build.sh";
      helix = "hx";
    };
  };
  programs.git = {
    enable = true;
    userName = "MisTerio487";
    userEmail = "ipkovalenko2006@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };
  
  programs.home-manager.enable = true;
}
