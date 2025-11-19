{
  config,
  pkgs,
  claude-code-nix,
  ...
}: {
  home.username = "pio";
  home.homeDirectory = "/home/pio";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  # Fonts
  fonts.fontconfig.enable = true;

  # Development Tools
  # VSCode-FHS is installed as a package below for better extension compatibility

  programs.git = {
    enable = true;

    ignores = [
      ".nix-profile"
      "**/.claude/settings.local.json"
    ];

    settings = {
      # User configuration
      user = {
        name = "piotutic";
        email = "piotutic@yahoo.com";
      };

      # Better defaults
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

      # Enhanced aliases
      alias = {
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
    };
  };

  # Delta - Better diff and merge tools
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
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

  # Zsh
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    shellAliases = {
      # Modern CLI tools
      ls = "eza --icons --group-directories-first";
      ll = "eza --icons --group-directories-first -la";
      cat = "bat --style=numbers,changes";

      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";

      # Git shortcuts
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit -m";
      gp = "git push";
      gl = "git pull";

      # NixOS
      update = "sudo nixos-rebuild switch --impure --flake /home/pio/nixos-config#pio && nixos-auto-commit";
      upgrade = "cd /home/pio/nixos-config && nix flake update && sudo nixos-rebuild switch --impure --flake /home/pio/nixos-config#pio && nixos-auto-commit";
      upgrade-claude = "cd /home/pio/nixos-config && nix flake update claude-code && sudo nixos-rebuild switch --impure --flake /home/pio/nixos-config#pio && nixos-auto-commit";
      nix-gc = "sudo nix-collect-garbage -d";
      nix-dev = "nix develop --profile ./.nix-profile";
    };

    initContent = ''
      # Directory navigation
      setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS

      # History settings
      setopt EXTENDED_HISTORY HIST_IGNORE_DUPS HIST_VERIFY

      # Better completion
      setopt MENU_COMPLETE COMPLETE_IN_WORD

      # Key bindings
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      # Environment
      export EDITOR="code"
      export PAGER="bat"

      # Completion styling
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

      # Utility functions
      mkcd() { mkdir -p "$1" && cd "$1"; }
    '';
  };

  # Starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = false;

      # Prompt character
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      # Directory
      directory = {
        truncation_length = 3;
        truncation_symbol = "…/";
        style = "bold cyan";
      };

      # Git
      git_branch = {
        symbol = " ";
        style = "bold purple";
      };

      git_status = {
        style = "bold red";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕";
        modified = "!";
        staged = "+";
        untracked = "?";
      };

      # Languages
      nodejs.format = "via [$version]($style) ";
      golang.format = "via [$version]($style) ";
      python.format = "via [$version]($style) ";

      # Command duration
      cmd_duration = {
        min_time = 1000;
        format = "took [$duration](bold yellow) ";
      };

      # Simple format
      format = "$directory$git_branch$git_status$character";
      right_format = "$cmd_duration";
    };
  };

  # Kitty
  programs.kitty = {
    enable = true;

    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 13.0;
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      # Window
      window_padding_width = 8;
      confirm_os_window_close = 0;
      enable_audio_bell = false;

      # Cursor
      cursor_shape = "beam";
      cursor_blink_interval = 0;

      # Tabs
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      active_tab_font_style = "bold";

      # Colors (Tokyo Night theme)
      foreground = "#c0caf5";
      background = "#1a1b26";
      color0 = "#15161e";
      color1 = "#f7768e";
      color2 = "#9ece6a";
      color3 = "#e0af68";
      color4 = "#7aa2f7";
      color5 = "#bb9af7";
      color6 = "#7dcfff";
      color7 = "#a9b1d6";
      color8 = "#414868";
      color9 = "#f7768e";
      color10 = "#9ece6a";
      color11 = "#e0af68";
      color12 = "#7aa2f7";
      color13 = "#bb9af7";
      color14 = "#7dcfff";
      color15 = "#c0caf5";

      # Scrollback
      scrollback_lines = 10000;
    };

    keybindings = {
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+enter" = "new_window";
    };
  };

  # User Packages
  home.packages = with pkgs; [
    # Fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    nerd-fonts.jetbrains-mono

    # System Monitoring
    btop

    # Browsers
    # brave - moved to Flatpak

    # Communication
    # discord - moved to Flatpak
    # slack - moved to Flatpak

    # CLI Utilities
    eza
    bat
    fd
    ripgrep
    alejandra # Nix formatter

    # Media
    # vlc - moved to Flatpak
    ffmpeg-full
    # obs-studio - moved to Flatpak

    # Personal knowledge base
    # obsidian - moved to Flatpak

    # Development tools
    wget
    curl
    just
    tmux
    jq
    vscode-fhs # FHS-compliant VSCode for better extension compatibility
    gnumake
    claude-code-nix

    # Torrents
    # qbittorrent - moved to Flatpak
  ];
}
