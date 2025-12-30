# Common NixOS configuration shared across all hosts
{ config, pkgs, lib, hostname, ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname (passed via specialArgs)
  networking.hostName = hostname;

  # Timezone
  time.timeZone = "America/New_York";

  # Networking
  networking.networkmanager.enable = true;

  # Firewall rules
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3000 53317 ]; # Next.js dev server, LocalSend
    allowedUDPPorts = [ 53317 ]; # LocalSend
  };

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Printing
  services.printing.enable = true;

  # Audio: PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Nix features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Unfree allowed globally
  nixpkgs.config.allowUnfree = true;

  # Users
  users.users.pio = {
    isNormalUser = true;
    description = "Pio";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

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

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # Match initial install's state version
  system.stateVersion = "25.05";
}
