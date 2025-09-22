# NixOS Configuration - Pio

Modern NixOS configuration using flakes with Home Manager integration and automatic hardware detection.

## Quick Start

```bash
# Rebuild system
sudo nixos-rebuild switch --impure --flake .#pio

# Update and rebuild
nix flake update && sudo nixos-rebuild switch --impure --flake .#pio

# Use aliases (configured in zsh)
update    # rebuild system
upgrade   # update + rebuild
nix-gc    # "sudo nix-collect-garbage -d";
nix-dev   # "nix develop --profile .nix-profile/.nix-profile"
```

## Structure

```
├── configuration.nix           # Main NixOS config
├── flake.nix                  # Flake definition & inputs
├── home.nix                   # Home Manager config
├── modules/                   # Modular configurations
│   ├── nvidia.nix            # Auto-detecting NVIDIA drivers
│   ├── zsh.nix               # Shell configuration
│   ├── starship.nix          # Prompt configuration
│   └── kitty.nix             # Terminal configuration
└── docs/                      # Documentation
    ├── system-management.md   # Rebuild, GC, generations
    └── modules/              # Per-module documentation
```

## Features

- **🔄 Auto-hardware detection**: NVIDIA drivers only when GPU present
- **📦 Modular**: Clean separation of concerns
- **🏠 Home Manager**: Declarative user environment
- **⚡ Modern tools**: zsh, starship, kitty, exa, bat, ripgrep
- **📚 Well documented**: Comprehensive docs in `docs/`

## Documentation

See [`docs/`](docs/) for detailed documentation:

- [System Management](docs/system-management.md) - Rebuilds, rollbacks, garbage collection
- [NVIDIA Module](docs/modules/nvidia.md) - GPU driver configuration

## Hardware Support

- **RTX 4060**: Automatically detected and configured
- **Non-NVIDIA systems**: Drivers skipped, no conflicts
- **Portability**: Same config works across different hardware

## Notes

- Uses `--impure` flag to access `/etc/nixos/hardware-configuration.nix`
- Package versions pinned via `flake.lock`
- Home Manager integrated into NixOS rebuild process
