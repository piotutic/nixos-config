{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    dconf-editor
    gparted
    baobab
    file-roller
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
    gnome-screenshot
    evince
    unzip
    zip
    p7zip
    unrar
    tree
    lsof
  ];
}
