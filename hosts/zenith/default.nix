{ ... }:

{
  imports = [
    ../hardware/zenith.nix
    ./system.nix
  ];

  home-manager.users.pio = import ./home.nix;
}
