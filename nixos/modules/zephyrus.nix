{
  config,
  lib,
  pkgs,
  ...
}:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "modesetting" ];

  boot.initrd.kernelModules = [ "amdgpu" ];

  # services.asusd = {
  #   enable = true;
  #   enableUserService = true;
  # };

  services.supergfxd = {
    enable = true;
    # Other options: "Discrete" (MUX to dGPU only), "Vfio" (for VM passthrough), "Integrated"
    settings = {
      mode = "Hybrid";
      vfio_enable = false; # Only if doing VFIO GPU passthrough
      hotplug_type = "Asus"; # Required for proper MUX handling on G14
    };
  };
  # services.power-profiles-daemon.enable = true;
  services.logind.lidSwitch = "suspend";
  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_TYPE}=="Mains", \
    RUN+="${pkgs.systemd}/bin/systemctl start power-profile-switch.service"
    ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"
  '';
  systemd.services.disable-xhc-wake = {
    description = "Disable XHC wake";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      echo XHC0 > /proc/acpi/wakeup || true
      echo XHC1 > /proc/acpi/wakeup || true
      echo XHC2 > /proc/acpi/wakeup || true
      echo XHC3 > /proc/acpi/wakeup || true
      echo XHC4 > /proc/acpi/wakeup || true
    '';
  };
  systemd.services.power-profile-switch = {
    description = "Switch power profile based on AC state";
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      STATUS_FILE="/sys/class/power_supply/AC/online"

      if [ ! -f "$STATUS_FILE" ]; then
        STATUS_FILE="/sys/class/power_supply/ACAD/online"
      fi

      if [ -f "$STATUS_FILE" ] && [ "$(cat $STATUS_FILE)" = "1" ]; then
        ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance
      else
        ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver
      fi
    '';
  };
  # systemd.services.power-profile-switch.wantedBy = [ "multi-user.target" ];
  environment.systemPackages = with pkgs; [
    amdgpu_top
    powertop
    brightnessctl
  ];

  # Use amd-pstate driver (active or guided mode) for modern Ryzen power management
  boot.kernelParams = [
    "amd_pstate=active" # Or "guided" — active often gives better efficiency on 6000-series
    "mem_sleep_default=deep"
    "usbcore.autosuspend=1"
  ];
}
