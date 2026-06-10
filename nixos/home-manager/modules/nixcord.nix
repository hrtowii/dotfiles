{ inputs, ... }:
{
  imports = [ inputs.nixcord.homeModules.nixcord ];
  programs.nixcord = {
    enable = true;

    discord = {
      commandLineArgs = [
        "--enable-features=VaapiVideoDecoder,MiddleClickAutoscroll"
        # use wayland and enable IME
        "--ozone-platform-hint=auto"
        "--enable-wayland-ime"
      ];
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
      # frameless = true;
      plugins = {
        ClearURLs.enable = true;
        LastFMRichPresence.enable = true;
        MutualGroupDMs.enable = true;
        ReviewDB.enable = true;
        USRBG.enable = true;
        fakeNitro.enable = true;
      };
    };
  };
}
