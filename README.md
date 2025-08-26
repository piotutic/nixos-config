# NixOS Configuration (Flake) – Pio

This repository contains my NixOS system configuration using flakes and Home Manager.
Hardware configuration is read from `/etc/nixos/hardware-configuration.nix`, so rebuilds use `--impure`.

## Quick Start

### Rebuild and Switch
```bash
sudo nixos-rebuild switch --impure --flake /home/pio/nixos-config#pio
```

### Update and Rebuild
```bash
nix flake update /home/pio/nixos-config
sudo nixos-rebuild switch --impure --flake /home/pio/nixos-config#pio
```

### Rollback
```bash
# Immediate rollback to previous generation
sudo nixos-rebuild switch --rollback
```

## System Management

### System Generations

**List generations:**
```bash
sudo nix profile history --profile /nix/var/nix/profiles/system
```

**Diff current vs previous generation:**
```bash
sudo nix store diff-closures $(readlink -f /nix/var/nix/profiles/system) $(ls -d /nix/var/nix/profiles/system-*-link | tail -n2 | head -n1)
```

**Delete old generations:**
```bash
# Delete older than 7 days
sudo nix-collect-garbage --delete-older-than 7d

# Or using new CLI (30 days)
sudo nix profile wipe-history --older-than 30d --profile /nix/var/nix/profiles/system
```

### User Environment Generations

**List user profile history:**
```bash
nix profile history
```

**Delete old user generations:**
```bash
nix profile wipe-history --older-than 30d
```

## Garbage Collection

### User Garbage Collection
```bash
# Basic GC
nix-collect-garbage

# Aggressive GC (deletes old generations)
nix-collect-garbage -d
```

### System Garbage Collection
```bash
# Basic GC
sudo nix-collect-garbage

# Aggressive GC
sudo nix-collect-garbage -d
```

### Verify Store
```bash
# Show store size
sudo du -sh /nix/store

# Find roots holding items alive
sudo nix-store --gc --print-roots
```

## Helper Aliases

These aliases are already configured in your zsh setup:

### System Management
- `update` - Rebuild and switch configuration
- `upgrade` - Update flake inputs and rebuild

### Git Shortcuts
- `g` - git
- `gs` - git status
- `ga` - git add
- `gc` - git commit -m
- `gp` - git push
- `gl` - git pull
- `gco` - git checkout
- `gcb` - git checkout -b
- `gb` - git branch
- `gd` - git diff
- `glog` - git log --oneline --graph --decorate

### Modern Tools
- `ls` - exa with icons
- `cat` - bat with syntax highlighting
- `find` - fd (faster find)
- `grep` - ripgrep

## Notes

- Hardware configuration is loaded from `/etc/nixos/hardware-configuration.nix`, which is why we use `--impure`
- Package versions are pinned via `flake.lock`
- Home Manager is integrated into the NixOS configuration and managed via `nixos-rebuild`
- For fully reproducible hosts, consider committing hardware modules directly to the repository 