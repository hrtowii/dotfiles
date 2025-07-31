{pkgs, inputs, ...}: {
  home.packages = with pkgs; [
    inputs.zen-browser.packages."${system}".twilight
  }
}
