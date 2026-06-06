{ inputs, pkgs, system, config, ... }: {
  programs.firefox.enable = true;
  programs.firefox.configPath = "${config.xdg.configHome}/mozilla/firefox";
  programs.firefox.profiles.default = {
    id = 0;
    name = "default";
    isDefault = true;
    extensions.packages = with inputs.firefox-addons.packages.${system}; [
      bitwarden
      ublock-origin
      react-devtools
      stylus
      # pwas-for-firefox
      translate-web-pages
      search-by-image
    ];
    bookmarks = {
      force = true;
      settings = [
        {
          name = "Toolbar";
          toolbar = true;
          bookmarks = [
            {
              name = "TTRPG";
              bookmarks = [
                {
                  name = "Spelljammer";
                  tags = [ "D&D" "TTRPG" "foundry" ];
                  keyword = "Spelljammer";
                  url = "http://87.115.224.246:30000/game";
                }
                {
                  name = "D&D Beyond";
                  tags = [ "D&D" "TTRPG" ];
                  keyword = "D&D Beyond";
                  url = "https://www.dndbeyond.com/";
                }
              ];
            }            
          ];
        }
      ];
    };
  };
  # programs.firefox.nativeMessagingHosts = [
  #   pkgs.firefoxpwa
  # ];
}