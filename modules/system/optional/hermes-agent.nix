{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.hermes-agent.nixosModules.default
  ];

  users.users.pio.extraGroups = [ "hermes" ];

  services.hermes-agent = {
    enable = true;
    container.enable = false;

    environmentFiles = [ "/var/lib/hermes/env" ];
    addToSystemPackages = true;

    extraDependencyGroups = [ "messaging" ];

    extraPackages = with pkgs; [
      curl
      ffmpeg
      jq
      nodejs_22
      ripgrep
      tirith
    ];

    settings = {
      model = {
        base_url = "";
        default = "deepseek/deepseek-v4-flash";
        provider = "openrouter";
      };

      fallback_providers = [
        {
          provider = "openrouter";
          model = "qwen/qwen3.5-flash-02-23";
        }
      ];

      toolsets = [ "hermes-cli" ];

      agent = {
        max_turns = 90;
        gateway_timeout = 1800;
        restart_drain_timeout = 180;
        api_max_retries = 3;
        service_tier = "";
        tool_use_enforcement = "auto";
        gateway_timeout_warning = 900;
        gateway_notify_interval = 180;
        gateway_auto_continue_freshness = 3600;
        image_input_mode = "auto";
        disabled_toolsets = [];
      };

      terminal = {
        backend = "local";
        modal_mode = "auto";
        cwd = ".";
        timeout = 180;
        env_passthrough = [];
        shell_init_files = [ "~/.zshrc" ];
        auto_source_bashrc = true;
        persistent_shell = true;
      };

      compression = {
        enabled = true;
        threshold = 0.5;
        target_ratio = 0.2;
        protect_last_n = 20;
        hygiene_hard_message_limit = 400;
      };

      telegram = {
        reactions = false;
        channel_prompts = {};
        allowed_chats = "";
      };

      approvals = {
        mode = "manual";
        timeout = 60;
        cron_mode = "deny";
        mcp_reload_confirm = true;
      };

      security = {
        allow_private_urls = false;
        redact_secrets = true;
        tirith_enabled = true;
        tirith_path = "tirith";
        tirith_timeout = 5;
        tirith_fail_open = true;
        website_blocklist = {
          enabled = false;
          domains = [];
          shared_files = [];
        };
      };

      cron = {
        wrap_response = true;
        max_parallel_jobs = null;
      };

      kanban = {
        dispatch_in_gateway = true;
        dispatch_interval_seconds = 60;
        failure_limit = 2;
      };

      code_execution.mode = "project";
    };
  };

  systemd.services.hermes-agent.serviceConfig.TimeoutStopSec = "210s";
}
