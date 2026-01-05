# Zenith Desktop - Ryzen 7600 + RTX 4060
{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/system.nix
    ../../modules/desktop.nix
    ../../modules/containers.nix
    ../../modules/mullvad.nix
    ../../modules/auto-commit.nix
    ../../modules/plymouth.nix
  ];

  # NVIDIA RTX 4060 - Proprietary drivers for gaming/CUDA
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;  # Proprietary for best performance
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Graphics/Vulkan (32-bit for Steam/Wine)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # CUDA and GPU monitoring
  environment.systemPackages = with pkgs; [
    cudatoolkit
    nvtopPackages.nvidia
  ];

  # Steam + Proton gaming
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;
}
