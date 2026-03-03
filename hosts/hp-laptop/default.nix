{ inputs, ... }:

{
  imports = [
    ../hardware/hp-laptop.nix
    ./system.nix
  ];

  nixpkgs.overlays = [
    inputs.openclaw.overlays.default
  ];

  home-manager.users.pio = import ./home.nix;
}
