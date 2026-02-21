{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    osu-lazer-bin
  ];
}
