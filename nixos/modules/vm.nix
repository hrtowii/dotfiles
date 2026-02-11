{ config, pkgs, hostVars, ... }:
{
  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      swtpm.enable = true;
      # ovmf is now available by default with QEMU
    };
  };

  virtualisation.spiceUSBRedirection.enable = true;

  users.groups.libvirtd.members = [ hostVars.username ];
  users.groups.kvm.members = [ hostVars.username ];

  environment.systemPackages = with pkgs; [
    gnome-boxes # VM management
    dnsmasq # VM networking
    phodav # (optional) Share files with guest VMs
  ];
}

