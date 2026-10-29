{ hostname, ... }:

{
  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  networking.firewall.enable = true;

  # Opens LocalSend's port (53317 TCP/UDP) itself.
  programs.localsend.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  services.printing.enable = true;
}
