final: prev: {
  libmirisdr = final.callPackage ../pkgs/libmirisdr { };
  soapymiri = final.callPackage ../pkgs/soapymiri { };
  ida-pro = final.callPackage ../pkgs/ida93 { };
  osmo-sdr = final.callPackage ../pkgs/osmo-sdr {};
  gqrx = prev.gqrx.overrideAttrs (old: {
    buildInputs = old.buildInputs or [];
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ prev.makeWrapper ];
    postInstall = (old.postInstall or "") + ''
      wrapProgram $out/bin/gqrx \
        --set SOAPY_SDR_PLUGIN_PATH "${final.soapysdr-with-plugins}/lib/SoapySDR/modules0.8-3"
    '';
  });
  soapysdr-with-plugins = prev.symlinkJoin {
    name = "soapysdr-with-plugins";
    paths = [ prev.soapysdr final.soapymiri ];
    buildInputs = [ prev.makeWrapper ];
    postBuild = ''
      for modDir in ${final.soapymiri}/lib/SoapySDR/modules*; do
        [ -d "$modDir" ] || continue
        targetName=$(basename "$modDir")
        mkdir -p "$out/lib/SoapySDR/$targetName"
        
        for f in "$modDir"/*.so*; do
          [ -f "$f" ] && ln -sf "$f" "$out/lib/SoapySDR/$targetName/"
        done
        
        wrapProgram $out/bin/SoapySDRUtil \
          --set SOAPY_SDR_PLUGIN_PATH "$out/lib/SoapySDR/$targetName"
      done
    '';
  };
}
