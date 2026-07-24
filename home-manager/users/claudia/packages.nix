{ pkgs, ... }: {
  programs.firefox.enable = true;
  programs.firefox.configPath = "${config.xdg.configHome}/mozilla/firefox";
  services.flatpak.enable = true;
  services.flatpak.packages = [
    "com.github.tchx84.Flatseal"
    "com.bambulab.BambuStudio"
  ];
  services.flatpak.uninstallUnmanaged = false;
  programs.zsh.enable = true;
  programs.zsh.initContent = ''
    bindkey -v
    bindkey '^R' history-incremental-search-backward
  '';
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };
  home.packages = with pkgs; [
    # communcation
    discover-overlay
    #signal-desktop

    # games
    prismlauncher
    
    # utility
    obsidian
    curl
    proton-vpn
    libwacom
    vlc
    calibre
    pdfarranger
    evince
    libreoffice-still
    flatpak
    zotero
    blanket

    # privacy
    bitwarden-desktop
    bitwarden-cli

    # development
    vscode

    # design
    krita
    jellyfin-ffmpeg

    # remote file handling
    qbittorrent
    unar
    p7zip-rar
    xarchiver
    dropbox
    switcheroo
    foliate
  ];
}