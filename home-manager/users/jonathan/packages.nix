{ pkgs, config, ... }:
{
  services.flatpak.enable = true;
  services.flatpak.packages = [
    "com.usebottles.bottles"
    "com.github.tchx84.Flatseal"
    "com.bambulab.BambuStudio"
    "com.icons8.Lunacy"
  ];
  services.flatpak.uninstallUnmanaged = true;
  services.podman.enable = true;
  systemd.user.targets.podman = {
    Install.WantedBy = ["default.target"];
    Unit = {
      Wants = ["podman.service"];
    };
  };
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
    dconf-editor
    google-chrome
    obsidian
    unar
    p7zip-rar
    unrar
    xarchiver
    curl
    proton-vpn
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
    podman-desktop
    podman-compose

    # emulation
    pcsx2

    # design
    krita
    openscad
    godot_4
    blender
    pixelorama
    freecad
    inkscape
    rpi-imager

    # games
    prismlauncher
  ];
}
