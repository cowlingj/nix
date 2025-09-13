{
  description = "nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
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
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      secrets = import ./secrets;
    in
    {
      formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        "highwind" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs secrets;
            hostname = "highwind";
          };
          modules = [
            ./nixos/systems/base
            ./nixos/systems/highwind
          ];
        };
        "tempest" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs secrets;
            hostname = "tempest";
          };
          modules = [
            ./nixos/systems/base
            ./nixos/systems/tempest
          ];
        };
        "coffee" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs secrets;
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
              secrets
              ;
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
              secrets
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
              secrets
              ;
          };
          modules = [
            inputs.nix-flatpak.homeManagerModules.nix-flatpak
            ./home-manager/users/base
            ./home-manager/users/claudia
          ];
        };
    };
}
