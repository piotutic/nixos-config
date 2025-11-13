{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./modules/system.nix
    ./modules/containers.nix
    ./modules/desktop.nix
    ./modules/mullvad.nix
    ./modules/auto-commit.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname and time
  networking.hostName = "nixos";
  time.timeZone = "America/New_York";

  # Networking
  networking.networkmanager.enable = true;

  # 🔒 Firewall rule to allow Next.js dev server
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [3000];
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
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Unfree allowed globally
  nixpkgs.config.allowUnfree = true;

  # Users
  users.users.pio = {
    isNormalUser = true;
    description = "Pio";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  # Sudo for wheel without password (optional, remove if undesired)
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Base system packages (user apps via Home Manager)
  environment.systemPackages = with pkgs; [
  ];

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # Match initial install’s state version
  system.stateVersion = "25.05";
}
