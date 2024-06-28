{ config, lib, pkgs, ... }:

{
  # GTK appmenu dependency
  # chaotic.appmenu-gtk3-module.enable = true; # This is giving a strange error at the moment when building

  # Enabling Xorg even though I use Wayland because some Xorg apps had troubles with XWayland support (Not sure about that)
  services.xserver.enable = true;
  programs.xwayland.enable = true;

  # Setting sddm as the display manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Plasma Wayland as default
  services.displayManager.defaultSession = "plasma";

  # Plasma 6 as the DE, for the time being it is only available in NixOS Unstable
  services.desktopManager.plasma6.enable = true;

  # Enabling XDG Portal to make GTK apps use the QT Portal when opening files or folders
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-kde
    ];
    # Force GTK apps to use QT FM for opening folders
    # gtkUsePortal = true;
  };

  environment.systemPackages = with pkgs; [
    libsForQt5.kservice # kbuildsycoca5
    kdePackages.sddm-kcm # sddm settings module
    libreoffice-qt-fresh

    # KDE Plasma dependencies
    kdePackages.appstream-qt # libsForQt5 is replaced by kdePackages to keep coherence for Plasma 6 naming
    gsettings-qt # Dependency for sound management
    gsettings-desktop-schemas
    kdePackages.plasma-pa
    kdePackages.pulseaudio-qt
    kdePackages.plasma-browser-integration
    kdePackages.signond
    libnotify
  ];

  environment.variables = {
    # Force GTK apps to use QT Portal for opening folders or files (same as gtkUsePortal = true; but that's deprecated)
    GTK_USE_PORTAL = "1";
  };
}