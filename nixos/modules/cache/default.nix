{ ... }:
{
  imports = [
    ./use.nix
    ./push.nix
  ];

  cachePush.enable = true;

  nix.settings.connect-timeout = 5;
}
