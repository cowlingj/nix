{ config, ... }:   {
  programs.git = {
    enable = true;
    config = {
      user.name  = "cowlingj";
      user.email = "19248800+cowlingj@users.noreply.github.com";
      gpg.format = "ssh";
      push = { autoSetupRemote = true; };
      init.defaultBranch = "main";
    };
  };
  # programs.ssh.matchBlocks.github = {
  #   host = "github.com";
  # };
}
