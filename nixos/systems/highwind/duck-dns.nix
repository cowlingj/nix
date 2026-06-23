{ pkgs, ... }: {
  systemd.services."duck-dns" = {
    serviceConfig = let token = import ./duck-dns.token.nix; in {
      Type = "oneshot";
      ExecStart = "${pkgs.curl}/bin/curl 'https://www.duckdns.org/update?domains=traverse-town&token=${token}&ip='";
    };
    description = "Update duckdns entry";
  };

  systemd.timers."duck-dns" = {
    wantedBy = ["multi-user.target"];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true; 
      Unit = "duck-dns.service";
    };
  };

  environment.systemPackages = with pkgs; [
    curl
  ];
}