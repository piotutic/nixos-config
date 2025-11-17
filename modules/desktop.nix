{
  config,
  lib,
  pkgs,
  ...
}: {
  # GNOME Desktop Environment
  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Exclude unwanted GNOME packages
  environment.gnome.excludePackages = with pkgs; [
    totem # Video player (we have VLC)
    epiphany # Web browser (we have Brave)
    geary # Email client
    gnome-music # Music player
    gnome-photos # Photo viewer
    simple-scan # Scanner utility
    yelp # Help viewer
  ];

  # Desktop packages
  environment.systemPackages = with pkgs; [
    # Core desktop utilities
    gnome-tweaks
    dconf-editor
    gparted
    baobab
    file-roller

    # GNOME extensions
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.user-themes
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.vitals

    # Multimedia
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
    playerctl
    pavucontrol
    loupe
    # gimp - moved to Flatpak

    # System tools
    gnome-screenshot
    evince
    unzip
    zip
    p7zip
    unrar
    tree
    lsof
  ];

  # Services
  services.flatpak.enable = true;

  # Automatically add Flathub repository
  system.activationScripts.flathub = ''
    ${pkgs.flatpak}/bin/flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  '';

  services.tumbler.enable = true;
  services.geoclue2.enable = true;
  services.blueman.enable = true;
  services.gvfs.enable = true;
  services.power-profiles-daemon.enable = true;
  services.udisks2.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Hardware
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

  # XDG portal
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  # Security
  security.polkit.enable = true;
  security.apparmor = {
    enable = true;
    killUnconfinedConfinables = true;
  };

  # Performance optimizations
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.dirty_ratio" = 15;
    "vm.dirty_background_ratio" = 5;
    "net.core.default_qdisc" = "cake";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  services.displayManager.defaultSession = "gnome";
}
