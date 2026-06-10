{ config, lib, pkgs, ... }:
{
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchExternalPower = "ignore";
    # extraConfig = ''
    #   IdleAction=ignore
    #   IdleActionSec=0
    # '';
  };

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    "hybrid-sleep".enable = false;
  };
}
