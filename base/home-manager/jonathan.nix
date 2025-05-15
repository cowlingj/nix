let
  github_ssh_key = "/.ssh/github_ed25519";
in

{ config, pkgs, inputs, system, pkgs-stable, ... }:

{
  # imports = [
  #   <nur>
  # ];

  home.packages = with pkgs; [
    # communcation
    discord
    
    # utility
    obsidian

    # privacy
    bitwarden-desktop
    bitwarden-cli
    encfs
    pkgs-stable.gencfsm

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
    # I might be able to do this if i go down the home manager module route
    # "unix://${config.users.user."${config.home.username}".id}/podman/podman.sock"; 
  };

  programs.firefox.enable = true;
  programs.firefox.profiles.default = {
    id = 0;
    name = "default";
    isDefault = true;
    extensions.packages = with inputs.firefox-addons.packages.${system}; [
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

  # GitHub
  home.file.github_ssh_key = {
    enable = false;
    source = "${config.home.homeDirectory}/${github_ssh_key}";
    target = "${config.home.homeDirectory}/${github_ssh_key}";
  };
  programs.git = {
    enable = true;
    userName  = "cowlingj";
    userEmail = "19248800+cowlingj@users.noreply.github.com";
    extraConfig = {
      gpg.format = "ssh";
      # user.signingkey = config.home.file.github_ssh_key.target;
      push = { autoSetupRemote = true; };
      init.defaultBranch = "main";
    };
  };
  programs.ssh.matchBlocks.github = {
    host = "github.com";
    identityFile = config.home.file.github_ssh_key.target;
  };

  home.file.podman_registries = {
    enable = true;
    text = ''
      unqualified-search-registries = ["docker.io"]
    '';
    target = "${config.home.homeDirectory}/.config/containers/registries.conf";
  };
  
  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
    };
    "org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = true;
    };
  };

  home.stateVersion = "24.11";
}
