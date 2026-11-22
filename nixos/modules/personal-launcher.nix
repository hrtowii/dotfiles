{ config, lib, pkgs, ... }:
let
  cfg = config.programs.personalLauncher;
in
{
  options.programs.personalLauncher = {
    enable = lib.mkEnableOption "the personal Quickshell app launcher";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.writeShellScriptBin "personal-launcher" ''
        exec ${lib.getExe pkgs.quickshell} --no-duplicate --path ${../home-manager/config/personal-launcher} "$@"
      '';
      description = "The personal Quickshell launcher command.";
    };
  };

  config.environment.systemPackages = lib.optional cfg.enable cfg.package;
}
