{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
  };

  services.displayManager.defaultSession = "xfce";

  environment.systemPackages = with pkgs; [
    rofi
    kdePackages.dolphin
    kdePackages.ark
  ];

  services.picom = {
    enable = true;
    settings = {
      backend = "glx";
      glx-no-stencil = true;
      vsync = true;
      unredir-if-possible = true;

      # Animations
      animations = true;

      # Corners
      corner-radius = 10.0;
      rounded-corners-exclude = [
          #"window_type = 'normal'",
          #"class_g = 'Xfce4-panel' && window_type = 'dock'",
          "window_type = 'tooltip'"
      ];
      
      # Opacity
      detect-client-opacity = true;
      
      # Window type settings
      wintypes = {
        normal = { };
        desktop = { };
        tooltip = { shadow = true; opacity = 1; focus = true; full-shadow = false; };
        dock = { };
        dnd = { shadow = false; };
        splash = { };
        popup_menu = { opacity = 1; };
        dropdown_menu = { opacity = 1; };
        utility = { };
      };
    };
  };
}