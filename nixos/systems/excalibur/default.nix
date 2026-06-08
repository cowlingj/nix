{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.extraEntries."manjaro.conf" = ''
    title Manjaro
    efi /efi/Manjaro/grubx64.efi
  '';

  # services.fwupd.daemonSettings.DisabledPlugins = [ "synaptics_mst" ];
  services.fwupd.extraRemotes = [ "lvfs-testing" ];

  services.fprintd.enable = true;

  # https://community.frame.work/t/framework-nixos-linux-users-self-help/31426/55
  powerManagement.powertop.enable = true;
  services.fstrim.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jonathan = {
    isNormalUser = true;
    description = "Jonathan";
    extraGroups = [ "networkmanager" "wheel" "podman" ];
    shell = pkgs.zsh;
    subUidRanges = [
      {
        count = 65536;
        startUid = 100000;
      }
    ];
    subGidRanges = [
      {
        count = 65536;
        startGid = 100000;
      }
    ];
  };
  users.groups.podman = {};

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "jonathan";

    # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.defaultSession = "gnome";
  services.udev.packages = [ pkgs.gnome-settings-daemon ];
  environment.gnome.excludePackages = (
    with pkgs;
    [
      atomix
      cheese
      epiphany
      evince
      geary
      gedit
      gnome-characters
      gnome-music
      gnome-photos
      gnome-terminal
      gnome-tour
      hitori
      iagno
      tali
      totem
      gnome-tour
      gnome-user-docs
      gnome-weather
      gnome-maps
      gnome-contacts
      gnome-software
      yelp
      snapshot
    ]
  );
  services.gnome.gcr-ssh-agent.enable = false;

  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings = {
        dns_enabled = true;
    };
  };

  system.stateVersion = "24.11";
}
