

{ config, pkgs, ... }: {
  imports = [
    ./firefox.nix
    ./packages.nix
    ./github.nix
  ];

  programs.home-manager.enable = true;
  home.username = "jonathan";
  home.homeDirectory = "/home/jonathan";

  home.sessionVariables = {
    EDITOR = "vim";
    DOCKER_HOST = "unix://1000/podman/podman.sock";
    SSH_AUTH_SOCK="/home/jonathan/.bitwarden-ssh-agent.sock";
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
    "desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}
