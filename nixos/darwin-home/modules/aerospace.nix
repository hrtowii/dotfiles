{ pkgs, ... }: {
  launchd.user.agents.aerospace = {
    path = [ pkgs.sketchybar ];
    command = "${pkgs.aerospace}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}
