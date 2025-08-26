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
        ms-python.python
        ms-vscode.cpptools
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
    btop
    brave
    code-cursor
    nerd-fonts.jetbrains-mono
    eza
    bat
  ];

  home.stateVersion = "25.05";
} 