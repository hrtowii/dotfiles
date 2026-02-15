# Overlay to patch nvidia-open for Linux 6.19 kernel compatibility
final: prev: {
  nvidiaPackages = prev.nvidiaPackages // {
    beta = prev.nvidiaPackages.beta.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or []) ++ [ ./nvidia-6.19.patch ];
    });
  };
}
