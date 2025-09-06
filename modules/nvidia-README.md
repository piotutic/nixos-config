# NVIDIA GPU Module

This module automatically detects and configures NVIDIA GPU drivers for your NixOS system.

## How it works

The module automatically detects NVIDIA GPUs by:
1. Scanning `/etc/nixos/hardware-configuration.nix` for NVIDIA references
2. Looking for NVIDIA vendor ID (10de) or device names
3. Only installs drivers when GPU is detected

## Configuration

### Automatic (default)
The module will automatically detect your RTX 4060 and install drivers:
```nix
# No additional configuration needed - just import the module
```

### Manual control
To override automatic detection:
```nix
# Force enable NVIDIA drivers
hardware.nvidia-conditional.enable = true;

# Force disable NVIDIA drivers  
hardware.nvidia-conditional.enable = false;

# Disable auto-detection
hardware.nvidia-conditional.autoDetect = false;
```

## What gets installed

When NVIDIA GPU is detected:
- NVIDIA proprietary drivers (stable version)
- OpenGL support with 32-bit compatibility
- Hardware video acceleration (VAAPI)
- NVIDIA settings panel (`nvidia-settings` command)
- Wayland support (modesetting enabled)

## Driver configuration

The module uses these settings for RTX 4060:
- **Open source drivers**: `open = false` (RTX 4060 supports this but we won`t use it for now)
- **Power management**: Disabled by default (can cause issues)
- **Wayland support**: Enabled for modern desktop environments
- **32-bit support**: Enabled for games/compatibility

## Customization

Edit `/modules/nvidia.nix` to:
- Enable CUDA support (uncomment `cudatoolkit`)
- Enable Docker GPU support (uncomment `nvidia-container-toolkit`)
- Adjust power management settings
- Switch to proprietary drivers (`open = false`)

## Troubleshooting

If drivers don't install automatically:
1. Check `/etc/nixos/hardware-configuration.nix` contains NVIDIA references
2. Manually enable: `hardware.nvidia-conditional.enable = true;`
3. Check system logs: `journalctl -b | grep nvidia`

## Systems

- **PC with RTX 4060**: Automatically detected and configured
- **Laptop without GPU**: Automatically skipped, no drivers installed