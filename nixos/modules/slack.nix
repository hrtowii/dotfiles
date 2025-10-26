{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    slack
  ];
}
