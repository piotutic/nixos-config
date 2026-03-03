{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.defaultSession = "gnome";

  environment.gnome.excludePackages = with pkgs; [
    totem
    epiphany
    geary
    gnome-music
    gnome-photos
    simple-scan
    yelp
  ];
}
