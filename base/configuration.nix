{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
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

  # Enable the X11 windowing system.
  # (the X server implementation is left to the display manager, gdm uses wayland)
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.udev.packages = [ pkgs.gnome-settings-daemon ];

  # remove some default packages
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
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.fwupd.enable = true;
  services.fwupd.extraRemotes = [ "lvfs-testing" ];

  # Power Optimisations
  powerManagement.powertop.enable = true;
  services.fstrim.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jonathan = {
    isNormalUser = true;
    description = "Jonathan";
    extraGroups = [ "networkmanager" "wheel" ];
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
  users.users.claudia = {
    isNormalUser = true;
    description = "Claudia";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "jonathan";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

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
    vim
    wl-clipboard
    fprintd
    ghostty
    lvm2
    usbutils
    showtime # like totem but not broken
  ];

  virtualisation.podman = {
    enable = true;
    # dockerCompat = true;
    # dockerSocket.enable = true;
    defaultNetwork.settings = {
        dns_enabled = true;
    };
  };
  systemd.services.podman.enable = false;
  systemd.sockets.podman.enable = false;

  system.stateVersion = "24.11";
}
