# Core modules - always enabled on all hosts
{ ... }:

{
  imports = [
    ./options.nix
    ./nix.nix
    ./boot.nix
    ./networking.nix
    ./audio.nix
    ./users.nix
  ];
}
