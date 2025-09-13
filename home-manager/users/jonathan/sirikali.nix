{ config, pkgs, ... }: {
  home.file.sirikali_favorite_1 = {
    text = ''
      {
        "autoMountVolume": "false",
        "configFilePath": "",
        "identityAgent": "",
        "identityFile": "",
        "idleTimeOut": "",
        "keyFilePath": "",
        "mountOptions": "",
        "mountPointPath": "/home/jonathan/Private/",
        "mountReadOnly": "false",
        "password": "",
        "postMountCommand": "",
        "postUnmountCommand": "",
        "preMountCommand": "",
        "preUnmountCommand": "",
        "reverseMode": false,
        "volumeNeedNoPassword": false,
        "volumePath": "/home/jonathan/.Private"
      }
    '';
    enable = true;
    target = "${config.home.homeDirectory}/.local/share/SiriKali/favorites/.Private-nix_1.json";
  };

  systemd.user.services = {
    sirikali = {
      Unit = {
        Description = "sirikali";
        Documentation = [ "man:sirikali" ];
      };

      Service = {
        Type = "exec";
        ExecStart = "${pkgs.sirikali}/bin/sirikali -e";
        Restart = "always";
        Environment = [
          "PATH=${config.home.homeDirectory}/.nix-profile/bin"
        ];
      };

      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
