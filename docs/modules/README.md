# Module Documentation

This directory contains documentation for individual NixOS and Home Manager modules.

## Module Organization

Modules are organized into logical categories in `/modules/`:

### `/modules/system/` - Core System Configuration
- **disable-suspend.nix** - Suspend/hibernate management
- **gc-optimization.nix** - Garbage collection and store optimization

### `/modules/hardware/` - Hardware-Specific Configuration
- **nvidia.nix** - Automatic NVIDIA GPU detection and drivers

### `/modules/desktop/` - Desktop Environment and GUI
- **desktop.nix** - GNOME with extensions and multimedia support

### `/modules/development/` - Development Tools and Shell Environment
- **zsh.nix** - Modern shell configuration with aliases
- **starship.nix** - Customized prompt configuration
- **kitty.nix** - Terminal emulator settings
- **containers.nix** - Docker/Podman development support

## Available Documentation

### Detailed Module Docs
- [`nvidia.md`](nvidia.md) - NVIDIA GPU driver detection and configuration

### Quick Reference
Each module directory contains a README.md with usage information.

## Documentation Convention

Each module should have:
- **Purpose**: What the module does
- **Features**: Key capabilities
- **Configuration**: How to configure it
- **Examples**: Common use cases
- **Troubleshooting**: Common issues

## Adding Documentation

When creating a new module:
1. Add the module file to appropriate `/modules/category/`
2. Create corresponding documentation in `/docs/modules/`
3. Update the category README with a brief description
4. Link from main README if it's a major feature