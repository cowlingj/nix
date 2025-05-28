{
  description = "nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    firefox-addons.url = "git+https://gitlab.com/rycee/nur-expressions.git?dir=/pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
  in {
    packages = import ./pkgs nixpkgs.legacyPackages.${system};
    formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
    overlays = import ./overlays {inherit inputs;};

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      "highwind" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs; hostname = "highwind";};
        modules = [
          ./nixos/configuration.nix
          ./nixos/systems/highwind
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "jonathan@highwind" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs outputs system; };
        modules = [
          ./home-manager/home.nix
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
          ./home-manager/users/jonathan
        ];
      };
    };
  };
}