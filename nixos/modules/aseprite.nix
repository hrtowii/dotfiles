
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    aseprite
  ];
}
