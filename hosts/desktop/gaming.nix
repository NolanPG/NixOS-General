{
  pkgs,
  pkgs-stable,
  lib,
  user,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    mesa_git
    lact
    pkgs-stable.bottles # Wine manager
    heroic
    ryujinx # Nintendo Switch emulator
    goverlay
    mangohud # Performance monitoring tool for Vulkan and OpenGL games
    osu-lazer-bin
    protonup-qt
    winetricks
    wineWowPackages.stagingFull
    vesktop
    arrpc # Rich Presence server for Vesktop
    nordvpn
    
    pkgs-stable.obs-studio
    easyeffects
    kdePackages.kdenlive
    
    # obs-studio dependencies
    pciutils
    rnnoise
    mesa
    fdk-aac-encoder
    rav1e
    
    # kdePackages.kdenlive Error because this package is built with Qt 6.7.1 and NixOS ships KDE Plasma with 6.7.2
    # davinci-resolve
    # clinfo

    handbrake # ffmpeg_7-full dependency is temporarily broken in the unstable channel
    i2c-tools # OpenRGB dependency

    solaar
    piper
    libnotify
  ];

  chaotic.mesa-git.enable = true;

  # Dependency for Logitech G502 Hero Lightspeed software like Solaar and Piper
  hardware.logitech.wireless.enable = true;
  services.ratbagd.enable = true;

  # OpenCL for Davinci Resolve
  # hardware.graphics.extraPackages = with pkgs; [
  #   rocmPackages.clr.icd
  # ];

  # RGB Configuration
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
    package = pkgs.openrgb-with-all-plugins;
  };

  hardware.amdgpu.overdrive.enable = true;

  systemd.services.lactd = {
  description = "AMDGPU Control Daemon";
  wantedBy = [ "multi-user.target" ];
  after = [ "multi-user.target" ];
  
  serviceConfig = {
    ExecStart = "${pkgs.lact}/bin/lact daemon";
    Type = "simple";
    # Run as root since we need direct hardware access
    User = "root";
    Group = "root";
    Restart = "on-failure";
    RestartSec = "5";
  };
};

  hardware.i2c.enable = true;
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];
  users.groups.i2c.members = [ "nolan" ]; # create i2c group and add default user to it

  # Enable Steam
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
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
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
  };
}
