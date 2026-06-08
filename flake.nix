{
  description = "nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    firefox-addons.url = "git+https://gitlab.com/rycee/nur-expressions.git?dir=/pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
    in
    {
      formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        "highwind" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./nixos/systems/base
            ./nixos/systems/highwind
            {
              networking.hostName = "highwind";
            }
          ];
        };
        "excalibur" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./nixos/systems/base
            ./nixos/systems/excalibur
            {
              nixpkgs.config.permittedInsecurePackages = [
                "ventoy-gtk3-1.1.12"
                "electron-39.8.10"
              ];
            }
            {
              networking.hostName = "excalibur";
            }
            home-manager.nixosModules.home-manager (
              {lib, ...}: {
                home-manager.extraSpecialArgs = {
                  inherit inputs system;
                };
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.jonathan = {
                  imports = [
                    inputs.nix-flatpak.homeManagerModules.nix-flatpak
                    ./home-manager/users/base
                    ./home-manager/users/jonathan
                  ];
                  systemd.user.timers."duck-dns".Install.WantedBy = lib.mkForce [ ];
                };
              }
            )
          ];
        };
        "coffee" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./nixos/systems/base
            ./nixos/systems/coffee
            {
              networking.hostName = "coffee";
            }
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "jonathan@highwind" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit
              inputs
              outputs
              system
              ;
            pkgs-stable = nixpkgs.legacyPackages.x86_64-linux;
          };
          modules = [
            inputs.nix-flatpak.homeManagerModules.nix-flatpak
            ./packages/foundryvtt
            ./home-manager/users/base
            ./home-manager/users/jonathan
            {
              nixpkgs.config.permittedInsecurePackages = [
                "ventoy-gtk3-1.1.12"
                "electron-39.8.10"
              ];
            }
          ];
        };
        "claudia@highwind" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit
              inputs
              outputs
              system
              ;
          };
          modules = [
            inputs.nix-flatpak.homeManagerModules.nix-flatpak
            ./home-manager/users/base
            ./home-manager/users/claudia
          ];
        };
        "claudia@coffee" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit
              inputs
              outputs
              system
              ;
          };
          modules = [
            inputs.nix-flatpak.homeManagerModules.nix-flatpak
            ./home-manager/users/base
            ./home-manager/users/claudia
          ];
        };
      };
    };
}
