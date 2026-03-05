{ ... }:

{
  imports = [
    ../hardware/hp-laptop.nix
    ./system.nix
  ];

  home-manager.users.pio = import ./home.nix;
}
