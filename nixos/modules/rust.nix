{
  config,
  pkgs,
  lib,
  ...
}: {
  options.rust = {
    enable = lib.mkEnableOption "System Rust Environment";
  };

  config = lib.mkIf config.rust.enable {
    environment.systemPackages = with pkgs; [
      rustc
      rustup
      cargo-edit
      cargo-watch
      cargo-outdated
      cargo-audit
      rust-analyzer
      clippy
      minijinja-cli
    ];

    environment.variables = {
      PATH = [
        "${pkgs.rustc}/bin"
        "${pkgs.cargo}/bin"
      ];
    };
  };
}
