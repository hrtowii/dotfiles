{ config, pkgs, ... }:

{
  systemd.user.services.art-daemon = {
    Unit = {
      Description = "Art daemon that writes current track info";
    };

    Service = {
      Type = "simple";
      ExecStart = "/home/${config.home.username}/dev/art_daemon/target/release/art_daemon";
      WorkingDirectory = "/home/${config.home.username}/dev/art_daemon";
      Restart = "always";
      RestartSec = 30;
      StandardOutput = "file:/home/${config.home.username}/dev/art_daemon/art_daemon.out";
      StandardError = "file:/home/${config.home.username}/dev/art_daemon/art_daemon.err";
      ProtectHome = false;
      PrivateTmp = true;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
