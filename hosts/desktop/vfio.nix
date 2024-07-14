{ pkgs, lib, config, ... }:

{ 
  # Virt-Manager
  environment.systemPackages = with pkgs; [
    # Apps for VFIO
    looking-glass-client
    virglrenderer
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemu.ovmf.enable = true;
    qemu.runAsRoot = false;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };

  programs.virt-manager.enable = true;

  # VMWare
  # virtualisation.vmware.host.enable = true;

  users.users.nolan.extraGroups = [ "libvirtd" ];

  hardware.graphics.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;
}
