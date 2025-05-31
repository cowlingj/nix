{ pkgs, ... }: {
  services.flatpak.enable = true;
  services.flatpak.packages = [
    "com.usebottles.bottles"
    "com.github.tchx84.Flatseal"
    "com.bambulab.BambuStudio"
  ];
  services.flatpak.uninstallUnmanaged = true;
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
    
    # utility
    obsidian

    # privacy
    bitwarden-desktop
    bitwarden-cli
    encfs
    # gencfsm # FIXME: current is broken and stable not compatible

    # development
    vscode
    bruno
    bruno-cli
    podman
    podman-desktop
    podman-compose
    lunacy

    # emulation    
    # bottles
    pcsx2

    # design
    krita # TODO: grab krita settings file
    freecad
    openscad
    godot_4
    blender
    # bambu-studio
  ];
}