{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.fastfetch.enable = true;
  programs.ghostty = {
    enable = true;
    package = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;

    settings = {
      font-family = "Maple Mono NF";
      font-size = 12;

      command = "zsh";

      window-padding-x = 10;
      window-padding-y = 10;

      confirm-close-surface = false;
      shell-integration-features = "sudo,title";

      copy-on-select = false;
      # theme = GruvboxDarkHard
    };
  };
}
