{ pkgs, ... }: {
  # Users
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

  services.fwupd.daemonSettings.DisabledPlugins = [ "synaptics_mst" ];
  services.fwupd.extraRemotes = [ "lvfs-testing" ];

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
      yelp
      snapshot
    ]
  );
  services.gnome.gcr-ssh-agent.enable = false;
}
