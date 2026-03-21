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
      # rustup
      cargo
      cargo-edit
      cargo-watch
      rustfmt
      # cargo-outdated
      # cargo-audit
      rust-analyzer
      clippy
      nixfmt
      # minijinja-cli
    ];
    environment.etc."cargo/config.toml".text = ''
      [net]
      git-fetch-with-cli = true
    '';
  };
}

