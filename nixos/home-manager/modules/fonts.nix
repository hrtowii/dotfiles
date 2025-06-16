
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
  noto-fonts
  noto-fonts-extra
  noto-fonts-cjk-sans
  noto-fonts-cjk-serif
  noto-fonts-color-emoji
  # (nerdfonts.override {
  #   fonts = [
  #     "FiraCode"
  #     "JetBrainsMono"
  #     "CascadiaCode"
  #     "FantasqueSansMono"
  #   ];
  # })
  nerd-fonts.fantasque-sans-mono
  nerd-fonts.fira-code
  nerd-fonts.geist-mono
  nerd-fonts.zed-mono
  maple-mono.NF
];
}
