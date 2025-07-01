{
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
}