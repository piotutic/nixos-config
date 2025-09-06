# Module Documentation

This directory contains documentation for individual NixOS and Home Manager modules.

## Documentation Convention

Each module should have:
- **Purpose**: What the module does
- **Features**: Key capabilities  
- **Configuration**: How to configure it
- **Examples**: Common use cases
- **Troubleshooting**: Common issues

## Available Modules

### System Modules
- [`nvidia.md`](nvidia.md) - Automatic NVIDIA GPU driver detection and configuration

### Home Manager Modules  
- `zsh.nix` - Shell configuration with modern tools
- `starship.nix` - Customized prompt configuration
- `kitty.nix` - Terminal emulator settings

## Adding Documentation

When creating a new module:
1. Add the module file to `/modules/`
2. Create corresponding documentation in `/docs/modules/`
3. Update this README with a brief description
4. Link from main README if it's a major feature