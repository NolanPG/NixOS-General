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

    power-profiles-daemon.enable = true;
  };

  environment.systemPackages = [ pkgs.kdePackages.drkonqi ];
}