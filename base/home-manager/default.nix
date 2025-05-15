{ config, pkgs, inputs, username, ... }:

{  
  home.username = username;
  home.homeDirectory = "/home/${username}";
  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  home.packages = with pkgs; [
    # gnome extensions
    gnomeExtensions.appindicator
    gnomeExtensions.system-monitor
    gnomeExtensions.wireless-hid

    # development
    vscode
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    envExtra = ''
      bindkey -e # emacs bindings
      bindkey '^[[1;5D' backward-word # ctrl + left arrow
      bindkey '^[[1;5C' forward-word # ctrl + right arrow
    '';

    history = {
      size = 10000;
      ignoreAllDups = true;
      ignoreSpace = true;
    };
  };
  programs.zsh.oh-my-zsh.enable = true;
  programs.firefox.enable = true;
  
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = [];
      enabled-extensions = with pkgs.gnomeExtensions; [
        appindicator.passthru.extensionUuid
        system-monitor.passthru.extensionUuid
        wireless-hid.passthru.extensionUuid
      ];
    };
    "org/gnome/shell/extensions/wireless-hid" = {
      use-device-levels = true;
    };
    "plugins/power" = {
      power-button-action = "interactive";
      sleep-inactive-ac-type = "nothing";
    };
  };
}
