{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    spotify-player
  ];
}
