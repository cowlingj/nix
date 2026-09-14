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
      nixosConfigurations = rec {
        "highwind" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            {
              networking.hostName = "highwind";
              nixpkgs.config.permittedInsecurePackages = [
                "ventoy-gtk3-1.1.12"
                "electron-39.8.10"
                "nexusmods-app-unfree-0.21.1"
              ];
            }
            ./nixos/systems/base
            ./nixos/systems/highwind
            ./nixos/systems/highwind/duck-dns.nix
            home-manager.nixosModules.home-manager {
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
              };
            }
          ];
        };
        "excalibur" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            {
              networking.hostName = "excalibur";           
              nixpkgs.config.permittedInsecurePackages = [
                "ventoy-gtk3-1.1.12"
                "electron-39.8.10"
              ];
            }
            ./nixos/systems/base
            ./nixos/systems/excalibur
            home-manager.nixosModules.home-manager {
              home-manager.extraSpecialArgs = {
                inherit inputs system;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jonathan = {
                imports = [
                  inputs.nix-flatpak.homeManagerModules.nix-flatpak
                  ./packages/foundryvtt
                  ./home-manager/users/base
                  ./home-manager/users/jonathan
                ];
              };
            }
          ];
        };
        "coffee" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            { networking.hostName = "coffee"; }
            ./nixos/systems/base
            ./nixos/systems/coffee
          ];
        };
        "coffee2" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = coffee.modules ++ [
            { networking.hostName = "coffee"; }
            home-manager.nixosModules.home-manager {
              home-manager.extraSpecialArgs = {
                inherit inputs system;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.claudia = {
                imports = [
                  inputs.nix-flatpak.homeManagerModules.nix-flatpak
                  ./home-manager/users/base
                  ./home-manager/users/claudia
                ];
              };
            }
          ];
        };

        radiant-garden = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            { networking.hostName = "radiant-garden"; }
            ./nixos/systems/radiant-garden
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
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


      isoImages = {
        radiant-garden-installer = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            { networking.hostName = "radiant-garden-installer"; }
            ({ modulesPath, ... }: {
              imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
            })
            {
              system.autoUpgrade = {
                enable = true;
                flake = "github:cowlingj/nix-config#radiant-garden";
                allowReboot = true;
                dates = "05:00";
                runGarbageCollection = true;
              };

              system.stateVersion = "24.11";
            }
          ];
        };
      };

    };
}
