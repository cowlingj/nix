{
  description = "nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    firefox-addons.url = "git+https://gitlab.com/rycee/nur-expressions.git?dir=/pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
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
            hostname = "highwind";
          };
          modules = [
            ./nixos/systems/base
            ./nixos/systems/highwind
          ];
        };
        "excalibur" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            hostname = "excalibur";
          };
          modules = [
            ./nixos/systems/base
            ./nixos/systems/excalibur
            ./nixos/users/base
            ./nixos/users/jonathan
          ];
        };
        "coffee" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            hostname = "coffee";
          };
          modules = [
            ./nixos/systems/base
            ./nixos/systems/coffee
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
            pkgs-stable = nixpkgs-stable.legacyPackages.x86_64-linux;
          };
          modules = [
            inputs.nix-flatpak.homeManagerModules.nix-flatpak
            ./home-manager/users/base
            ./home-manager/users/jonathan
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
