{ config, pkgs, ... }:
{

  imports = [
    ./hardware-configuration.nix
  ];

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  users.users.claudia = {
    isNormalUser = true;
    description = "Claudia";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "claudia";

  # TODO: check before applying
  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/6132ba63-c9d7-403e-89fe-e0000f83432c"; # ???
    fsType = "vfat";
    options = [
      "umask=0077"
    ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d7e71166-98c7-4dd5-8c3a-43d4330786f5";
    label = "Root";
    fsType = "ext4";
    options = [
      "noatime"
      "errors=remount-ro"
    ];
  };
  fileSystems."/mnt/linux-tera" = {
    device = "/dev/disk/by-uuid/b90231ac-c7c0-4569-b605-924df5591a02";
    fsType = "ext4";
    options = [
      "noatime"
      "errors=remount-ro"
    ];
  };
  fileSystems."/home/claudia" = {
    device = "/dev/disk/by-uuid/6b49ede1-0b20-4b7d-8d4a-b7fd75ac6a65";
    fsType = "ext4";
    options = [
      "noatime"
      "errors=remount-ro"
    ];
  };
  fileSystems."/mnt/linux-tera2" = {
    device = "/dev/disk/by-uuid/c79a0f37-a3ef-490e-a3bb-ff3d16aabfeb";
    fsType = "ext4";
    options = [
      "noatime"
      "errors=remount-ro"
    ];
  };
}
