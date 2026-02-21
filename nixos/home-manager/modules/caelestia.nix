{ pkgs, inputs, ... }: {
  home.packages = [
    inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
