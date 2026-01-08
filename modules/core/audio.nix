# Audio configuration with PipeWire
{ config, lib, pkgs, ... }:

{
  # Disable PulseAudio (we use PipeWire)
  services.pulseaudio.enable = false;

  # Enable rtkit for real-time priority
  security.rtkit.enable = true;

  # PipeWire audio stack
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
