{ config, pkgs, ... }:

{
  # Plymouth boot splash screen
  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };

  # Silent boot configuration with error visibility
  boot.consoleLogLevel = 3;  # Show errors (3) but hide info messages
  boot.initrd.verbose = false;  # Clean early boot

  boot.kernelParams = [
    "quiet"              # Hide most boot messages
    "splash"             # Enable Plymouth splash screen
    "boot.shell_on_fail" # Drop to shell if boot fails (for debugging)
  ];

  # Optional: Hide boot menu for instant boot (comment out if you want to see boot menu)
  boot.loader.timeout = 0;
}
