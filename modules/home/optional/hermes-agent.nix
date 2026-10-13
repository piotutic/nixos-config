{
  config,
  inputs,
  lib,
  pkgs,
  llm-agents-pkgs,
  ...
}: let
  cfg = config.services.hermes-agent;
  tokenFile = "${config.xdg.configHome}/hermes/desktop-token";
  chromeBin = "${pkgs.google-chrome}/bin/google-chrome-stable";
in {
  imports = [
    inputs.hermes-agent.homeManagerModules.default
  ];

  # The hermes CLI and the desktop app. Both share HERMES_HOME with the services.
  programs.hermes-agent = {
    enable = true;
    desktop.enable = true;

    # The module bakes HERMES_MANAGED=home-manager into the launcher, which
    # locks every settings change. Unlock it after the module's env is set.
    desktop.package = let
      base = config.programs.hermes-agent.package.hermesDesktop;
    in
      base
      // {
        override = args:
          base.override (args
            // {
              extraRun = (args.extraRun or []) ++ ["export HERMES_MANAGED=false"];
            });
      };
  };

  # Gateway (Telegram, Discord, ...) plus the backend the desktop app attaches
  # to. "dashboard" also serves the web admin panel on http://127.0.0.1:9119.
  # No settings/environmentFiles: config.yaml and .env stay owned by the app,
  # `hermes config edit` and `hermes config set`, and survive rebuilds.
  services.hermes-agent = {
    enable = true;
    gateway.enable = true;

    backend = {
      mode = "dashboard";
      sessionTokenFile = tokenFile;
    };

    # The units get a fixed PATH, so tools from the user profile must be listed
    # here. gh backs git's GitHub credential helper; claude/codex let the agent
    # delegate coding via the bundled skills.
    extraPackages = with pkgs;
      [
        curl
        ffmpeg
        jq
        nodejs_22
        ripgrep
        tirith
      ]
      ++ [
        config.programs.gh.package
        llm-agents-pkgs.agent-browser
        llm-agents-pkgs.claude-code
        llm-agents-pkgs.codex
      ];
  };

  # Keep config live-editable, as before: override HERMES_MANAGED in the units
  # (later Environment= entries win) and drop the marker the shell reads.
  # The units don't see session variables, so the browser tools also get
  # agent-browser's Chrome path here (see llm-agents.nix).
  systemd.user.services.hermes-agent.Service.Environment = lib.mkAfter [
    "HERMES_MANAGED=false"
    "AGENT_BROWSER_EXECUTABLE_PATH=${chromeBin}"
  ];
  systemd.user.services.hermes-backend.Service.Environment = lib.mkAfter [
    "HERMES_MANAGED=false"
    "AGENT_BROWSER_EXECUTABLE_PATH=${chromeBin}"
  ];

  home.activation = {
    # Shared token so the desktop app reaches the backend service instead of
    # spawning its own. Generated once, never in the Nix store.
    hermesDesktopToken = lib.hm.dag.entryBefore ["hermesAgentSetup"] ''
      if [ ! -s ${lib.escapeShellArg tokenFile} ]; then
        run mkdir -p ${lib.escapeShellArg (dirOf tokenFile)}
        run ${pkgs.bash}/bin/bash -c ${lib.escapeShellArg ''
        umask 077
        od -An -tx1 -N32 /dev/urandom | tr -d " \n" > ${lib.escapeShellArg tokenFile}
      ''}
      fi
    '';

    hermesAgentUnmanage = lib.hm.dag.entryAfter ["hermesAgentSetup"] ''
      run rm -f ${lib.escapeShellArg "${cfg.hermesHome}/.managed"}
    '';
  };
}
