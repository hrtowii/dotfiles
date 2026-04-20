{ inputs, ... }:
{
  imports = [ inputs.nixcord.homeModules.nixcord ];
  # ... config
  programs.nixcord = {
    enable = true;

    discord = {
      vencord = {
        enable = true;
      };
      enable = true;
      branch = "stable";
      autoscroll.enable = true;
    };
    config = {
      enableReactDevtools = true;
      disableMinSize = true;
      frameless = true;
      plugins = {
        ClearURLs.enable = true;
        LastFMRichPresence.enable = true;
        MutualGroupDMs.enable = true;
        ReviewDB.enable = true;
        # USRBG.enable = true;
        fakeNitro.enable = true;
      };
    };
  };
}
