{
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
}