{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # vscode-fhs
  ];
  # home.activation = {
  #   test = home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   mkdir testdir
  #   '';
  # };
  # ln -s (realpath vscode) $config/$folder

  # # Install extension
  # $prog --install-extension $config/$folder/caelestia-vscode-integration/caelestia-vscode-integration-*.vsix
}
