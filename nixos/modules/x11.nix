# For xorgsisters only
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    xorg.xdpyinfo
    slop
    xorg.libX11
    xorg.libXtst
    xorg.libXi
    xorg.xorgproto
    xclip
    xorg.xev
  ];
}
