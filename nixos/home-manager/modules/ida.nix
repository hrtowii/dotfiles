# https://git.eisfunke.com/MonsterDruide1/nixos/-/blob/main/packages/ida.nix
{ stdenv, fetchzip, fetchurl, fetchPypi, makeDesktopItem, icoutils, imagemagick, xvfb-run, acl, wineWowPackage ... }:
stdenv.mkDerivation rec {
  name = "ida-package";
  version = "1.3";

  srcIDA = fetchzip {
    url = "https://monsterdruide.one/smo-ida/IDA-Pro-7.7-main.zip";
    sha256 = "sha256-+N1fAAVK4ykxYOYwEAAJDrMUXhToOoHmJGE2chvFdEY=";
  };
  nxoloader = fetchurl {
    url = "https://raw.githubusercontent.com/reswitched/loaders/master/nxo64.py";
    sha256 = "sha256-WB5xQUwCNM1aVSn11gDqzIzrUxTZ0GsmZYxo34chFm4=";
  };
  pythoninstaller = fetchurl {
    url = "https://www.python.org/ftp/python/3.10.0/python-3.10.0-amd64.exe";
    sha256 = "sha256-y1gOt9xV+RmOZQ8BZkUCPosiJM99AzhX0SiAtGxclO8=";
  };
  pypiYara = fetchPypi {  # only has source-releases, which are cross-platform
    pname = "yara";
    version = "1.7.7";
    sha256 = "sha256-PunPV30zYMeFlz/PYvdi3yHh3PBfpJd0C8Fq4jweouk=";
  };
  pypiKeystone = fetchPypi {  # prefer source-releases, which are cross-platform, but this one requires a cmake toolchain
    pname = "keystone_engine";  # why does the binary version have "_" instead of "-"?
    version = "0.9.2";
    format = "wheel";
    platform = "win_amd64";
    dist = "py2.py3";
    sha256 = "sha256-yR2x/xbZ0JTgDRgnEH0bSv1eY84ZtJGgFA5mBjUADos=";
  };
  pypiSix = fetchPypi {  # prefer source-releases, which are cross-platform
    pname = "six";
    version = "1.16.0";
    sha256 = "sha256-HmHDdHehYmRY4297HYKqXJsJT6SAKJIHLknenGDEySY=";
  };
  pypiLz4 = fetchPypi {  # has binary releases, so download the win-specific wheel
    pname = "lz4";
    version = "4.3.3";
    format = "wheel";
    python = "cp310";
    abi = "cp310";
    dist = "cp310";
    platform = "win_amd64";
    sha256 = "sha256-Q88DBZwPlBt3LIrrQqCBPWjXCBwAlUIwFjfleC+KM+I=";
  };
  preparewine = stdenv.mkDerivation {
    # prepare WINEPREFIX with python installation in nix store
    name = "preparewine2";
    src = srcIDA;  # useless, but required attribute
    buildInputs = [ xvfb-run acl ];
    installPhase = ''
      mkdir -p $out/.wine
      chown -R $(whoami) $out/.wine
      USER=monsterdruide1 WINEPREFIX=$out/.wine DISPLAY= WINEARCH=win64 ${wineWowPackages.staging}/bin/wine64 wineboot
      USER=monsterdruide1 WINEPREFIX=$out/.wine xvfb-run ${wineWowPackages.staging}/bin/wine64 ${pythoninstaller} /quiet InstallAllUsers=1 PrependPath=1 Include_test=0 Include_pip=1 Include_doc=0 Include_dev=0 Include_launcher=0
      USER=monsterdruide1 WINEPREFIX=$out/.wine DISPLAY= WINEARCH=win64 ${wineWowPackages.staging}/bin/wine64 pip install ${pypiYara}
      USER=monsterdruide1 WINEPREFIX=$out/.wine DISPLAY= WINEARCH=win64 ${wineWowPackages.staging}/bin/wine64 pip install ${pypiSix}

      KEYSTONEDIR=`mktemp -d`
      cp ${pypiKeystone} $KEYSTONEDIR/$(stripHash ${pypiKeystone})
      USER=monsterdruide1 WINEPREFIX=$out/.wine DISPLAY= WINEARCH=win64 ${wineWowPackages.staging}/bin/wine64 pip install $KEYSTONEDIR/$(stripHash ${pypiKeystone})

      LZDIR=`mktemp -d`
      cp ${pypiLz4} $LZDIR/$(stripHash ${pypiLz4})
      USER=monsterdruide1 WINEPREFIX=$out/.wine DISPLAY= WINEARCH=win64 ${wineWowPackages.staging}/bin/wine64 pip install $LZDIR/$(stripHash ${pypiLz4})

      USER=monsterdruide1 WINEPREFIX=$out/.wine DISPLAY= WINEARCH=win64  ${wineWowPackages.staging}/bin/wineserver -w
      pushd $out
        getfacl -R .wine > wine-permissions.acl
      popd
    '';
  };
  srcIDAWithLoader = stdenv.mkDerivation rec {
    name = "ida-with-loader";
    src = srcIDA;
    installPhase = ''
      mkdir -p $out
      cp -r ${src}/* $out
      chmod +w $out/loaders
      cp ${nxoloader} $out/loaders/nxo64.py
      chmod -w $out/loaders
    '';
  };
  src = stdenv.mkDerivation rec {
    name = "ida-final";
    src = srcIDAWithLoader;
    buildInputs = [ xvfb-run ];
    installPhase = ''
      export XDG_CACHE_HOME="$(mktemp -d)"
      mkdir -p $out $out/.wine
      cp -r ${preparewine}/.wine/* $out/.wine
      cp ${preparewine}/wine-permissions.acl $out
      chown -R $(whoami) $out/.wine
      chmod -R +w $out/.wine
      cp -r ${src}/* $out
      chmod -R +w $out/python
      USER=monsterdruide1 WINEPREFIX=$out/.wine ${wineWowPackages.staging}/bin/wine64 $out/idapyswitch.exe --force-path 'C:/Program Files/Python310/python.exe'
      USER=monsterdruide1 WINEPREFIX=$out/.wine ${wineWowPackages.staging}/bin/wine64 cmd /c reg delete 'HKCU\Software\Hex-Rays\IDA' /v Python3TargetDLL /f
      chmod -R -w $out/python
    '';
  };

  resetShortcut = makeDesktopItem rec {
    desktopName = "reset-wine";
    name = "reset-wine-desktop31";
    exec = "sh -c \"echo ${name} && sudo rm -r ~/.wine/* && cp -r ${src}/.wine/. ~/.wine/ && echo CopyDone && cd ~ && sudo setfacl --restore=${src}/wine-permissions.acl && sudo chown -R monsterdruide1:users ~/.wine && echo ${name}\"";
    categories = [ "GNOME" "GTK" "Development" ];
    terminal = true;
  };
  desktopItem = makeDesktopItem {
    desktopName = "ida64";
    name = "ida64-desktop4";
    exec = "sh -c \"cd ${src} && ${wineWowPackages.staging}/bin/wine64 ida64.exe\"";
    categories = [ "GNOME" "GTK" "Development" ];
    icon = "ida64";
    startupWMClass = "ida64.exe";
  };

  buildInputs = [ icoutils imagemagick ];

  installPhase = ''
    mkdir -p $out/share $out/share/icons $out/share/applications
    cp -r ${desktopItem}/share/applications/* $out/share/applications
    wrestool -x -t 14 ${src}/ida64.exe > $out/share/icons/ida64.ico
    convert "$out/share/icons/ida64.ico[0]" $out/share/icons/ida64.png
    rm $out/share/icons/ida64.ico

    find $out/share
    cp -r ${resetShortcut}/share/applications/* $out/share/applications
  '';

}

