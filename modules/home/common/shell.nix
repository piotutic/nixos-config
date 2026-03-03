{ ... }:

{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;

    config = {
      global = {
        hide_env_diff = true;
        warn_timeout = "5m";
      };
    };
  };

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
      ls = "eza --icons --group-directories-first";
      ll = "eza --icons --group-directories-first -la";
      cat = "bat --style=numbers,changes";
      ".." = "cd ..";
      "..." = "cd ../..";
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit -m";
      gp = "git push";
      gl = "git pull";
      update = "sudo nixos-rebuild switch --flake /home/pio/nixos-config && nixos-auto-commit";
      upgrade = "cd /home/pio/nixos-config && nix flake update && sudo nixos-rebuild switch --flake /home/pio/nixos-config && nixos-auto-commit";
      upgrade-agents = "cd /home/pio/nixos-config && nix flake update llm-agents && sudo nixos-rebuild switch --flake /home/pio/nixos-config && nixos-auto-commit";
      nix-gc = "sudo nix-collect-garbage -d";
      nix-dev = "mkdir -p .nix && nix develop --profile ./.nix/profile";
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

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = false;

      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)";
      };

      directory = {
        truncation_length = 3;
        truncation_symbol = ".../";
        style = "bold cyan";
      };

      git_branch = {
        symbol = " ";
        style = "bold purple";
      };

      git_status = {
        style = "bold red";
        ahead = "^$count";
        behind = "v$count";
        diverged = "<>";
        modified = "!";
        staged = "+";
        untracked = "?";
      };

      nodejs.format = "via [$version]($style) ";
      golang.format = "via [$version]($style) ";
      python.format = "via [$version]($style) ";

      cmd_duration = {
        min_time = 1000;
        format = "took [$duration](bold yellow) ";
      };

      format = "$directory$git_branch$git_status$character";
      right_format = "$cmd_duration";
    };
  };

  programs.kitty = {
    enable = true;

    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 13.0;
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      window_padding_width = 8;
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      cursor_shape = "beam";
      cursor_blink_interval = 0;
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      active_tab_font_style = "bold";
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
}
