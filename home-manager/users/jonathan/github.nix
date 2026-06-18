let
  github_ssh_key = "/.ssh/github_ed25519";
in
{ config, ... }:   {
  home.file.github_ssh_key = {
    enable = false;
    source = "${config.home.homeDirectory}/${github_ssh_key}";
    target = "${config.home.homeDirectory}/${github_ssh_key}";
  };
  programs.git = {
    enable = true;
    settings = {
      user.name  = "cowlingj";
      user.email = "19248800+cowlingj@users.noreply.github.com";
      gpg.format = "ssh";
      # user.signingkey = config.home.file.github_ssh_key.target;
      push = { autoSetupRemote = true; };
      init.defaultBranch = "main";
      filter.lfs.clean = "git-lfs clean -- %f";
    };
  };
  programs.ssh.matchBlocks.github = {
    host = "github.com";
    identityFile = config.home.file.github_ssh_key.target;
  };
}