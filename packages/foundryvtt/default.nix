{
  nixpkgs.overlays = [
    (final: prev: {
      foundryvtt =
        with final;
        stdenv.mkDerivation (finalAttrs: rec {
          name = "foundryvtt";
          version = "364";
          src = ./FoundryVTT-Node-14.${finalAttrs.version}.zip;
          sourceRoot = ".";
          nativeBuildInputs = [ unzip ];
          unpackPhase = ''
            mkdir -p $out/opt/${name}
            unzip -d $out/opt/${name} ${finalAttrs.src}
          '';
          installPhase = ''
            runHook preInstall

            mkdir -p $out/share/icons/hicolor/512x512/apps
            ln -s $out/opt/${name}/public/icons/vtt-512.png $out/share/icons/hicolor/512x512/apps/${name}.png

            runHook postInstall
          '';
        });
        foundryvtt-wrapper =
          with final;
          pkgs.stdenv.mkDerivation rec {
            name = "foundryvtt-wrapper";
            buildCommand = let
              script = writeShellApplication {
                name = "foundryvtt";
                runtimeInputs = [ nodejs foundryvtt ];
                text = "node ${foundryvtt}/opt/foundryvtt";
              };
              desktopEntry = pkgs.makeDesktopItem {
                name = name;
                desktopName = "foundryvtt";
                exec = "${script}";
                terminal = true;
                icon = "foundryvtt.png";
              };
            in ''
              mkdir -p $out/bin
              cp ${script}/bin/foundryvtt $out/bin
              mkdir -p $out/share/applications
              cp ${desktopEntry}/share/applications/${name}.desktop $out/share/applications/${name}.desktop
            '';
            dontBuild = true;
          };
    })
  ];
}
