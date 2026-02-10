final: prev: let
  soapysdrModules = builtins.attrNames (builtins.readDir "${prev.soapysdr}/lib/SoapySDR");
  modulesDirName = lib.findFirst (name: lib.hasPrefix "modules" name) "modules0.8-3" soapysdrModules;
in {
  libmirisdr = final.callPackage ../pkgs/libmirisdr { };
  soapymiri = final.callPackage ../pkgs/soapymiri { };
  
  soapysdr-with-plugins = prev.symlinkJoin {
    name = "soapysdr-with-plugins";
    paths = [ prev.soapysdr final.soapymiri ];
    buildInputs = [ prev.makeWrapper ];
    postBuild = ''
      mkdir -p $out/lib/SoapySDR/${modulesDirName}
      
      for f in ${prev.soapysdr}/lib/SoapySDR/${modulesDirName}/*.so* \
               ${final.soapymiri}/lib/SoapySDR/${modulesDirName}/*.so*; do
        [ -f "$f" ] && ln -sf "$f" $out/lib/SoapySDR/${modulesDirName}/
      done
      
      wrapProgram $out/bin/SoapySDRUtil \
        --set SOAPY_SDR_PLUGIN_PATH "$out/lib/SoapySDR/${modulesDirName}"
    '';
  };
}
