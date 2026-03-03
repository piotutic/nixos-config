{ config, lib, ... }:

let
  cfg = config.pio.portable;
in
{
  options.pio.portable = {
    lidAction = lib.mkOption {
      type = lib.types.enum [ "suspend" "poweroff" "lock" "ignore" ];
      default = "poweroff";
      description = "Action when the lid is closed.";
    };

    suspendEnabled = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Allow suspend via logind controls.";
    };
  };

  config = {
    services.logind.settings.Login = {
      HandleLidSwitch = cfg.lidAction;
      HandleLidSwitchDocked = "ignore";
      HandleSuspendKey = if cfg.suspendEnabled then "suspend" else "ignore";
    };

    systemd.targets = lib.mkIf (!cfg.suspendEnabled) {
      "suspend".enable = false;
      "hibernate".enable = false;
      "hybrid-sleep".enable = false;
    };
  };
}
