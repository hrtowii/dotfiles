 {
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
  nerd-fonts.fantasque-sans-mono
  nerd-fonts.fira-code
  nerd-fonts.geist-mono
  nerd-fonts.zed-mono
  nerd-fonts.departure-mono
  nerd-fonts.jetbrains-mono
  maple-mono.NF
  cozette
];
}

