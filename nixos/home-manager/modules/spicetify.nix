{ inputs, pkgs, ... }:
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

programs.spicetify =
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  enable = true;

  enabledExtensions = with spicePkgs.extensions; [
    # adblock
    hidePodcasts
    shuffle # shuffle+ (special characters are sanitized out of extension names)
  ];
  # enabledCustomApps = with spicePkgs.apps; [
  #   newReleases
  #   ncsVisualizer
  # ];
  # enabledSnippets = with spicePkgs.snippets; [
  #   rotatingCoverart
  #   pointer
  # ];

  theme = spicePkgs.themes.ziro;
  colorScheme = "rose-pine";
};
}
