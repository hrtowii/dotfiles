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
users.groups.libvirtd.members = [ "venti" ];
users.groups.kvm.members = [ "venti" ];
environment.systemPackages = with pkgs; [
    gnome-boxes # VM management
    dnsmasq # VM networking
    phodav # (optional) Share files with guest VMs
];

}

