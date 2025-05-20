{outputs, ...}: {
  programs.firefox.enable = true;
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };
  home.stateVersion = "23.11";
}
