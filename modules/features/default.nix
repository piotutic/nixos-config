# Feature modules - all imported but disabled by default
# Enable features per-host with pio.features.<name>.enable = true
{ ... }:

{
  imports = [
    ./desktop.nix
    ./docker.nix
    ./mullvad.nix
    ./plymouth.nix
    ./auto-commit.nix
    ./nvidia.nix
    ./gaming.nix
    ./laptop.nix
  ];
}
