{
  pkgs,
  lib,
  config,
  ...
}: {
  environment.variables = {
    QT_QPA_PLATFORMTHEME = lib.mkOverride 0 "qt6ct";
    # QT_STYLE_OVERRIDE = "Fusion";
  };
  environment.systemPackages = with pkgs; [
    qt6.qtdeclarative
    qt6.qtwayland
    qt6.qtsvg
    qt6.qtmultimedia
    qt6.qtimageformats
    qt5.qtwayland
  ];
}
