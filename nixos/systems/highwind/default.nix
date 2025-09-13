{ config, pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
  ];

  # Graphics
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver.videoDrivers = ["nvidia"];

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
  environment.gnome.excludePackages = (
    with pkgs;
    [
      gnome-software
    ];
}
