{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./packages.nix
  ];

  programs.home-manager.enable = true;
  home.username = "claudia";
  home.homeDirectory = "/home/claudia";

  dconf.settings = with lib.gvariant; {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        appindicator.passthru.extensionUuid
        system-monitor.passthru.extensionUuid
        wireless-hid.passthru.extensionUuid
      ];
    };
  };

  home.packages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.system-monitor
    gnomeExtensions.wireless-hid
  ];
}
