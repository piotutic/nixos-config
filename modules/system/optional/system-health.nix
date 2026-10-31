{ pkgs, ... }:

{
  # Compressed swap in RAM; used before the disk swap partition (higher priority).
  zramSwap = {
    enable = true;
    # Max uncompressed size, not RAM used: ~3:1 zstd puts the real cost at
    # about a third of this when full.
    memoryPercent = 100;
  };

  # Tuned for zram: swapping to compressed RAM is cheaper than re-reading
  # evicted file cache from disk, so prefer it (swap:cache weight 180:20).
  # page-cluster 0 disables swap readahead, which only helps on real disks.
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.page-cluster" = 0;
  };

  # Firmware/BIOS updates via LVFS: `fwupdmgr refresh && fwupdmgr update`.
  services.fwupd.enable = true;

  # SMART disk health monitoring; warnings go to logged-in terminals (wall).
  services.smartd.enable = true;
  # smartd doesn't put smartctl on PATH; `sudo smartctl -H -A /dev/nvme0`.
  environment.systemPackages = [ pkgs.smartmontools ];

  # Kill the worst offending cgroup under memory pressure instead of freezing.
  # User slices cover the Hermes user services; the system slice covers the
  # GitHub runner and Docker.
  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableSystemSlice = true;
    enableUserSlices = true;
  };
}
