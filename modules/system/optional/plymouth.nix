{ ... }:

{
  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };

  boot.consoleLogLevel = 3;

  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
  ];

  boot.loader.timeout = 0;
}
