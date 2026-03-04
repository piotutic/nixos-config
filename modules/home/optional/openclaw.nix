{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  defaultOpenclawPackage = inputs.openclaw.packages.${pkgs.stdenv.hostPlatform.system}.openclaw;
  openclawGatewayPackage =
    inputs.openclaw.packages.${pkgs.stdenv.hostPlatform.system}."openclaw-gateway";
  openclawPackage = config.programs.openclaw.package;
  openclawBinary = lib.getExe' openclawGatewayPackage "openclaw";
  stateDir = config.programs.openclaw.stateDir;
  workspaceDir = config.programs.openclaw.workspaceDir;
  controlUiTarget = "${stateDir}/control-ui";
  controlUiSource = "${openclawGatewayPackage}/lib/openclaw/dist/control-ui";
  logDir = "${stateDir}/logs";
  logPath = "${logDir}/gateway.log";
  coreutils = pkgs.coreutils;
in

{
  imports = [
    inputs.openclaw.homeManagerModules.openclaw
  ];

  # Keep the upstream option schema, but do not enable its managed config path.
  # OpenClaw mutates ~/.openclaw/openclaw.json at runtime, so Home Manager should
  # not own that file directly.
  programs.openclaw.package = lib.mkDefault defaultOpenclawPackage;
  programs.openclaw.config.gateway.controlUi.root = lib.mkDefault controlUiTarget;

  home.packages = [ openclawPackage ];

  home.activation.openclawDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run --quiet ${lib.getExe' coreutils "mkdir"} -p ${stateDir} ${workspaceDir} ${logDir}
  '';

  home.activation.openclawControlUiAssets = lib.hm.dag.entryAfter [ "openclawDirs" ] ''
    temp_dir="${controlUiTarget}.tmp"

    # Copy dashboard assets out of /nix/store so OpenClaw does not reject them
    # as hardlinked files during safe static file serving.
    run --quiet ${lib.getExe' coreutils "rm"} -rf "$temp_dir"
    run --quiet ${lib.getExe' coreutils "mkdir"} -p "$temp_dir"
    run --quiet ${lib.getExe' coreutils "cp"} -R ${controlUiSource}/. "$temp_dir/"
    run --quiet ${lib.getExe' coreutils "rm"} -rf ${controlUiTarget}
    run --quiet ${lib.getExe' coreutils "mv"} "$temp_dir" ${controlUiTarget}
  '';

  systemd.user.services.openclaw-gateway = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    Unit = {
      Description = "OpenClaw gateway";
    };

    Service = {
      ExecStartPre =
        "${openclawBinary} config set gateway.controlUi.root ${lib.escapeShellArg controlUiTarget}";
      ExecStart = "${openclawBinary} gateway";
      WorkingDirectory = stateDir;
      Restart = "always";
      RestartSec = "1s";
      Environment = [
        "HOME=${config.home.homeDirectory}"
        "OPENCLAW_STATE_DIR=${stateDir}"
      ];
      StandardOutput = "append:${logPath}";
      StandardError = "append:${logPath}";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
