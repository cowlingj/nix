{ pkgs, ... }:
{
  systemd.user.services.flatpak-repo = {
    unitConfig.ConditionUser = "jonathan";
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
  systemd.user.targets.podman = {
    unitConfig.ConditionUser = "";
    wantedBy = ["default.target"];
    wants = ["podman.service"];
  };
}