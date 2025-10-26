{ pkgs, inputs, system, ... }: {
  home.packages = [
    inputs.caelestia-shell.packages.${pkgs.system}.default
  ];
}
