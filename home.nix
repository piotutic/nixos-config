{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/development/zsh.nix
    ./modules/development/starship.nix
    ./modules/development/kitty.nix
  ];

  home.username = "pio";
  home.homeDirectory = "/home/pio";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  # Development Tools
  # VSCode-FHS is installed as a package below for better extension compatibility

  programs.git = {
    enable = true;
    userName = "piotutic";
    userEmail = "piotutic@yahoo.com";

    # Better defaults
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      merge.conflictStyle = "zdiff3";
      diff.algorithm = "histogram";
      log.date = "iso";
      core.autocrlf = "input";
      core.ignoreCase = false;
      branch.autoSetupRebase = "always";
      rerere.enabled = true;
    };

    # Enhanced aliases
    aliases = {
      # Basic shortcuts
      co = "checkout";
      br = "branch";
      ci = "commit";
      st = "status";

      # Advanced shortcuts
      cob = "checkout -b";
      com = "checkout main";
      cod = "checkout develop";

      # Commit shortcuts
      ca = "commit -a";
      cam = "commit -am";
      amend = "commit --amend";
      amendn = "commit --amend --no-edit";

      # Log aliases
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      lga = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all";
      lol = "log --oneline";
      lola = "log --oneline --all";

      # Diff aliases
      df = "diff";
      dfc = "diff --cached";
      dfh = "diff HEAD~1";

      # Status and info
      s = "status -s";
      ss = "status";
      info = "remote -v";

      # Stash aliases
      sl = "stash list";
      sa = "stash apply";
      ssh = "stash show";
      sp = "stash pop";

      # Reset aliases
      r = "reset";
      r1 = "reset HEAD^";
      r2 = "reset HEAD^^";
      rh = "reset --hard";
      rh1 = "reset HEAD^ --hard";
      rh2 = "reset HEAD^^ --hard";

      # Remote aliases
      rem = "remote";
      rema = "remote add";
      remr = "remote rm";
      remv = "remote -v";
    };

    # Better diff and merge tools
    delta.enable = true;
    delta.options = {
      navigate = true;
      light = false;
      side-by-side = true;
    };
  };

  # Direnv for automatic environment loading
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;

    config = {
      # Global direnv configuration
      global = {
        hide_env_diff = true;
        warn_timeout = "5m";
      };
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
      hosts = ["github.com" "gist.github.com"];
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
    veloren

    # System Monitoring
    btop

    # Browsers
    brave

    # Communication
    discord
    slack

    # Fonts
    nerd-fonts.jetbrains-mono

    # CLI Utilities
    eza
    bat
    fd
    ripgrep

    # Nix Formatter
    alejandra

    # Media Player
    vlc

    # Video Editing
    ffmpeg-full

    # Screen Recording
    obs-studio

    # Personal knowledge base
    obsidian

    # Development tools
    wget
    curl
    pciutils # For lspci to detect hardware
    just
    tmux
    jq
    vscode-fhs # FHS-compliant VSCode for better extension compatibility
    go_1_25
    nodejs_24
  ];
}
