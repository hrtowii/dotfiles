{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.moonlight-qt
  ];
}
