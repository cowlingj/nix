{ 
  inputs,
  pkgs,
  lib,
  ...
}: {

  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services.xserver.enable = false;

  programs.ssh.startAgent = false;

  # Configure console keymap
  console.keyMap = "uk";

  services.fwupd.enable = true;

  # https://community.frame.work/t/framework-nixos-linux-users-self-help/31426/55
  powerManagement.powertop.enable = true;
  services.fstrim.enable = true;

  programs.zsh.enable = true;
  programs.zsh.interactiveShellInit = ''
    bindkey -v
    bindkey '^R' history-incremental-search-backward
  '';
  environment.pathsToLink = [ "/share/zsh" ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    git-lfs
    vim
    lvm2
    findutils
    busybox
    usbutils
  ];

  nix = let
    # flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in
  {
    optimise.automatic = true;
    settings = {
      auto-optimise-store = true;
      experimental-features = "nix-command flakes";
      flake-registry = "";
      download-buffer-size = 512 * 1024 * 1024;
    };

    # # make flake registry and nix path match flake inputs
    # registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    # nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

    services.openssh = {
      enable = true;
      ports = [ 22 ];
      knownHosts = {
        "jonathan" = let publicKey = import ./public-key.nix; in {
          inherit publicKey;
          hostNames = [ "coffee" "highwind" "excalibur" ];
        };
      };
      settings = {
        PasswordAuthentication = false;
      };
      
    };

    virtualisation.podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    virtualisation.containers.registries.search = [ "docker.io" ];

    users.groups.podman = {};

    users.groups.server = {
      gid = 1000;
    };
    users.users.server = {
      uid = 1000;
      group = "server";
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" "podman" ];
      shell = pkgs.zsh;
      subUidRanges = [
        {
          count = 65536;
          startUid = 100000;
        }
      ];
      subGidRanges = [
        {
          count = 65536;
          startGid = 100000;
        }
      ];
    };

  system.autoUpgrade = {
    enable = true;
    flake = "github:cowlingj/nix#radiant-garden";
    allowReboot = true;
    dates = "05:00";
    runGarbageCollection = true;
  };

  system.stateVersion = "24.11";
}