{ pkgs, ... }:

{
  services.flatpak.enable = true;

  system.activationScripts.flathub = ''
    if ! ${pkgs.flatpak}/bin/flatpak remotes --system --columns=name | ${pkgs.gnugrep}/bin/grep -qx flathub; then
      ${pkgs.flatpak}/bin/flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || \
        echo "warning: could not add flathub remote during activation (network may be unavailable)"
    fi
  '';

  services.tumbler.enable = true;
  services.geoclue2.enable = true;
  services.blueman.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  hardware.enableAllFirmware = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        ControllerMode = "dual";
        FastConnectable = "true";
        Experimental = "true";
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security.polkit.enable = true;
  security.apparmor = {
    enable = true;
    killUnconfinedConfinables = true;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.dirty_ratio" = 15;
    "vm.dirty_background_ratio" = 5;
    "net.core.default_qdisc" = "cake";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };
}
