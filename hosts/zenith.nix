# Zenith Desktop - Ryzen 7600 + RTX 4060
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware/zenith.nix
  ];

  # Enable features for this host
  pio.features = {
    desktop.enable = true;
    docker.enable = true;
    mullvad.enable = true;
    plymouth.enable = true;
    auto-commit.enable = true;
    nvidia.enable = true;
    nvidia.cuda = true;
    gaming.enable = true;
  };

  # Home-manager package toggles
  pio.home.videoEditing = true;
}
