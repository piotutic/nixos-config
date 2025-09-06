# NVIDIA GPU Module

Automatically detects and configures NVIDIA GPU drivers with runtime hardware detection.

## Features

- **Auto-detection**: Uses `lspci` to detect NVIDIA GPUs at build time
- **Portable**: Same config works on systems with/without NVIDIA
- **Optimized**: RTX 4060 configuration with stable drivers
- **Modern**: Uses latest `hardware.graphics` options

## Configuration

### Automatic (Default)
```nix
# Just import the module - auto-detection handles the rest
./modules/nvidia.nix
```

### Manual Override
```nix
hardware.nvidia-conditional = {
  enable = true;           # Force enable
  autoDetect = false;      # Disable auto-detection
};
```

## What Gets Installed

When NVIDIA GPU detected:
- NVIDIA stable drivers
- OpenGL/Graphics support with 32-bit
- Hardware video acceleration (VAAPI)
- `nvidia-settings` command
- Wayland compatibility

## RTX 4060 Settings

- **Drivers**: Stable (proprietary)
- **Open source**: Disabled (can enable if needed)
- **Power management**: Disabled (prevents issues)
- **Wayland**: Enabled via modesetting
- **32-bit**: Enabled for gaming

## Optional Features

Uncomment in `modules/nvidia.nix`:
- CUDA toolkit for development
- Docker GPU support
- Fine-grained power management

## Troubleshooting

**No GPU detected:**
```bash
lspci | grep -i nvidia  # Check hardware
```

**Manual enable:**
```nix
hardware.nvidia-conditional.enable = true;
```

**Check logs:**
```bash
journalctl -b | grep nvidia
```