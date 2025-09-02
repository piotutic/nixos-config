{ config, pkgs, ... }:

{
  imports = [
    ./modules/zsh.nix
    ./modules/starship.nix
    ./modules/kitty.nix
  ];

  home.username = "pio";
  home.homeDirectory = "/home/pio";
  programs.home-manager.enable = true;

  # VS Code with extensions
  programs.vscode = {
    enable = true;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        ms-python.python              # Python language support
        ms-vscode.cpptools            # C/C++ language support
        jnoortheen.nix-ide            # Nix language support and IDE features
        esbenp.prettier-vscode        # Prettier formatter
      ];
    };
  };

  # Git
  programs.git = {
    enable = true;
    userName = "piotutic";
    userEmail = "piotutic@yahoo.com";
  };

  # Packages for the user profile (optional)
  home.packages = with pkgs; [
    # --- Games ---
    zeroad                # 0 A.D., a free, open-source real-time strategy game

    # --- System Monitoring ---
    btop                  # Resource monitor for CPU, memory, disks, network, and processes

    # --- Browsers ---
    brave                 # Privacy-focused web browser

    # --- AI & Coding Tools ---
    claude-code           # Claude AI code assistant 
    code-cursor           # AI-powered code navigation and editing tool

    # --- Fonts ---
    nerd-fonts.jetbrains-mono # JetBrains Mono font patched with Nerd Fonts symbols

    # --- CLI Utilities ---
    eza                   # Modern replacement for 'ls' with more features and better defaults
    bat                   # 'cat' clone with syntax highlighting and Git integration
  ];

  home.stateVersion = "25.05";
} 