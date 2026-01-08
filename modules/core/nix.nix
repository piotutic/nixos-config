# Nix settings, flakes, garbage collection, store optimization
{ config, lib, pkgs, ... }:

{
  # Enable flakes and nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages globally
  nixpkgs.config.allowUnfree = true;

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
    persistent = true;
    randomizedDelaySec = "45min";
  };

  # Store optimization
  nix.settings.auto-optimise-store = true;
  nix.optimise = {
    automatic = true;
    dates = [ "03:45" ];
    persistent = true;
    randomizedDelaySec = "45min";
  };
}
