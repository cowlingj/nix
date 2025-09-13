{ pkgs, ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "ventoy-1.1.07"
      ];
    };
  };
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    git-crypt
    ventoy
  ];
}
