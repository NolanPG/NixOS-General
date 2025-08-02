{
  pkgs,
  pkgs-stable,
  lib,
  user,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    pkgs-stable.bottles # Wine manager
    protonup-qt
    wineWowPackages.stagingFull
    obs-studio
    kdePackages.kdenlive
  ];

  hardware = {
    steam-hardware.enable = true;
    # xpadneo.enable = true;
  };

  # Enable gamemode
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 10;
      };
      custom = {
        start = "notify-send -a 'Gamemode' 'Optimizations activated'";
        end = "notify-send -a 'Gamemode' 'Optimizations deactivated'";
      };
    };
  };

  # improvement for games using lots of mmaps (same as steam deck)
  boot.kernel.sysctl = {"vm.max_map_count" = 2147483642;};

  programs.steam = {
    enable = true;
  };
}
