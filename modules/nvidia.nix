{ config, lib, pkgs, ... }:

with lib;

let
  # Option to manually enable/disable NVIDIA
  cfg = config.hardware.nvidia-conditional;
  
  # Detection methods
  hasNvidiaInHardware = 
    let
      hardwareConfigPath = "/etc/nixos/hardware-configuration.nix";
    in
    if builtins.pathExists hardwareConfigPath then
      let 
        hardwareConfig = builtins.readFile hardwareConfigPath;
      in
      lib.hasInfix "nvidia" (lib.toLower hardwareConfig) ||
      lib.hasInfix "geforce" (lib.toLower hardwareConfig) ||
      lib.hasInfix "10de:" hardwareConfig
    else false;

  # Runtime detection using lspci (more reliable than static config)
  hasNvidiaAtRuntime = 
    let
      lspciCheck = pkgs.runCommand "nvidia-detect" {} ''
        ${pkgs.pciutils}/bin/lspci | grep -i nvidia > $out || touch $out
      '';
    in
    builtins.readFile lspciCheck != "";

  # Check if we're on a system that likely has NVIDIA based on common patterns
  likelyHasNvidia = hasNvidiaInHardware || hasNvidiaAtRuntime;

in
{
  # Define options for the module
  options.hardware.nvidia-conditional = {
    enable = mkOption {
      type = types.bool;
      default = likelyHasNvidia;
      description = ''
        Whether to enable NVIDIA GPU drivers. 
        Automatically detected based on hardware-configuration.nix.
        Can be overridden manually.
      '';
    };
    
    autoDetect = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to automatically detect NVIDIA GPU presence.
        If disabled, you must manually set enable = true/false.
      '';
    };
  };
  # Main configuration - only applies when NVIDIA is detected/enabled
  config = mkIf cfg.enable {
    
    # Enable Graphics support
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      
      # Add some extra graphics packages that work well with NVIDIA
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    # Set NVIDIA as the video driver
    services.xserver.videoDrivers = [ "nvidia" ];

    # NVIDIA driver configuration
    hardware.nvidia = {
      # Modesetting is required for Wayland compositors
      modesetting.enable = true;

      # NVIDIA power management
      # Enable if you want better power management (experimental)
      powerManagement.enable = false;
      
      # Fine-grained power management 
      # Only works on modern NVIDIA GPUs (Turing+ like RTX 20 series and newer)
      # Your RTX 4060 supports this
      powerManagement.finegrained = false;

      # Use the open source kernel module (for RTX 20 series and newer)
      # RTX 4060 supports open-source drivers
      # Set to false if you experience issues
      open = false;

      # Enable the NVIDIA settings menu (nvidia-settings command)
      nvidiaSettings = true;

      # Driver package selection
      # For RTX 4060, use stable drivers
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # Add NVIDIA-related packages to system
    environment.systemPackages = with pkgs; [
      # NVIDIA control panel
      nvidia-vaapi-driver  # For hardware video acceleration
      
      # Optional: Add if you need CUDA development
      # cudatoolkit
      # cudnn
    ];

    # Optional: Enable NVIDIA container support (for Docker GPU access)
    # Uncomment if you use Docker with GPU workloads
    # hardware.nvidia-container-toolkit.enable = true;

    # Environment variables for NVIDIA
    environment.variables = {
      # Force NVIDIA GPU for certain applications
      # __NV_PRIME_RENDER_OFFLOAD = "1";
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      
      # Enable NVIDIA VAAPI (hardware video acceleration)
      LIBVA_DRIVER_NAME = "nvidia";
    };

    # Generate warnings/info messages  
    warnings = 
      if cfg.autoDetect && !likelyHasNvidia then [
        ''
          NVIDIA Conditional Module: No NVIDIA GPU detected automatically.
          NVIDIA drivers will not be installed.
          
          If you have an NVIDIA GPU:
          1. Check that your hardware-configuration.nix contains NVIDIA references
          2. Or manually enable with: hardware.nvidia-conditional.enable = true;
        ''
      ] else [];
  };
}