{ config, lib, pkgs, ... }:

{
  # Base AMD graphics setup — covers the integrated Ryzen 6000 iGPU + RX 6800S dGPU
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # Helps with Steam, Proton, older games
  };

  services.xserver.videoDrivers = [ "modesetting" ];

  # Load amdgpu early for console / boot display
  boot.initrd.kernelModules = [ "amdgpu" ];

  # ASUS-specific tools from asus-linux project (asusctl for fan curves, power profiles, anime matrix; supergfxctl for GPU switching)
  services.asusd = {
    enable = true;
    enableUserService = true;  # Per-user daemon for rog-control-center GUI if you use it
  };

  services.supergfxd = {
    enable = true;
    # Start in integrated mode for better battery life; change to "Hybrid" for dGPU on-demand
    # Other options: "Discrete" (MUX to dGPU only), "Vfio" (for VM passthrough), "Integrated"
    settings = {
      mode = "Integrated";  # or "Hybrid"
      vfio_enable = false;  # Only if doing VFIO GPU passthrough
      hotplug_type = "Asus";  # Required for proper MUX handling on G14
    };
  };

  # For ROG AniMe Matrix (the lid LEDs)
  # asusd handles it automatically when enabled above
  # Use `asusctl anime` or rog-control-center to set images/animations
  # Example CLI: asusctl anime -e true; asusctl anime image /path/to/image.png

  # Optional: better power/thermal defaults for this model
  # Use amd-pstate driver (active or guided mode) for modern Ryzen power management
  boot.kernelParams = [
    "amd_pstate=active"  # Or "guided" — active often gives better efficiency on 6000-series
  ];

  # If you notice fan or thermal quirks, consider overriding to a recent kernel
  # boot.kernelPackages = pkgs.linuxPackages_zen;  # Or linuxPackages_latest if needed

  # For explicit dGPU offloading (run apps on RX 6800S when in Hybrid mode)
  # Example: DRI_PRIME=1 steam
  # Or add environment variables in your DE/WM config if desired
}
