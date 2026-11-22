{ pkgs, hostVars, ... }:
{
  environment.systemPackages = [ pkgs.ostui ];

  home-manager.users.${hostVars.username}.xdg.configFile."ostui/config".text = ''
    [auth]
    username = "admin"
    password = "alpine"

    [server]
    host = "http://edgy14yearold:4747"
  '';
}
