# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./../users.nix
    ];

  users.motd = ''
   
    =====================================================
    
    This server runs goshs to share files

    =====================================================
    
  '';

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "webshare"; # Define your hostname.

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.ens18.useDHCP = true;

  security.sudo.wheelNeedsPassword = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    wget
    (callPackage ./pkgs/goshs {})
  ];

  # List services that you want to enable:
  systemd.services.goshs = let goshs = pkgs.callPackage ./pkgs/goshs {};
  in 
  {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "Start the goshs service";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${goshs}/bin/goshs -p 80 -w -wp 81 -d /srv'';
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  # Auto-upgrade packages
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };

  networking.firewall = {
    allowedTCPPorts = [ 80 81 ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

