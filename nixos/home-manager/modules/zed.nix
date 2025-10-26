{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.zed;
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  config =
    let
      # `pkgs.zed-editor` only emits the `zeditor` binary, but we also want an `zed`
      zeditorAlias = pkgs.writeShellScriptBin "zed" "${lib.getExe pkgs.zed-editor} $@";
    in
    {
      home.packages = [
        pkgs.zed-editor
        zeditorAlias
      ];
    };
}
