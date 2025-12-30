# Video editing packages - only for powerful devices
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ffmpeg-full
    davinci-resolve
  ];
}
