# Laptop power management
{ config, lib, pkgs, ... }:

let
  cfg = config.pio.features.laptop;
in {
  options.pio.features.laptop = {
    enable = lib.mkEnableOption "Laptop power management";

    lidAction = lib.mkOption {
      type = lib.types.enum [ "suspend" "poweroff" "lock" "ignore" ];
      default = "poweroff";
      description = "Action when laptop lid is closed";
    };

    suspendEnabled = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Allow system suspend (disabled by default)";
    };
  };

  config = lib.mkIf cfg.enable {
    # Power profiles daemon for dynamic power management
    services.power-profiles-daemon.enable = true;

    # Lid and power button behavior
    services.logind.settings.Login = {
      HandleLidSwitch = cfg.lidAction;
      HandleLidSwitchDocked = "ignore";
      HandleSuspendKey = if cfg.suspendEnabled then "suspend" else "ignore";
    };

    # Disable suspend/hibernate if not wanted
    systemd.targets = lib.mkIf (!cfg.suspendEnabled) {
      "suspend".enable = false;
      "hibernate".enable = false;
      "hybrid-sleep".enable = false;
    };
  };
}
