{ inputs, pkgs, system, ... }: {
  programs.firefox.enable = true;
  programs.firefox.profiles.default = {
    id = 0;
    name = "default";
    isDefault = true;
    extensions.packages = with inputs.firefox-addons.packages.${system}; [
      bitwarden
      ublock-origin
      react-devtools
      stylus
      pwas-for-firefox
    ];
  };
  programs.firefox.nativeMessagingHosts = [
    pkgs.firefoxpwa
  ];
}