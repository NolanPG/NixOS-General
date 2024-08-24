{config, lib, pkgs, ...}:

{
  powerManagement.enable = true;

  services = {
    thermald.enable = true;
    auto-cpufreq.enable = true;

    power-profiles-daemon.enable = true;
  };

  environment.systemPackages = [ pkgs.kdePackages.drkonqi ];
}