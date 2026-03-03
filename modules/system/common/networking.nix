{ hostname, ... }:

{
  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3000 53317 ];
    allowedUDPPorts = [ 53317 ];
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  services.printing.enable = true;
}
