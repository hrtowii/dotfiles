{ config, lib, pkgs, ... }:
let
  cfg = config.programs.personalLauncher;
  quickshell = lib.getExe pkgs.quickshell;
  launcherConfig = "/etc/xdg/quickshell/personal-launcher";
in
{
  options.programs.personalLauncher = {
    enable = lib.mkEnableOption "the personal Quickshell app launcher";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.writeShellScriptBin "personal-launcher" ''
        qs=( ${quickshell} --path ${launcherConfig} )
        case "''${1:-toggle}" in
          start)
            exec "''${qs[@]}" --no-duplicate --daemonize
            ;;
          toggle)
            if "''${qs[@]}" ipc call personalLauncher toggle 2>/dev/null; then
              exit 0
            fi
            "$0" start || exit "$?"
            exec ${pkgs.coreutils}/bin/timeout 1s ${pkgs.bash}/bin/bash -c '
              until "$@" ipc call personalLauncher open 2>/dev/null; do
                ${pkgs.coreutils}/bin/sleep 0.05
              done
            ' launcher "''${qs[@]}"
            ;;
          *)
            echo 'Usage: personal-launcher [start|toggle]' >&2
            exit 2
            ;;
        esac
      '';
      description = "The personal Quickshell launcher command.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    environment.etc."xdg/quickshell/personal-launcher".source = ../home-manager/config/personal-launcher;
  };
}
