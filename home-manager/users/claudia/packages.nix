{ pkgs, ... }: {
  programs.firefox.enable = true;
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
    discord
    discover-overlay
    signal-desktop
    
    # utility
    firefox
    obsidian
    curl
    protonvpn-gui
    libwacom
    vlc
    calibre
    pdfarranger
    evince
    libreoffice-still
    flatpak

    # privacy
    bitwarden-desktop
    bitwarden-cli

    # development
    vscode

    # design
    krita

    # remote file handling
    qbittorrent
    unar
    p7zip-rar
    xarchiver
    dropbox
  ];
}