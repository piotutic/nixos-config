{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
  homeDir = config.home.homeDirectory;
  openclawPackage = inputs.openclaw.packages.${system}.openclaw;
  openclawGatewayPackage = inputs.openclaw.packages.${system}."openclaw-gateway";
  openclawBinary = lib.getExe' openclawGatewayPackage "openclaw";
  stateDir = "${homeDir}/.openclaw";
  workspaceDir = "${stateDir}/workspace";
  controlUiDir = "${stateDir}/control-ui";
  tempControlUiDir = "${controlUiDir}.tmp";
  controlUiSource = "${openclawGatewayPackage}/lib/openclaw/dist/control-ui";
  logDir = "${stateDir}/logs";
  logPath = "${logDir}/gateway.log";
  coreutils = pkgs.coreutils;
  prepareGateway = pkgs.writeShellScript "openclaw-gateway-prepare" ''
    set -euo pipefail

    target_dir="${controlUiDir}"
    temp_dir="${tempControlUiDir}"

    ${lib.getExe' coreutils "mkdir"} -p "${stateDir}" "${workspaceDir}" "${logDir}"

    if [ -e "$temp_dir" ]; then
      ${lib.getExe' coreutils "chmod"} -R u+w "$temp_dir" || true
      ${lib.getExe' coreutils "rm"} -rf "$temp_dir"
    fi

    ${lib.getExe' coreutils "mkdir"} -p "$temp_dir"
    ${lib.getExe' coreutils "cp"} -R ${controlUiSource}/. "$temp_dir/"
    ${lib.getExe' coreutils "chmod"} -R u+w "$temp_dir" || true

    if [ -e "$target_dir" ]; then
      ${lib.getExe' coreutils "chmod"} -R u+w "$target_dir" || true
      ${lib.getExe' coreutils "rm"} -rf "$target_dir"
    fi

    ${lib.getExe' coreutils "mv"} "$temp_dir" "$target_dir"

    ${openclawBinary} config set gateway.mode local
    ${openclawBinary} config set gateway.controlUi.root ${lib.escapeShellArg controlUiDir}
  '';
in

{
  home.packages = [ openclawPackage ];

  systemd.user.services.openclaw-gateway = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    Unit = {
      Description = "OpenClaw gateway";
    };

    Service = {
      ExecStartPre = "${prepareGateway}";
      ExecStart = "${openclawBinary} gateway";
      WorkingDirectory = stateDir;
      Restart = "always";
      RestartSec = "1s";
      Environment = [
        "HOME=${homeDir}"
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
