# Home Manager Modules

This directory contains modularized configuration files for different programs and tools.

## Modules

### `zsh.nix`
Contains all zsh shell configuration including:
- Shell aliases and functions
- History settings
- Completion and syntax highlighting
- Custom initialization content
- Modern shell utilities integration

### `starship.nix`
Contains the Starship prompt configuration including:
- Prompt character and formatting
- Git integration
- Language version displays
- System information (time, memory, battery)
- Cloud/container integrations (disabled by default)

### `kitty.nix`
Contains the Kitty terminal emulator configuration including:
- Font settings (JetBrains Mono Nerd Font)
- Color scheme (Tokyo Night theme)
- Window and tab settings
- Keybindings
- Cursor and scrollback settings

## Usage

These modules are imported in the main `home.nix` file:

```nix
imports = [
  ./modules/zsh.nix
  ./modules/starship.nix
  ./modules/kitty.nix
];
```

## Benefits

- **Modularity**: Each program's configuration is isolated in its own file
- **Maintainability**: Easier to find and modify specific configurations
- **Reusability**: Modules can be easily shared or reused across different configurations
- **Cleanliness**: Main `home.nix` file is much cleaner and focused on high-level configuration
