{pkgs, inputs, ...}: {
  home.packages = with pkgs; [
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".twilight
  ];
  }
