{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./firefox.nix
    ./packages.nix
    ./github.nix
  ];

  environment.sessionVariables = {
    # Make GTK3 file-chooser settings discoverable
    # per https://github.com/NixOS/nixpkgs/issues/467783#issuecomment-3648708206
    GSETTINGS_SCHEMA_DIR ="${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";
  };

  programs.dconf.profiles.user.databases = [
    {
      lockAll = true;
      settings = with lib.gvariant; {
        "org/gnome/desktop/background".picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
        "org/gnome/desktop/peripherals/keyboard".numlock-state = true;
        "org/gnome/desktop/input-sources".sources = mkArray [( mkTuple ["xkb" "gb"])];
        "org/gnome/desktop/interface".color-scheme = "prefer-dark";
        "org/gnome/desktop/session".idle-delay = mkUint32 0;
        "org/gnome/settings-daemon/plugins/power".sleep-inactive-ac-type="nothing";
        "org/gnome/settings-daemon/plugins/power".power-button-action="interactive";
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = with pkgs.gnomeExtensions; [
            appindicator.passthru.extensionUuid
            system-monitor.passthru.extensionUuid
            wireless-hid.passthru.extensionUuid
          ];
        };
        "org/gnome/shell" = {
          favorite-apps = [
            "org.gnome.Nautilus.desktop"
            "firefox.desktop"
            "discord.desktop"
            "code.desktop"
            "com.usebottles.bottles.desktop"
            "com.mitchellh.ghostty.desktop"
          ];
        };
      };
    }
  ];
}
