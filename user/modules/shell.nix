{
  programs.fish = {
    enable = true;
    shellAliases = {
      zed = "zeditor";
      cls = "clear";
      ll = "ls -la";
      re = "sudo nh os switch -H nixos";
      up = "nh home switch -c ivan";
      helix = "hx";
    };
    interactiveShellInit = ''
      set -U fish_greeting ""
    '';
  };
}
