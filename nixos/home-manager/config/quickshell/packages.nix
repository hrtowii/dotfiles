{ config, pkgs, inputs, lib, ... }:

let
  # Caelestia scripts derivation with Python shebang fixes
  caelestia-scripts = pkgs.stdenv.mkDerivation rec {
    pname = "caelestia-scripts";
    version = "unstable-2024-01-07";

    src = pkgs.fetchFromGitHub {
      owner = "caelestia-dots";
      repo = "scripts";
      rev = "main";
      sha256 = "sha256-fGmOP1pVNZ9SXZIzEjUxWDXpUPBIFI/oRyINSUTarcM=";
    };

    nativeBuildInputs = with pkgs; [
      makeWrapper
    ];

    buildInputs = with pkgs; [
      fish
      (python3.withPackages (ps: with ps; [
        materialyoucolor
        pillow
      ]))
    ];

    patchPhase = ''
      # Fix hardcoded paths to use XDG directories
      # For Fish files - use $HOME which Fish understands
      find . -name "*.fish" -type f | while read -r file; do
        # Replace specific patterns found in the scripts
        sed -i 's|$src/../data/schemes|$HOME/.local/share/caelestia/schemes|g' "$file"
        sed -i 's|(dirname (status filename))/data|$HOME/.local/share/caelestia|g' "$file"
        sed -i 's|$src/data|$HOME/.local/share/caelestia|g' "$file"
      done

      # For Python files
      find . -name "*.py" -type f | while read -r file; do
        sed -i 's|os.path.join(os.path.dirname(__file__), "..", "data")|os.path.expanduser("~/.local/share/caelestia")|g' "$file"
        sed -i 's|Path(__file__).parent.parent / "data"|Path.home() / ".local" / "share" / "caelestia"|g' "$file"
      done
    '';

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/caelestia-scripts

      # Copy all the scripts to share directory
      cp -r * $out/share/caelestia-scripts/

      # Fix Python shebangs for NixOS with the wrapped Python
      find $out/share/caelestia-scripts -name "*.py" -type f -exec sed -i '1s|^#!/bin/python3|#!${pkgs.python3.withPackages (ps: with ps; [ materialyoucolor pillow ])}/bin/python3|' {} \;
      find $out/share/caelestia-scripts -name "*.py" -type f -exec sed -i '1s|^#!/bin/python|#!${pkgs.python3.withPackages (ps: with ps; [ materialyoucolor pillow ])}/bin/python|' {} \;
      find $out/share/caelestia-scripts -name "*.py" -type f -exec sed -i '1s|^#!/usr/bin/env python3|#!${pkgs.python3.withPackages (ps: with ps; [ materialyoucolor pillow ])}/bin/python3|' {} \;
      find $out/share/caelestia-scripts -name "*.py" -type f -exec sed -i '1s|^#!/usr/bin/env python|#!${pkgs.python3.withPackages (ps: with ps; [ materialyoucolor pillow ])}/bin/python|' {} \;

      # Make Python scripts executable
      find $out/share/caelestia-scripts -name "*.py" -type f -exec chmod +x {} \;

      # Create a setup script that ensures data directories exist
      cat > $out/bin/caelestia-setup <<EOF
      #!/bin/sh
      DATA_HOME="\$HOME/.local/share/caelestia"
      STATE_HOME="\$HOME/.local/state/caelestia"
      CACHE_HOME="\$HOME/.cache/caelestia"

      mkdir -p "\$DATA_HOME/schemes/dynamic"
      mkdir -p "\$STATE_HOME/wallpaper"
      mkdir -p "\$CACHE_HOME/schemes"

      # Copy data files if they don't exist
      if [ ! -d "\$DATA_HOME/schemes" ] && [ -d "$out/share/caelestia-scripts/data/schemes" ]; then
        cp -r "$out/share/caelestia-scripts/data/schemes" "\$DATA_HOME/"
      fi
      if [ ! -f "\$DATA_HOME/config.json" ] && [ -f "$out/share/caelestia-scripts/data/config.json" ]; then
        cp "$out/share/caelestia-scripts/data/config.json" "\$DATA_HOME/"
      fi
      if [ ! -f "\$DATA_HOME/emojis.txt" ] && [ -f "$out/share/caelestia-scripts/data/emojis.txt" ]; then
        cp "$out/share/caelestia-scripts/data/emojis.txt" "\$DATA_HOME/"
      fi
      EOF
      chmod +x $out/bin/caelestia-setup

      # Create wrapper for main script with all required tools in PATH
      makeWrapper ${pkgs.fish}/bin/fish $out/bin/caelestia \
        --add-flags "$out/share/caelestia-scripts/main.fish" \
        --run "$out/bin/caelestia-setup" \
        --prefix PATH : ${lib.makeBinPath (with pkgs; [
          imagemagick
          wl-clipboard
          fuzzel
          socat
          foot
          jq
          (python3.withPackages (ps: with ps; [ materialyoucolor pillow ]))
          grim
          wayfreeze
          wl-screenrec
          git
          coreutils
          findutils
          gnugrep
          xdg-user-dirs
        ])}
    '';

    meta = with lib; {
      description = "Caelestia dotfiles scripts";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };

  # Wrap quickshell with Qt dependencies and required tools in PATH
  quickshell-wrapped = pkgs.runCommand "quickshell-wrapped" {
    nativeBuildInputs = [ pkgs.makeWrapper ];
  } ''
    mkdir -p $out/bin
    makeWrapper ${inputs.quickshell.packages.${pkgs.system}.default}/bin/qs $out/bin/qs \
      --prefix QT_PLUGIN_PATH : "${pkgs.qt6.qtbase}/${pkgs.qt6.qtbase.qtPluginPrefix}" \
      --prefix QT_PLUGIN_PATH : "${pkgs.qt6.qt5compat}/${pkgs.qt6.qtbase.qtPluginPrefix}" \
      --prefix QML2_IMPORT_PATH : "${pkgs.qt6.qt5compat}/${pkgs.qt6.qtbase.qtQmlPrefix}" \
      --prefix QML2_IMPORT_PATH : "${pkgs.qt6.qtdeclarative}/${pkgs.qt6.qtbase.qtQmlPrefix}" \
      --prefix PATH : ${lib.makeBinPath [ pkgs.fd pkgs.coreutils ]}
  '';

in
{
  options.programs.quickshell = {
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = quickshell-wrapped;
      description = "The wrapped quickshell package with Qt dependencies";
    };

    caelestia-scripts = lib.mkOption {
      type = lib.types.package;
      default = caelestia-scripts;
      description = "The caelestia scripts package";
    };
  };
}
