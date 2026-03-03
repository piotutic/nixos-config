{ ... }:

{
  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };

  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;

  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
  ];

  boot.loader.timeout = 0;
}
