{
  description = "Pio's multi-device NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    llm-agents,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    # Helper function to create host configurations
    mkHost = hostname:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs hostname;
        };
        modules = [
          # Core modules (always enabled)
          ./modules/core

          # Feature modules (loaded but disabled by default)
          ./modules/features

          # Host-specific configuration
          ./hosts/${hostname}.nix

          # Home-manager integration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.pio = import ./home;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              llm-agents-pkgs = llm-agents.packages.${system};
            };
          }
        ];
      };
  in {
    nixosConfigurations = {
      hp-laptop = mkHost "hp-laptop";
      zenith = mkHost "zenith";
    };
  };
}
