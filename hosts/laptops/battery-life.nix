{config, lib, pkgs, ...}:

{
  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "powersave";
  };

  services = {
    thermald.enable = true;

    system76-scheduler = {
      enable = true;
      useStockConfig = true;
    };
  };

  environment.systemPackages = [ pkgs.kdePackages.drkonqi ];
}