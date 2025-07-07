{
  programs.fish = {
    enable = true;
    shellAliases = {
      zed = "zeditor";
      cls = "clear";
      ll = "ls -la";
      re = "sudo nixos-rebuild switch --impure --flake ~/mynix-minimal#nixos";
      up = "home-manager switch --flake ~/mynix-minimal#ivan -b bak";
      helix = "hx";
    };
  };
}
