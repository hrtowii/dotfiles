{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
  noto-fonts
  noto-fonts-cjk-sans
  noto-fonts-cjk-serif
  noto-fonts-color-emoji
  nerd-fonts.fantasque-sans-mono
  nerd-fonts.fira-code
  nerd-fonts.geist-mono
  nerd-fonts.zed-mono
  nerd-fonts.departure-mono
  maple-mono.NF
  cozette
  azuki
];
}
