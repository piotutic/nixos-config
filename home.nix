{ config, pkgs, ... }:

{
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

  # Shells
  programs.zsh.enable = true;
  programs.starship.enable = true;

  # Packages for the user profile (optional)
  home.packages = with pkgs; [
    btop
    brave
    code-cursor
  ];

  home.stateVersion = "25.05";
} 