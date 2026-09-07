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

    };
    config = {
      enableReactDevtools = true;
      disableMinSize = true;
      # frameless = true;
      plugins = {
        clearUrls.enable = true;
        LastFMRichPresence.enable = true;
        mutualGroupDms.enable = true;
        reviewDb.enable = true;
        usrbg.enable = true;
        fakeNitro.enable = true;
      };
    };
  };
}
