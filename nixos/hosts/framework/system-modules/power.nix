{ lib, pkgs, hostVars, ... }:
let
  homeDirectory = "${hostVars.homePrefix}/${hostVars.username}";
in
{
  powerManagement.enable = true;
  # TLP owns the tunables; PowerTOP is available for measurement only.
  # https://linrunner.de/tlp/faq/powertop.html
  powerManagement.powertop.enable = false;
  services.power-profiles-daemon.enable = lib.mkForce false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      # Respect firmware ASPM defaults instead of forcing performance.
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "default";
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
      USB_AUTOSUSPEND = 1;
    };
  };
  services.upower.enable = true;
  environment.systemPackages = [ pkgs.powertop ];

  # Run as the logged-in user so swaymsg can reach the compositor socket.
  # UPower events avoid a timer waking the CPU throughout battery operation.
  systemd.user.services.framework-sway-power = {
    description = "Framework Sway refresh rate and adaptive sync by power source";
    wantedBy = [ "default.target" ];
    path = [ pkgs.sway pkgs.jq pkgs.upower pkgs.coreutils ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash ${homeDirectory}/.local/bin/framework-sway-power";
      Restart = "always";
      RestartSec = 3;
    };
  };
  home-manager.users.${hostVars.username} = { config, ... }: {
    home.file.".local/bin/framework-sway-power".source =
      config.lib.file.mkOutOfStoreSymlink
        "${homeDirectory}/dotfiles/nixos/home-manager/scripts/framework-sway-power.sh";
    wayland.windowManager.sway.extraConfig = lib.mkAfter ''
      output eDP-1 adaptive_sync on
      exec_always --no-startup-id ${pkgs.systemd}/bin/systemctl --user restart framework-sway-power.service
    '';
  };
}
