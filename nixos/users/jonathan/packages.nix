{ pkgs, pkgs-stable, ... }:
{
  # services.flatpak.enable = true;
  # services.flatpak.packages = [
  #   "com.usebottles.bottles"
  #   "com.github.tchx84.Flatseal"
  #   "com.bambulab.BambuStudio"
  #   "com.icons8.Lunacy"
  #   "org.raspberrypi.rpi-imager"
  # ];
  # services.flatpak.uninstallUnmanaged = true;

  users.users.jonathan.packages = with pkgs; [
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
    proton-vpn
    libwacom
    showtime
    ventoy-full-gtk

    # privacy
    bitwarden-desktop
    # bitwarden-cli
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
    inkscape

    # games
    prismlauncher

    flatpak
    gnomeExtensions.appindicator
    gnomeExtensions.system-monitor
    gnomeExtensions.wireless-hid
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-gtk3-1.1.12"
    "electron-39.8.10"
  ];
}
