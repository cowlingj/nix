{ pkgs, ... }:
{
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    git-crypt
    usbimager
  ];
}
