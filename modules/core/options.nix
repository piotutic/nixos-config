# Option declarations for pio.features.* and pio.home.*
{ lib, ... }:

{
  options.pio = {
    home = {
      videoEditing = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable video editing packages (DaVinci Resolve, ffmpeg)";
      };
    };
  };
}
