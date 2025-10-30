{
  config,
  lib,
  pkgs,
  ...
}: {
  # n8n Workflow Automation Service
  # For B2B automation company - development/testing environment
  # Running as user 'pio' for easy development workflow

  # n8n systemd service
  systemd.services.n8n = {
    description = "n8n - Workflow Automation Tool";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    environment = {
      # Data and configuration
      N8N_USER_FOLDER = "/home/pio/.n8n";
      DB_TYPE = "sqlite";
      DB_SQLITE_DATABASE = "/home/pio/.n8n/database.sqlite";

      # Network configuration
      N8N_HOST = "0.0.0.0";
      N8N_PORT = "5678";
      WEBHOOK_URL = "http://localhost:5678/";

      # Editor and instance settings
      N8N_EDITOR_BASE_URL = "http://localhost:5678";
      N8N_PROTOCOL = "http";

      # Timezone (adjust as needed)
      GENERIC_TIMEZONE = "America/New_York";
      TZ = "America/New_York";

      # Development settings
      N8N_LOG_LEVEL = "info";
      N8N_LOG_OUTPUT = "console";

      # Disable telemetry for privacy
      N8N_DIAGNOSTICS_ENABLED = "false";
      N8N_PERSONALIZATION_ENABLED = "false";
    };

    serviceConfig = {
      Type = "simple";
      User = "pio";
      Group = "users";
      WorkingDirectory = "/home/pio";
      ExecStart = "${pkgs.n8n}/bin/n8n start";
      Restart = "always";
      RestartSec = "10";

      # Resource limits - prevent runaway processes from taking down the system
      MemoryMax = "4G";              # Max RAM usage (up from 2G)
      TasksMax = 512;                # Max threads/processes (up from 256)
      CPUQuota = "300%";             # Max 3 CPU cores worth of usage
      LimitNOFILE = 8192;            # Max open files/connections

      # Restart protection - prevent infinite crash loops
      StartLimitBurst = 5;           # Max 5 restart attempts
      StartLimitIntervalSec = 60;    # Within 60 seconds
      # After 5 crashes in 60s, systemd stops trying

      # Timeout control - prevent hanging on shutdown
      TimeoutStopSec = 30;           # Force kill after 30s if won't stop

      # Process management
      KillMode = "mixed";            # SIGTERM to main process, SIGKILL to children
      OOMScoreAdjust = 500;          # Make n8n first candidate for OOM killer (protects system)
    };
  };

  # Open firewall ports
  networking.firewall = {
    allowedTCPPorts = [
      5678 # n8n web interface
      5679 # n8n webhook port
    ];
  };

  # Add n8n to system packages for CLI access
  environment.systemPackages = with pkgs; [
    n8n
  ];
}
