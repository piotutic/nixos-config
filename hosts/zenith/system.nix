{ ... }:

{
  imports = [
    ../../modules/system/common
    ../../modules/system/optional/gui
    # ../../modules/system/optional/docker.nix
    ../../modules/system/optional/mullvad.nix
    ../../modules/system/optional/plymouth.nix
    ../../modules/system/optional/auto-commit.nix
    ../../modules/system/optional/nvidia.nix
    ../../modules/system/optional/gaming.nix
  ];
}
