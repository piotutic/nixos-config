# HP 255 G Laptop - Weak laptop
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware/hp-laptop.nix
  ];

  # Enable features for this host
  pio.features = {
    desktop.enable = true;
    docker.enable = false; # Too weak for containers
    mullvad.enable = true;
    plymouth.enable = true;
    auto-commit.enable = true;
    laptop.enable = true;
    laptop.lidAction = "poweroff";
  };

  # Home-manager package toggles
  pio.home.videoEditing = false;
}
