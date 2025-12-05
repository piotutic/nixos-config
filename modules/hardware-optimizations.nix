# Hardware-specific optimizations
# Auto-detects Intel vs AMD from hardware-configuration.nix
{ config, lib, pkgs, ... }:
let
  hasIntel = builtins.elem "kvm-intel" config.boot.kernelModules;
  hasAMD = builtins.elem "kvm-amd" config.boot.kernelModules;
in {
  # === Intel-specific ===
  hardware.cpu.intel.updateMicrocode = hasIntel;
  services.thermald.enable = hasIntel;

  # Load i915 in initrd for early KMS (fixes Plymouth wait)
  # Note: xe driver is for Lunar Lake+, NOT for Meteor Lake GPU in Arrow Lake-H (285H)
  boot.initrd.kernelModules = lib.optionals hasIntel [
    "i915"    # Meteor Lake and older Intel GPUs
  ];

  # Blacklist xe driver - not needed for Meteor Lake GPU (device ID 7d51)
  boot.blacklistedKernelModules = lib.optionals hasIntel [ "xe" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs;
      lib.optionals hasIntel [
        intel-media-driver
        intel-compute-runtime
        vpl-gpu-rt
      ] ++
      lib.optionals hasAMD [
        amdvlk
      ];
  };

  environment.sessionVariables = lib.mkIf hasIntel {
    LIBVA_DRIVER_NAME = "iHD";
  };

  # === AMD-specific ===
  hardware.cpu.amd.updateMicrocode = hasAMD;

  # === Universal laptop optimizations ===

  # Thunderbolt 4 hotplug support
  services.hardware.bolt.enable = true;

  # Faster boot - don't wait for network
  systemd.services.NetworkManager-wait-online.enable = false;

  # Better power management for laptops
  services.upower.enable = true;
}
