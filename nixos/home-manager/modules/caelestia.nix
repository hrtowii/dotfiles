# https://github.com/caelestia-dots/shell/issues/15#issuecomment-2956997901
# https://www.reddit.com/r/unixporn/comments/1l5ll27/comment/mwu67ek/
{
  inputs,
  pkgs,
  ...
}:
{
  home.packages =
    [
      inputs.quickshell.packages.x86_64-linux.default
    ]
    ++ (with pkgs; [
      material-symbols
      nerd-fonts.jetbrains-mono
      ibm-plex
      cava
      bluez
      ddcutil
      brightnessctl
      imagemagick
      fish
      jq
      fd
    ])
    ++ (with pkgs.pythonPackages; [
      aubio
      pyaudio
      numpy
    ]);
}
