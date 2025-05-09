let
  nur = import ( builtins.fetchTarball {
    # 2025-02-01
    url = "https://github.com/nix-community/NUR/archive/0565876fdeaad850aa1bf535f12404a75ed571f2.tar.gz";
    sha256 = "1yg64hxi6xzi3i967j4vbgm7hp4ivc44vpq0jzs7c3wx5q5jxsbd";
  }) {};
  home_directory = "/home/jonathan";
  github_ssh_key = "${home_directory}/.ssh/github_ed25519";
  # nixpkgs = import nixpkgs;
in

{ config, pkgs, lib, nix, ... }:

{
  home.stateVersion = "24.11";
  
  home.username = "jonathan";
  home.homeDirectory = home_directory;


  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
    # registry = {
    #    nixos = {
    #     #  from = { type = "indirect"; id = "nixos"; };
    #      flake = nixpkgs;
    #    };
    # };
  };

  home.packages = with pkgs; [
    # communcation
    discord
    
    # utility
    obsidian

    # gnome extensions
    gnomeExtensions.appindicator
    gnomeExtensions.system-monitor
    gnomeExtensions.wireless-hid

    # privacy
    bitwarden-desktop
    bitwarden-cli
    gencfsm  

    # development
    vscode
    bruno
    bruno-cli
    podman
    podman-desktop
    podman-compose
    lunacy

    # emulation    
    bottles
    pcsx2

    # design
    krita # TODO: grab krita settings file
    freecad
    openscad-unstable # openscad
    godot_4
    blender
    bambu-studio

  ];

  home.sessionVariables = {
    EDITOR = "vim";
    DOCKER_HOST = "unix://${builtins.getEnv "XDG_RUNTIME_DIR"}/podman/podman.sock";
    # PODMAN_USERNS = "keep-id";
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
  programs.firefox.profiles.default = {
    id = 0;
    name = "default";
    isDefault = true;
    extensions = with nur.repos.rycee.firefox-addons; [
      bitwarden
      ublock-origin
      react-devtools
      stylus
      pwas-for-firefox
    ];
  };
  programs.firefox.nativeMessagingHosts = [
    pkgs.firefoxpwa
  ];

  programs.git = {
    enable = true;
    userName  = "cowlingj";
    userEmail = "19248800+cowlingj@users.noreply.github.com";
    extraConfig = {
      gpg.format = "ssh";
      # user.signingkey = github_ssh_key;
      push = { autoSetupRemote = true; };
      init.defaultBranch = "main";
    };
  };
  programs.ssh.matchBlocks.github = {
    host = "github.com";
    identityFile = github_ssh_key;
  };

  # Check for necessary ssh keys (does not generate them)
  home.file.github_ssh_key = {
    enable = false;
    source = github_ssh_key;
    target = github_ssh_key;
  };
  home.file.github_ssh_key_pub = {
    enable = false;
    source = "${github_ssh_key}.pub";
    text = ''
      unqualified-search-registries = ["docker.io"]
    '';
    target = "${home_directory}/.config/containers/registries.conf";
  };
  
  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
    };
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
    "org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = true;
    };
    "plugins/power" = {
      power-button-action = "interactive";
      sleep-inactive-ac-type = "nothing";
    };
  };
}
