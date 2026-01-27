{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    uv
    ruff
  ];
}

