{ inputs, ... }:
{
  imports = [ inputs.nixcord.homeModules.nixcord ];
  # ... config
  programs.nixcord = {
    enable = true;

    discord = {
      enable = true;
      branch = "canary";
      autoscroll.enable = true;
    };
  };
}
