# NVIDIA GPU support
{ config, lib, pkgs, ... }:

let
  cfg = config.pio.features.nvidia;
in {
  options.pio.features.nvidia = {
    enable = lib.mkEnableOption "NVIDIA GPU support";

    cuda = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include CUDA toolkit and GPU monitoring";
    };
  };

  config = lib.mkIf cfg.enable {
    # NVIDIA proprietary drivers
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      open = false; # Proprietary for best performance
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # Graphics/Vulkan (32-bit for Steam/Wine)
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # CUDA and GPU monitoring (optional)
    environment.systemPackages = lib.mkIf cfg.cuda (with pkgs; [
      cudatoolkit
      nvtopPackages.nvidia
    ]);
  };
}
