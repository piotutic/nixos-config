{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      # General
      add_newline = false;
      command_timeout = 1000;

      # Identity (show only when it matters)
      username = {
        show_always = true;
        style_user = "bold white";
        format = "[$user]($style)";
      };
      hostname = {
        ssh_only = true;
        style = "bold white";
        format = "[@$hostname]($style) ";
      };

      # Prompt character
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol   = "[❯](bold red)";
        vicmd_symbol   = "[❮](bold yellow)";
      };

      # Directory display
      directory = {
        truncation_length = 3;
        truncation_symbol = "…/";
        style             = "bold cyan";
        read_only         = " ";
        read_only_style   = "red";
      };

      # Git integration
      git_branch = {
        symbol = " ";
        style  = "bold purple";
        format = "[$symbol$branch]($style) ";
      };

      git_status = {
        style     = "bold red";
        ahead     = "⇡\${count}";
        behind    = "⇣\${count}";
        diverged  = "⇕\${ahead_count}⇣\${behind_count}";
        untracked = "?";
        stashed   = "≡";
        modified  = "!";
        staged    = "+";
        renamed   = "»";
        deleted   = "✘";
        format    = "([$all_status$ahead_behind]($style)) ";
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
        symbol = "pkg ";
        style  = "bold blue";
        format = "[$symbol$version]($style) ";
      };

      # System info
      time = {
        disabled    = false;
        time_format = "%T";
        format      = "[$time]($style) ";
        style       = "white";
      };

      cmd_duration = {
        min_time = 1;
        format   = "took [$duration](bold yellow) ";
      };

      memory_usage = {
        threshold = 1;
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

      # Clean two-line prompt without powerline caps
      format = ''
        $username$hostname$directory$git_branch$git_status
        $time $character
      '';
      right_format = "$cmd_duration";
    };
  };
}
