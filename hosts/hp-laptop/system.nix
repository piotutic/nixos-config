{ ... }:

{
  imports = [
    ../../modules/system/common
    ../../modules/system/optional/gui
    ../../modules/system/optional/mullvad.nix
    ../../modules/system/optional/plymouth.nix
    ../../modules/system/optional/auto-commit.nix
    ../../modules/system/optional/portable.nix
    ../../modules/system/optional/power-management.nix
  ];

  pio.portable.lidAction = "poweroff";
}
