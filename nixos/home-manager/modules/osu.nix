{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    osu-lazer
  ];
}
