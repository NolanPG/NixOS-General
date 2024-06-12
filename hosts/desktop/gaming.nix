{
  pkgs,
  lib,
  user,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    bottles # Wine manager
    heroic
    ryujinx # Nintendo Switch emulator
    sunshine # Remote gaming solution for streaming games over the internet
    goverlay
    mangohud # Performance monitoring tool for Vulkan and OpenGL games
    osu-lazer-bin
    protonup-qt
    winetricks
    wineWowPackages.stagingFull
    
    obs-studio
    
    # obs-studio dependencies
    pciutils
    rnnoise
    mesa
    fdk-aac-encoder
    rav1e
    
    kdePackages.kdenlive
    xevd
    # handbrake # ffmpeg 7 full is temporalily broken
    i2c-tools # OpenRGB dependency
  ];

  # RGB Configuration
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
    package = pkgs.openrgb-with-all-plugins;
  };
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];
  users.groups.i2c.members = [ "nolan" ]; # create i2c group and add default user to it

  # Enable Steam
  # programs.steam = {
  #   enable = true;
  #   gamescopeSession.enable = true;
  # };

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

  #Enable Gamescope
  programs.gamescope = {
    enable = true;
    package = pkgs.gamescope;
    capSysNice = true;
    args = ["--prefer-vk-device 1002:73ef"];
    env = {
      "__GLX_VENDOR_LIBRARY_NAME" = "amd";
      "DRI_PRIME" = "1";
      "MESA_VK_DEVICE_SELECT" = "pci:1002:73ef";
      "__VK_LAYER_MESA_OVERLAY_CONFIG" = "ld.so.preload";
      "DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1" = "1";
    };
  };
}
