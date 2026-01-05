{
  description = "Pio's multi-device NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    claude-code,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    # Helper function to create host configurations
    mkHost = {
      hostname,
      enableVideoEditing ? false,
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs hostname;
        };
        modules = [
          ./hosts/common
          ./hosts/${hostname}

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.pio = {pkgs, ...}: {
              imports =
                [
                  ./home/common.nix
                  ./home/packages/base.nix
                  ./home/packages/development.nix
                ]
                ++ (
                  if enableVideoEditing
                  then [./home/packages/video-editing.nix]
                  else []
                );
            };
            home-manager.extraSpecialArgs = {
              claude-code-nix = claude-code.packages.${system}.default;
            };
          }
        ];
      };
  in {
    nixosConfigurations = {
      # HP 255 G - Weak laptop (no video editing)
      hp-laptop = mkHost {
        hostname = "hp-laptop";
        enableVideoEditing = false;
      };

      # Zenith Desktop - Ryzen 7600 + RTX 4060
      zenith = mkHost {
        hostname = "zenith";
        enableVideoEditing = true;
      };

      # Future devices - uncomment and add hardware.nix when ready:
      #
      # thinkpad = mkHost {
      #   hostname = "thinkpad";
      #   enableVideoEditing = false;  # or true if capable
      # };
      #
      # desktop = mkHost {
      #   hostname = "desktop";
      #   enableVideoEditing = true;
      # };
    };
  };
}
