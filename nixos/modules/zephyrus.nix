{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Base AMD graphics setup — covers the integrated Ryzen 6000 iGPU + RX 6800S dGPU
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Helps with Steam, Proton, older games
  };

  services.xserver.videoDrivers = [ "modesetting" ];

  # Load amdgpu early for console / boot display
  boot.initrd.kernelModules = [ "amdgpu" ];

  # ASUS-specific tools from asus-linux project (asusctl for fan curves, power profiles, anime matrix; supergfxctl for GPU switching)
  services.asusd = {
    enable = true;
    enableUserService = true; # Per-user daemon for rog-control-center GUI if you use it
  };

  services.supergfxd = {
    enable = true;
    # Start in integrated mode for better battery life; change to "Hybrid" for dGPU on-demand
    # Other options: "Discrete" (MUX to dGPU only), "Vfio" (for VM passthrough), "Integrated"
    settings = {
      mode = "Hybrid";
      vfio_enable = false; # Only if doing VFIO GPU passthrough
      hotplug_type = "Asus"; # Required for proper MUX handling on G14
    };
  };
  environment.systemPackages = with pkgs; [
    amdgpu_top
    powertop
    brightnessctl
  ];

  # Optional: better power/thermal defaults for this model
  # Use amd-pstate driver (active or guided mode) for modern Ryzen power management
  boot.kernelParams = [
    "amd_pstate=active" # Or "guided" — active often gives better efficiency on 6000-series
  ];
}
