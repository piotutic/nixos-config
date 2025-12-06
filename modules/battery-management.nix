# Battery charge limit management
# ASUS: uses asusd/asusctl - set limit via `asusctl -c <value>`
# Other vendors: automatically skipped
{ config, lib, pkgs, ... }:

let
  # Detect ASUS by checking for asus-nb-wmi platform device
  # This is a directory existence check, not a file read (avoids sysfs EOF issues)
  isASUS = builtins.pathExists /sys/devices/platform/asus-nb-wmi;
in {
  options.modules.battery = {
    enableAsus = lib.mkOption {
      type = lib.types.bool;
      default = isASUS;
      description = "Enable ASUS battery management (asusd/asusctl). Auto-detected.";
    };
  };

  config = lib.mkIf config.modules.battery.enableAsus {
    services.asusd = {
      enable = true;
      enableUserService = true;
    };

    environment.systemPackages = [ pkgs.asusctl ];
  };
}
