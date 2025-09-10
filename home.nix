{ config, pkgs, ... }:

{
  imports = [
    ./modules/zsh.nix
    ./modules/starship.nix
    ./modules/kitty.nix
  ];

  home.username = "pio";
  home.homeDirectory = "/home/pio";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  # Development Tools
  programs.vscode = {
    enable = true;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        ms-python.python
        ms-vscode.cpptools
        jnoortheen.nix-ide
        esbenp.prettier-vscode
      ];
    };
  };

  programs.git = {
    enable = true;
    userName = "piotutic";
    userEmail = "piotutic@yahoo.com";
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
      hosts = [ "github.com" "gist.github.com" ];
    };
    settings = {
      editor = "vim";
      git_protocol = "https";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
        pc = "pr create";
        rc = "repo clone";
        rv = "repo view";
        rl = "repo list";
      };
    };
    extensions = with pkgs; [
      gh-dash
    ];
  };

  programs.gh-dash = {
    enable = true;
    settings = {
      prSections = [
        {
          title = "My Pull Requests";
          filters = "is:open author:@me";
        }
        {
          title = "Needs My Review";
          filters = "is:open review-requested:@me";
        }
        {
          title = "Recently Updated";
          filters = "is:open sort:updated-desc";
        }
      ];
      issuesSections = [
        {
          title = "My Issues";
          filters = "is:open author:@me";
        }
        {
          title = "Assigned to Me";
          filters = "is:open assignee:@me";
        }
      ];
    };
  };

  # User Packages
  home.packages = with pkgs; [
    # Games
    zeroad

    # System Monitoring
    btop

    # Browsers
    brave

    # AI & Coding Tools
    claude-code
    code-cursor

    # Fonts
    nerd-fonts.jetbrains-mono

    # CLI Utilities
    eza
    bat
  ];
}