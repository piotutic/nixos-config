# Bootloader configuration
{ config, lib, pkgs, ... }:

{
  # Systemd-boot with EFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Limit boot loader entries
  boot.loader.systemd-boot.configurationLimit = 5;

  # Match initial install's state version
  system.stateVersion = "25.05";
}
