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
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };
    shellAliases = {
      # Modern ls alternatives
      ls = "exa --icons --group-directories-first";
      ll = "exa --icons --group-directories-first -la";
      la = "exa --icons --group-directories-first -a";
      lt = "exa --icons --group-directories-first --tree";
      ltt = "exa --icons --group-directories-first --tree -L 2";
      
      # Modern cat alternative
      cat = "bat --style=numbers,changes --theme=base16";
      
      # Modern find alternative
      find = "fd";
      
      # Modern grep alternative
      grep = "rg";
      
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      
      # Git shortcuts
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit -m";
      gp = "git push";
      gl = "git pull";
      gco = "git checkout";
      gcb = "git checkout -b";
      gb = "git branch";
      gd = "git diff";
      glog = "git log --oneline --graph --decorate";
      
      # System
      update = "sudo nixos-rebuild switch --impure --flake /home/pio/nixos-config#pio";
      upgrade = "sudo nixos-rebuild switch --impure --flake /home/pio/nixos-config#pio --upgrade";
      
      # Development
      py = "python3";
      pip = "pip3";
      node = "node --version && npm --version";
      
      # Fun
      weather = "curl wttr.in";
      speedtest = "curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -";
      
      # Color support
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      diff = "diff --color=auto";
      ip = "ip --color=auto";
    };
    initContent = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
      
      # Modern directory navigation
      setopt AUTO_CD
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      setopt PUSHD_MINUS
      setopt PUSHD_SILENT
      
      # Enhanced history
      setopt EXTENDED_HISTORY
      setopt SHARE_HISTORY
      setopt HIST_EXPIRE_DUPS_FIRST
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_SPACE
      setopt HIST_VERIFY
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_REDUCE_BLANKS
      
      # Smart completion
      setopt MENU_COMPLETE
      setopt AUTO_LIST
      setopt COMPLETE_IN_WORD
      setopt ALWAYS_TO_END
      setopt AUTO_PARAM_SLASH
      setopt AUTO_REMOVE_SLASH
      
      # Modern key bindings
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      bindkey '^H' backward-kill-word
      bindkey '^[[3;5~' kill-word
      
      # FZF integration
      export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --style=numbers --color=always --line-range :500 {}'"
      export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude .cache"
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git --exclude node_modules --exclude .cache"
      
      # Modern environment variables
      export EDITOR="code"
      export VISUAL="code"
      export PAGER="bat"
      export MANPAGER="bat --style=full --color=always --language=man"
      
      # Enhanced PATH
      export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.npm-global/bin:$PATH"
      
      # Modern terminal colors
      export CLICOLOR=1
      export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
      
      # Better tab completion
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' rehash true
      
      # Modern prompt (fallback if starship fails)
      if ! command -v starship &> /dev/null; then
        autoload -Uz vcs_info
        precmd() { vcs_info }
        zstyle ':vcs_info:git:*' formats ' %F{240}(%b)%r%f'
        zstyle ':vcs_info:*' enable git
        setopt PROMPT_SUBST
        PROMPT='%F{blue}%~%F{green}''${vcs_info_msg_0_}%F{white} %F{yellow}➜%f '
      fi
      
      # Modern functions
      mkcd() { mkdir -p "$1" && cd "$1"; }
      extract() {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }
      
      # Modern aliases for better UX
      alias ..='cd ..'
      alias ...='cd ../..'
      alias ....='cd ../../..'
      alias .....='cd ../../../..'
      
      # Welcome message
      echo "🌟 Welcome Pio!"
    '';
  };
  
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      # General
      add_newline = false;
      command_timeout = 1000;

    # Prompt character
    character = {
      success_symbol = "[➜](bold green)";
      error_symbol   = "[✗](bold red)";
      vicmd_symbol   = "[❮](bold yellow)";
    };

    # Directory display
    directory = {
      truncation_length = 3;
      truncation_symbol = "…/";
      style             = "bold blue";
      read_only         = " 🔒";
      read_only_style   = "red";
    };

    # Git integration
    git_branch = {
      symbol = " ";
      style  = "bold purple";
      format = "on [$symbol$branch]($style) ";
    };

    git_status = {
      style     = "bold red";
      ahead     = "⇡\${count}";
      behind    = "⇣\${count}";
      diverged  = "⇕⇡\${ahead_count}⇣\${behind_count}";
      untracked = "?";
      stashed   = "≡";
      modified  = "!";
      staged    = "+";
      renamed   = "»";
      deleted   = "✘";
      format    = "([$all_status$ahead_behind]($style))";
    };

    # Language versions
    nodejs = {
      style  = "bold green";
      format = "via [$version]($style) ";
    };

    python = {
      style  = "bold yellow";
      format = "via [$version]($style) ";
    };

    rust = {
      style  = "bold red";
      format = "via [$version]($style) ";
    };

    golang = {
      style  = "bold cyan";
      format = "via [$version]($style) ";
    };

    package = {
      symbol = "📦 ";
      style  = "bold blue";
      format = "via [$symbol$version]($style) ";
    };

    # System info
    time = {
      disabled    = false;
      time_format = "%T";
      format      = "🕐 [$time]($style) ";
      style       = "bold white";
    };

    cmd_duration = {
      min_time = 2000;
      format   = "took [$duration](bold yellow) ";
    };

    memory_usage = {
      threshold = 75;
      style     = "bold white";
      format    = "mem [$ram_pct]($style) ";
    };

    battery = {
      full_symbol        = "🔋";
      charging_symbol    = "⚡";
      discharging_symbol = "💀";
      empty_symbol       = "🪫";
      unknown_symbol     = "❓";
      format             = "[$symbol$percentage]($style) ";
      disabled           = false;
    };

    # Cloud / container integrations (disabled by default)
    kubernetes = {
      symbol   = "☸ ";
      style    = "bold blue";
      format   = "on [$symbol$context( \($namespace\))]($style) ";
      disabled = true;
    };

    docker_context = {
      symbol   = "🐳 ";
      style    = "bold blue";
      format   = "via [$symbol$context]($style) ";
      disabled = true;
    };

    aws = {
      symbol   = "☁️ ";
      style    = "bold yellow";
      format   = "on [$symbol$profile(\($region\))]($style) ";
      disabled = true;
    };

    # Prompt format
    format       = "[┌─](bold blue)$directory$git_branch$git_status\n[└─](bold blue)$character";
    right_format = "$time$cmd_duration";
  };
};

  programs.kitty = {
    enable = true;

    # General settings
    settings = {
      font_family      = "JetBrainsMono Nerd Font";
      font_size        = 13.0;
      bold_font        = "auto";
      italic_font      = "auto";
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

      # Colors (Tokyo Night theme, professional but modern)
      foreground = "#c0caf5";
      background = "#1a1b26";
      color0     = "#15161e";
      color1     = "#f7768e";
      color2     = "#9ece6a";
      color3     = "#e0af68";
      color4     = "#7aa2f7";
      color5     = "#bb9af7";
      color6     = "#7dcfff";
      color7     = "#a9b1d6";
      color8     = "#414868";
      color9     = "#f7768e";
      color10    = "#9ece6a";
      color11    = "#e0af68";
      color12    = "#7aa2f7";
      color13    = "#bb9af7";
      color14    = "#7dcfff";
      color15    = "#c0caf5";

      # Scrollback
      scrollback_lines = 10000;
    };

    # Keybindings
    keybindings = {
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left"  = "previous_tab";
      "ctrl+shift+enter" = "new_window";
    };
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