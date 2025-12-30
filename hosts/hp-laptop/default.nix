# HP 255 G Laptop - Weak laptop, no video editing
{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/system.nix
    ../../modules/desktop.nix
    ../../modules/containers.nix
    ../../modules/mullvad.nix
    ../../modules/auto-commit.nix
    ../../modules/plymouth.nix
  ];

  # HP-specific: Better power management for laptops
  services.power-profiles-daemon.enable = true;
}
