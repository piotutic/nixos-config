# Networking configuration
{ config, lib, pkgs, hostname, ... }:

{
  # Hostname (passed via specialArgs)
  networking.hostName = hostname;

  # NetworkManager
  networking.networkmanager.enable = true;

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3000 53317 ]; # Next.js dev server, LocalSend
    allowedUDPPorts = [ 53317 ]; # LocalSend
  };

  # Timezone
  time.timeZone = "America/New_York";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Printing
  services.printing.enable = true;
}
