{ pkgs, lib, config, ... }:



let
  # RX 6650 XT
  gpuIDs = [
    "1002:73ef" # Graphics
    "1002:ab28" # Audio
  ];
in {
  options.vfio.enable = with lib;
    mkEnableOption "Configure the machine for VFIO";

  config = let cfg = config.vfio; in {
    boot = {
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ];

      kernelParams = [
        # enable IOMMU
        "amd_iommu=on"
      ] ++ lib.optional cfg.enable
        # isolate the GPU
        ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs);
    };

    environment.systemPackages = with pkgs; [
      # Apps for VFIO
      looking-glass-client
      virt-manager
    ];

    specialisation."VFIO".configuration = {
      system.nixos.tags = [ "with-vfio" ];
      vfio.enable = true;
    };

    virtualisation.libvirtd = {
      enable = true;
      qemu.ovmf.enable = true;
      qemu.runAsRoot = false;
      onBoot = "ignore";
      onShutdown = "shutdown";
    };

    users.users.nolan.extraGroups = [ "libvirtd" ];

    hardware.graphics.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
  };
  # Added libvirtd and apps for the virtual machine in configuration.nix
}