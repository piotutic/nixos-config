{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ffmpeg-full
    davinci-resolve
  ];
}
