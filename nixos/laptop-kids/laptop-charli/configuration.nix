# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./../main-configuration.nix
    ];

  networking.hostName = "laptop-charli"; # Define your hostname.

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.charli = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  environment.systemPackages = with pkgs; [
    # User Specific Packages
  ];
}

