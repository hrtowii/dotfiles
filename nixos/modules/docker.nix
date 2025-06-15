{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    lazydocker
  ];
}
