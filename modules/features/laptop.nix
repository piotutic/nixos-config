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
    # TLP for advanced power management (replaces power-profiles-daemon)
    services.power-profiles-daemon.enable = false;
    services.tlp = {
      enable = true;
      settings = {
        # CPU scaling
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        # AMD specific - disable boost on battery for longevity
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;

        # Runtime power management
        RUNTIME_PM_ON_AC = "auto";
        RUNTIME_PM_ON_BAT = "auto";

        # USB autosuspend
        USB_AUTOSUSPEND = 1;

        # WiFi power saving
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";
      };
    };

    # AMD P-State for better power scaling
    boot.kernelParams = [ "amd_pstate=active" ];

    # Battery monitoring tools
    environment.systemPackages = with pkgs; [
      powertop  # Power analysis
      acpi      # Battery status
    ];

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
