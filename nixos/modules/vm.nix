{ config, pkgs, ... }:
{
virtualisation.libvirtd = {
    enable = true;

    qemu = {
      swtpm.enable = true;
      ovmf.packages = [ pkgs.OVMFFull.fd ];
    };
  };

  virtualisation.spiceUSBRedirection.enable = true;
}
users.groups.libvirtd.members = [ "htrowii" ];
users.groups.kvm.members = [ "htrowii" ];
environment.systemPackages = with pkgs; [
    gnome-boxes # VM management
    dnsmasq # VM networking
    phodav # (optional) Share files with guest VMs
];

}

