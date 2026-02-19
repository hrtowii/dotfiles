{inputs, pkgs, ...}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    bluemanre
    inputs.librepods.packages.${pkgs.system}.librepods
  ];
}
