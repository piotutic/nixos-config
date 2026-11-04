{ pkgs, ... }:

# iPhone support over USB: pairing, device info, file access and tethering.
# usbmuxd multiplexes the USB connection; libimobiledevice talks to the phone
# through it. gvfs (gui/services.nix) mounts it in file managers via AFC.
{
  services.usbmuxd.enable = true;

  environment.systemPackages = with pkgs; [
    libimobiledevice # idevice_id, ideviceinfo, idevicepair, idevicebackup2, ...
    ifuse # mount the phone's media/app documents from the CLI
  ];
}
