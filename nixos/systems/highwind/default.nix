{ config, pkgs, ... }: {
  # Partitions
  fileSystems = {
    "/home/jonathan" = {
      label = "Home";
      fsType = "btrfs";
    };
    "/srv/GamesSSD" = {
      label = "GamesSSD";
      fsType = "ext4";
      options = [
        "users"
        "exec"
        "nofail"
      ];
    };
    "/srv/GamesHDD" = {
      label = "GamesHDD";
      fsType = "ext4";
      options = [
        "users"
        "exec"
        "nofail"
      ];
    };
    "/home/jonathan/.Private" = {
      label = "Jonathan2";
      fsType = "ext4";
      options = [
        "users"
        "nofail"
      ];
    };
  };

  swapDevices = [
    { label = "Swap"; }
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
}
