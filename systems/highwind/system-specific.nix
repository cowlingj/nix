{ config, lib, pkgs, modulesPath, ... }:

{
  # Partitions
  fileSystems = {
    "/home/_jonathan" = {
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
    "/srv/GamesPrivate" = {
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

  # Networking
  networking.hostName = "highwind";

  # Devices
  services.udev.extraRules = ''
    # headset
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="03f0", ATTRS{idProduct}=="0abe", ATTR{power/wakeup}="enabled"
    # hesdset
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="03f0", ATTRS{idProduct}=="08be", ATTR{power/wakeup}="enabled"
    # keyboard/ mouse
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c541", ATTR{power/wakeup}="enabled"
    # keyboard/ mouse
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c547", ATTR{power/wakeup}="enabled"
    # controller
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="028e", ATTR{power/wakeup}="enabled"
    # hub(s)
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="05e3", ATTRS{idProduct}=="0610", ATTR{power/wakeup}="enabled"
  '';
}
