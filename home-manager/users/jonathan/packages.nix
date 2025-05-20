{ pkgs, ... }: {
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
    bottles
    pcsx2

    # design
    krita # TODO: grab krita settings file
    freecad
    openscad
    godot_4
    blender
    bambu-studio
  ];
}