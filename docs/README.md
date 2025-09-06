# NixOS Configuration Documentation

This directory contains all documentation for the NixOS configuration.

## Structure

- `system-management.md` - System rebuild, rollback, and generation management
- `modules/` - Documentation for individual modules
- `troubleshooting.md` - Common issues and solutions

## Quick Reference

**Rebuild system:**
```bash
sudo nixos-rebuild switch --impure --flake .#pio
```

**Update and rebuild:**
```bash
nix flake update && sudo nixos-rebuild switch --impure --flake .#pio
```

**Aliases available:**
- `update` - Rebuild system
- `upgrade` - Update flake + rebuild