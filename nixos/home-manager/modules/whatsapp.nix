{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
  whatsapp-electron
  ];
}

