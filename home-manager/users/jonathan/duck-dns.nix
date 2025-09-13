{ pkgs, ... }: {
  systemd.user.timers."duck-dns" = {
    Unit = {
      Description = "Periodically run duck-dns.service";
    };
    Install = {
      WantedBy = ["timers.target"];
    };

    Timer = {
      OnBootSec = "1m";
      OnUnitActiveSec = "1h";
      Unit = "duck-dns.service";
    };
  };
  systemd.user.services."duck-dns" = let token = import ./duck-dns.token.nix; in {
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "update-ddns" ''
        set -eu
        ${pkgs.curl}/bin/curl "https://www.duckdns.org/update?domains=traverse-town&token=${token}&ip="
      ''}";
    };

    Unit = {
      Description = "Update duckdns entry";
    };
  };
}