# Gaming support (Steam, Proton, GameMode)
{ config, lib, pkgs, ... }:

let
  cfg = config.pio.features.gaming;
in {
  options.pio.features.gaming = {
    enable = lib.mkEnableOption "Gaming support (Steam, Proton, GameMode)";
  };

  config = lib.mkIf cfg.enable {
    # Steam + Proton
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin  # GE-Proton for better game compatibility
      ];
    };

    # GameMode for performance optimization during games
    programs.gamemode.enable = true;
  };
}
