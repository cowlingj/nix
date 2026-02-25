{ pkgs, pkgs-stable, config, ... }:
{
  services.flatpak.enable = true;
  services.flatpak.packages = [
    "com.usebottles.bottles"
    "com.github.tchx84.Flatseal"
    "com.bambulab.BambuStudio"
    "org.freecad.FreeCAD"
  ];
  services.flatpak.uninstallUnmanaged = true;
  services.podman.enable = true;
  programs.zsh.enable = true;
  programs.zsh.initContent = ''
    bindkey -v
    bindkey '^R' history-incremental-search-backward
  '';
  programs.zsh.dotDir = "${config.xdg.configHome}/zsh";
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };
  home.packages = with pkgs; [
    # communcation
    discord
    discover-overlay

    # utility
    google-chrome
    obsidian
    unar
    p7zip-rar
    unrar
    xarchiver
    curl
    protonvpn-gui
    libwacom
    showtime
    ventoy-full-gtk

    # privacy
    bitwarden-desktop
    bitwarden-cli
    encfs
    gencfsm

    # development
    vscode
    bruno
    bruno-cli
    # podman
    podman-desktop
    podman-compose
    lunacy

    # emulation
    pcsx2

    # design
    pkgs-stable.krita
    pkgs-stable.openscad
    godot_4
    blender
    pixelorama

    # games
    prismlauncher
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-gtk3-1.1.10"
  ];
}
