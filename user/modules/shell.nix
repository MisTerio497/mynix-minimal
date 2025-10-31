{ username, hostname, ...}:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      zed = "zeditor";
      cls = "clear";
      ll = "ls -la";
      re = "sudo nixos-rebuild switch --flake ~/mynix-minimal#${hostname}";
      up = "home-manager switch --flake ~/mynix-minimal#${username}";
      helix = "hx";
    };
    interactiveShellInit = ''
      set -U fish_greeting ""
    '';
  };
}
