{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    quickshell
  ];
}
