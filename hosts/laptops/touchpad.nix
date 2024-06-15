{ config, lib, pkgs, ... }:

{
  # Enabling touchpad support
  services.libinput.enable = true;
}