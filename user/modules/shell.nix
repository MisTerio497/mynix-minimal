{ username, hostname, pkgs, ... }:
let
  deploy = "sh /home/${username}/mynix-minimal/deploy.sh";
in
{
  programs.fish = {
    enable = true;
    shellAliases = {
      zed = "zeditor";
      cls = "clear";
      ll = "ls -la";
      re = "sudo nixos-rebuild switch --flake ~/mynix-minimal#${hostname} && ${deploy}";
      up = "home-manager switch --flake ~/mynix-minimal#${username}";
      helix = "hx";
    };
    interactiveShellInit = ''
      set -U fish_greeting ""
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    '';
  };
}
