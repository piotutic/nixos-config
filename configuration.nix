{ config, pkgs, lib, modulesPath, ... }:

{
  imports =
    let
      repoHwPath = toString ./. + "/hardware-configuration.nix";
      etcHwPath = "/etc/nixos/hardware-configuration.nix";
      hwModule =
        if builtins.pathExists repoHwPath then import repoHwPath
        else if builtins.pathExists etcHwPath then import etcHwPath
        else (throw ''
          Missing hardware-configuration.nix.
          Generate one with: sudo nixos-generate-config
          It will create /etc/nixos/hardware-configuration.nix which this config will import.
        '');
    in [ hwModule ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname and time
  networking.hostName = "nixos";
  time.timeZone = "UTC";

  # Networking
  networking.networkmanager.enable = true;

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # X11 + GNOME (adjust as needed)
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.xserver.xkb.layout = "us";

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
  };

  # Sudo for wheel without password (optional, remove if undesired)
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Base system packages (user apps via Home Manager)
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
  ];

  # Match initial install’s state version
  system.stateVersion = "25.05";
} 