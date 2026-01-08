# Home Manager entry point
# Imports common config and conditionally imports packages based on host config
# osConfig is automatically provided by home-manager when using the NixOS module
{ config, pkgs, osConfig, claude-code-nix, ... }:

{
  imports = [
    ./common.nix
    ./packages/base.nix
    ./packages/development.nix
  ] ++ (
    # Conditionally import video editing packages based on host config
    if osConfig.pio.home.videoEditing or false
    then [ ./packages/video-editing.nix ]
    else [ ]
  );
}
