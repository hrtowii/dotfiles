{ config, pkgs, ... }:

{
  systemd.user.services.art-daemon = {
    description = "connect to lanyard, music status everywhere";

    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "/home/${config.home.username}/dev/art_daemon/target/release/art_daemon";
      WorkingDirectory = "/home/${config.home.username}/dev/art_daemon";
      Restart = "always";
      RestartSec = 3;

      StandardOutput = "file:/home/${config.home.username}/dev/art_daemon/art_daemon.out";
      StandardError  = "file:/home/${config.home.username}/dev/art_daemon/art_daemon.err";

      ProtectHome = false;
      PrivateTmp = true;
    };
  };
}
