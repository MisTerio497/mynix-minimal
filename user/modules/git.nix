{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "MisTerio487";
        email = "ipkovalenko2006@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };
}