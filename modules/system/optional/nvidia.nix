{ config, lib, pkgs, ... }:

let
  cfg = config.pio.nvidia;
in
{
  options.pio.nvidia = {
    cuda = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include CUDA toolkit and GPU monitoring tools.";
    };
  };

  config = {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    environment.systemPackages = lib.optionals cfg.cuda (with pkgs; [
      cudatoolkit
      nvtopPackages.nvidia
    ]);
  };
}
