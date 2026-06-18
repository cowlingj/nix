{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name  = "cowlingj";
      user.email = "19248800+cowlingj@users.noreply.github.com";
      gpg.format = "ssh";
      push = { autoSetupRemote = true; };
      init.defaultBranch = "main";
      "lfs \"extension.git-crypt\"" = {
        clean = "git-crypt clean";
      smudge = "git-crypt smudge";
      priority = 0;
      };
      "lfs \"extension.git-crypt.diff\"".textconv = "git-crypt diff";
    };
  };
}