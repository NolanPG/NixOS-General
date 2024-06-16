{ config, lib, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot = {
    # Setting latest stable Linux Kernel from nixpkgs
    kernelPackages = pkgs.linuxPackages_latest;

    # Enabling ntfs support
    supportedFilesystems = [ "ntfs" ];

    loader = {
      # Using grub as bootloader
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
      };

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    # Modifications for a completely silent boot
    initrd.verbose = false;
    consoleLogLevel = 0;
    kernelParams = [ "quiet" "udev.log_level=3" ];
    plymouth.enable = true;
  };

  # Enabling SOUND
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true; # a professional sound server daemon
    wireplumber.enable = true; # session and policy manager for PipeWire
  };

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalization properties.
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  # Plasma 6 as the DE, for the time being it is only available in NixOS Unstable
  # services.desktopManager.plasma6.enable = true;

  # GTK appmenu dependency
  # chaotic.appmenu-gtk3-module.enable = true; # This is giving a strange error at the moment when building

  # Enabling Xorg even though I use Wayland because some Xorg apps had troubles with XWayland support (Not sure about that)
  services.xserver.enable = true;
  programs.xwayland.enable = true;

  # Plasma Wayland as default
  services.displayManager.defaultSession = "plasma";

  # Enabling dconf as a dependency of Firefox for it to being ablo of getting magnets' mime type and launch Deluge as a torrent client properly
  programs.dconf.enable = true;

  # Setting sddm as the display manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

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

  # Enabling Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Setting ZSH as the default shell for all users
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    libsForQt5.kservice # kbuildsycoca5
    kdePackages.sddm-kcm # sddm settings module
    libreoffice-qt-fresh

    distrobox

    # Packages normally included in other distros by default
    lshw 
    wget
    git
    gh
    fastfetch

    qdirstat # App for managing disk space usage

    kdePackages.appstream-qt # libsForQt5 is replaced by kdePackages to keep coherence for Plasma 6 naming

    # peazip # Free Zip / Unzip software and Rar file extractor. Cross-platform file and archive manager.
    lutris

    direnv # program recommended for nix

    # Ark Extraction dependencies
    libarchive
    libzip
    p7zip
    unrar
    zlib
    unzip

    # System Settings info panel dependencies
    wayland-utils
    vulkan-tools
    glxinfo
    virtualgl
    clinfo

    # Firefox dependencies
    ffmpeg-full # ffmpeg 6, ffmpeg 7 full is temporalily
    mailcap # Helper application and MIME type associations for file types
  ];

  environment.variables = {
    # Force GTK apps to use QT Portal for opening folders or files (same as gtkUsePortal = true; but that's deprecated)
    GTK_USE_PORTAL = "1";
  };

  # Enabling flatpak support, still have to run:
  # flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  # For adding flathub to flatpak
  # TODO there's a project https://github.com/gmodena/nix-flatpak that helps with making flatpak management declaratively I'll look into that
  services.flatpak.enable = true;

  # Register AppImages as binary types
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enabling Docker virtualization
  virtualisation.docker.enable = true;

  # Setting up fonts
  fonts = {
    packages = with pkgs; [
      ibm-plex # GUI font
      meslo-lgs-nf # Konsole font
    ];

    fontconfig.defaultFonts = {
      serif = [ "IBM Plex Sans" ];
      sansSerif = [ "IBM Plex Sans" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  programs = {
      partition-manager.enable = true; # KDE Partition Manager

      # Setting up oh-my-zsh
      zsh = {
        enable = true;
        enableBashCompletion = true;
        enableCompletion = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;

        # Setting PowerLevel10k as the zsh theme
        promptInit = "source ''${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

        ohMyZsh = {
          enable = true;
          plugins = [
            "sudo"
            "git"
          ];
        };
      };
    };

  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;

  # Aliases
  environment.shellAliases = {
    ll = "ls -l";
    ls = "ls --color=tty";
    nix-find = "nix --extra-experimental-features \"nix-command flakes\" search nixpkgs";
    neofetch = "fastfetch";
    config-nixos = "codium /home/nolan/.dotfiles";

    # switch-nixos rebuilds NixOS using system-wide configuration, then rebuilds home using home.nix and finally it refreshes KDE app cache (icons in app launcher)
    switch-nixos = "sudo nixos-rebuild switch --flake /home/nolan/.dotfiles && home-manager switch -b backup --flake /home/nolan/.dotfiles && kbuildsycoca6";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nolan.isNormalUser = true;
  users.users.nolan.extraGroups = [ "networkmanager" "wheel" "docker" ];
  nix.settings.trusted-users = [ "root" "nolan" ];
}
