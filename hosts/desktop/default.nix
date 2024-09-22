{ 
  config, 
  lib, 
  pkgs, 
  ... 
}:

# let
#   deepcool-monitor = import ./deepcool.nix { inherit pkgs lib; };
# in
{
  imports =
    [
      ./hardware-configuration.nix
      ../../common/common.nix
      ../../common/plasma.nix
      ./network.nix
      ./gaming.nix
      ./vfio.nix
    ];

  boot.loader.grub.useOSProber = true;

  #DeepCool

  # environment.systemPackages = with pkgs; [
  #   deepcool-monitor
  # ];

  # systemd.services.deepcool-ak-series-digital = {
  #   description = "DeepCool AK Series Digital Cooler Monitor";

  #   serviceConfig.ExecStart = "${pkgs.python3}/bin/python ${deepcool-monitor}/bin/deepcool-ak-series-digital.py";
  #   wantedBy = [ "default.target" ];

  #   restartIfChanged = true;
  #   serviceConfig.Restart = "always";
  # };

  # Fix external speakers from muting on restart and having to disable it from alsamixer
  systemd.services.amixer-auto-mute-disable = {
    description = "Disable Auto-Mute Mode on Sound Card 2";
    after = [ "sound.target" ];  # Ensure it runs after sound is available
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.alsaUtils}/bin/amixer -c 2 set 'Auto-Mute Mode' Disabled";
      Restart = "on-failure";
    };
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older ` NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}

