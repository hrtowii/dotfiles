{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
}
