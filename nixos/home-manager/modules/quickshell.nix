{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    quickshell
    kdePackages.qt5compat
    playerctl
  ];
}
