{
  description = "Pio's multi-device NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    codex-cli = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    claude-code,
    codex-cli,
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
              claude-code-nix = claude-code.packages.${system}.default;
              codex-cli-nix = codex-cli.packages.${system}.default;
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
