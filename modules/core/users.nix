# User accounts configuration
{ config, lib, pkgs, ... }:

{
  # Main user
  users.users.pio = {
    isNormalUser = true;
    description = "Pio";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # Nix-ld for dynamic linking
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs here
  ];

  # Sudo for wheel without password
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Base system packages (user apps via Home Manager)
  environment.systemPackages = with pkgs; [ ];
}
