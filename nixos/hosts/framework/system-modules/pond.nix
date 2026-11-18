{
  config,
  hostVars,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  pond = config.programs.pond;
  greeterDir = "${pond.greeter.package}/share/pond-interface/lockscreen";
  lock = "${pond.lockscreen.package}/bin/pond-lock";
  beforeSleep = pkgs.writeShellScript "pond-before-sleep" ''
    if ! ${lib.getExe' pkgs.coreutils "timeout"} 4s ${lock} lock; then
      ${lib.getExe' pkgs.util-linux "logger"} -t pond-lock 'Session lock was not confirmed before sleep'
      exit 1
    fi
  '';
  idleArgs = [
    (lib.getExe pkgs.swayidle)
    "-C"
    "/dev/null"
    "-w"
    "before-sleep"
    (toString beforeSleep)
  ];
  fonts = pkgs.runCommand "framework-pond-fonts" { } ''
    install -Dm644 ${../../../home-manager/fonts/onest.ttf} "$out/share/fonts/truetype/Onest.ttf"
    install -Dm644 -t "$out/share/fonts/opentype" ${../../../home-manager/fonts/otf-pond-gramercy}/PondGramercy-*.otf
  '';
in
{
  imports = [ inputs.pond.nixosModules.default ];

  programs.pond = {
    greeter.enable = true;
    lockscreen.enable = true;
    plymouth.enable = true;
    shell.enable = true;
  };

  programs.niri.package = lib.mkIf pond.shell.enable pkgs.niri;

  fonts.packages = [ fonts ];

  services.displayManager.sddm = {
    theme = "greeter";
    settings = {
      Theme.ThemeDir = greeterDir;
      General.GreeterEnvironment = "";
      Wayland.CompositorCommand = "${lib.getExe config.programs.niri.package} --config ${greeterDir}/greeter/niri.kdl";
    };
    extraPackages = [ pond.greeter.package ];
  };

  stylix.targets.plymouth.enable = false;
  boot.plymouth = {
    enable = true;
    theme = "pond";
    themePackages = [ pond.plymouth.package ];
    extraConfig = "UseSimpledrm=1";
  };

  security.pam.services.pond-lockscreen = { };
  environment.sessionVariables.POND_PAM_SERVICE = "pond-lockscreen";

  home-manager.users.${hostVars.username} = {
    programs.niri.settings = {
      binds."Mod+Alt+L".action.spawn = lock;
      spawn-at-startup = lib.mkAfter [ { argv = idleArgs; } ];
    };

    # Pond owns the notification bus in Niri. Keep the Sway service available.
    systemd.user.services.swaync.Unit.ConditionEnvironment = lib.mkIf pond.shell.enable (
      lib.mkForce [ "WAYLAND_DISPLAY" "!XDG_CURRENT_DESKTOP=niri" ]
    );

    wayland.windowManager.sway.extraConfig = lib.mkAfter ''
      bindsym $mod+Mod1+l exec ${lock}
      exec --no-startup-id ${lib.escapeShellArgs idleArgs}
    '';
  };
}
