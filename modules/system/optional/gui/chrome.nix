{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    google-chrome
  ];

  # Managed policy for Chromium-based browsers. Writes
  # /etc/opt/chrome/policies/managed/default.json, which Google Chrome reads on
  # startup, so the extension is force-installed from the Chrome Web Store on
  # first launch instead of being clicked in by hand.
  #
  # fcoeoabgfenejglbffodgkkbkcdhcgfn is "Claude for Chrome". It is the only
  # origin allowed by the native-messaging manifest Claude Code installs at
  # ~/.config/google-chrome/NativeMessagingHosts/, which is how the browser and
  # the CLI talk to each other.
  programs.chromium = {
    enable = true;
    extensions = [
      "fcoeoabgfenejglbffodgkkbkcdhcgfn"
    ];
  };
}
