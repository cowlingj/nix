{ inputs, config, pkgs, hostname, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "${hostname}";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system. (x session is still wayland)
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.udev.packages = [ pkgs.gnome-settings-daemon ];

  # remove default packages
  environment.gnome.excludePackages = with pkgs; [
     gnome-maps
     gnome-weather
     gnome-user-docs
     epiphany
     gnome-tour
     gnome-terminal
     totem
  ];
  services.xserver.excludePackages = [ pkgs.xterm ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.fwupd.enable = true;
  # services.fwupd.daemonSettings.DisabledPlugins = [ "synaptics_mst" ];
  # services.fwupd.extraRemotes = [ "lvfs-testing" ];

  # https://community.frame.work/t/framework-nixos-linux-users-self-help/31426/55
  powerManagement.powertop.enable = true;
  services.fstrim.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  programs.firefox.enable = true;
  programs.steam.enable = true;
  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    vim
    wl-clipboard
    fprintd
    ghostty
    lvm2
    usbutils
    showtime # like totem but not broken
    vscode
    nil
  ];

  services.flatpak.enable = true;

  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings = {
        dns_enabled = true;
    };
  };
  systemd.services.podman.enable = false;
  systemd.sockets.podman.enable = false;

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # channel.enable = false;

    # make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  system.stateVersion = "24.11";
}
