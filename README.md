# NixOS Configuration

Minimal, pragmatic NixOS configuration using flakes and Home Manager. 727 lines total across 6 files.

## Installation on New Machine

### 1. Initial NixOS Setup

Install NixOS normally, then prepare for flakes:

```bash
# Edit your initial configuration
sudo nano /etc/nixos/configuration.nix
```

Add these to your initial `configuration.nix`:

```nix
{
  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Add git for cloning
  environment.systemPackages = with pkgs; [
    git
  ];
}
```

Rebuild to apply:

```bash
sudo nixos-rebuild switch
```

### 2. Clone This Repository

```bash
# Clone into your home directory
cd ~
git clone https://github.com/piotutic/nixos-config
cd nixos-config
```

### 3. Customize for Your System

Edit `configuration.nix` and update:
- `networking.hostName` - your hostname
- `time.timeZone` - your timezone
- `users.users.pio` - change username to yours

Edit `home.nix` and update:
- `home.username` - your username
- `home.homeDirectory` - your home path
- `programs.git.userName` and `programs.git.userEmail` - your git credentials

### 4. Rebuild with This Configuration

```bash
sudo nixos-rebuild switch --impure --flake /home/YOUR-USERNAME/nixos-config#pio
```

### 5. Done!

After rebuild completes, your shell aliases are available:
```bash
update    # Rebuild system
upgrade   # Update flake.lock and rebuild
nix-gc    # Clean old generations
```

## Quick Start (Existing Users)

```bash
# Rebuild system
update

# Update dependencies and rebuild
upgrade

# Clean old generations
nix-gc
```

Or use the full commands:

```bash
# Rebuild
sudo nixos-rebuild switch --impure --flake .#pio

# Update and rebuild
nix flake update && sudo nixos-rebuild switch --impure --flake .#pio

# Garbage collect
sudo nix-collect-garbage -d
```

## Repository Structure

```
nixos-config/
├── flake.nix              # Flake inputs and configuration
├── flake.lock             # Locked dependency versions
├── configuration.nix      # Base NixOS system config
├── home.nix               # Home Manager (user environment)
└── modules/
    ├── system.nix         # GC + suspend settings
    ├── containers.nix     # Docker with rootless mode
    └── desktop.nix        # GNOME desktop environment
```

**Total:** 727 lines across 6 files

## Features

### System
- **GNOME Desktop** - Clean desktop with essential extensions
- **Automatic GC** - Weekly garbage collection, keep last 30 days
- **Store Optimization** - Automatic deduplication to save space
- **No Suspend** - Lid close triggers poweroff instead of suspend
- **systemd-boot** - Keep last 5 generations in boot menu

### Development
- **Docker** - Rootless mode, on-demand start
- **Modern Shell** - zsh + starship + syntax highlighting
- **Better CLI Tools** - eza, bat, fd, ripgrep, delta
- **Git Enhancements** - Extensive aliases, delta diff, gh CLI
- **VS Code FHS** - Better extension compatibility
- **Dev Runtimes** - Go 1.25, Node.js 24

### Applications
- **Terminal** - Kitty with Tokyo Night theme
- **Browser** - Brave
- **Communication** - Discord, Slack
- **Knowledge** - Obsidian
- **Media** - VLC, FFmpeg, OBS Studio

## Why `--impure`?

This configuration uses `--impure` to import `/etc/nixos/hardware-configuration.nix`:

```nix
imports = [
  /etc/nixos/hardware-configuration.nix  # Machine-specific hardware
  ./modules/system.nix
  ./modules/containers.nix
  ./modules/desktop.nix
];
```

### This Is Correct

- **Package reproducibility**: 100% reproducible via `flake.lock`
- **Hardware flexibility**: Each machine auto-detects its own hardware
- **Portability**: Same config works on any machine
- **Standard practice**: How most NixOS flakes handle hardware

The "impurity" only affects hardware detection (disk UUIDs, kernel modules), not software packages or configuration.

### User Environment (home.nix)
All user-level config in one place:
- Shell configuration (zsh, starship)
- Terminal emulator (kitty)
- Git config with aliases
- GitHub CLI + gh-dash
- All user packages
- Fonts

### System Modules
- `system.nix` - GC and suspend management
- `containers.nix` - Docker configuration
- `desktop.nix` - GNOME and desktop services

## Customization

### Add Packages

Edit `home.nix`:
```nix
home.packages = with pkgs; [
  # Add your packages here
  your-package
];
```
## Maintenance

```bash
# Update all inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback
sudo nixos-rebuild switch --rollback

# Boot into previous generation
# (Select at boot menu)
```