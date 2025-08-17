{
  programs.fish = {
    enable = true;
    shellAliases = {
      zed = "zeditor";
      cls = "clear";
      ll = "ls -la";
      re = "nh os switch";
      up = "nh home switch";
      helix = "hx";
    };
    interactiveShellInit = ''
      set -U fish_greeting ""
    '';
  };
}
