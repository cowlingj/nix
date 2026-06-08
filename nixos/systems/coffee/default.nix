{ pkgs, ... }:
{

  imports = [
    ./hardware-configuration.nix
  ];

  services.flatpak.enable = true;

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

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";
  programs.partition-manager.enable = true;
}
