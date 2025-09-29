{ lib, config, pkgs, ... }:

with lib;

{
  options.disableSuspend.enable = lib.mkEnableOption "Disable suspend/hibernate and replace suspend with shutdown";

  config = lib.mkIf config.disableSuspend.enable {
    # Disable systemd suspend/hibernate targets
    systemd.targets."suspend".enable = false;
    systemd.targets."hibernate".enable = false;
    systemd.targets."hybrid-sleep".enable = false;

    # Configure logind properly with new options
    services.logind.settings.Login = {
      HandleSuspendKey = "ignore";
      HandleLidSwitch = "poweroff";
      HandleLidSwitchDocked = "ignore";
    };
  };
}
