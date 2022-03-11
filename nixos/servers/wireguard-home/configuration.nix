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
    
    Tips to edit Wireguard:

    1) Modify nix configuration at /etc/nixos/configuration.nix
    2) sudo nixos-rebuild switch
    3) Commit the configuration and push to github (/home/dcampano/.dotfiles) 

    =====================================================
    
  '';

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "wireguard-home"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.ens18.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  security.sudo.wheelNeedsPassword = false;
  # Define a user account. Don't forget to set a password with ‘passwd’.

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    wireguard-tools
  #   wget
  #   firefox
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Auto-upgrade packages
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

  networking.nat.enable = true;
  networking.nat.externalInterface = "ens18";
  networking.nat.internalInterfaces = [ "wg0" ];
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [ "192.168.200.10/24" ];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 51820;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 192.168.200.0/24 -o ens18 -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 192.168.200.0/24 -o ens18 -j MASQUERADE
      '';

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/etc/wireguard.key";

      peers = [
        # List of allowed peers.
        { # Davy's Lemur Pro
          publicKey = "TJgDOMtIE/o+3WHdsdwthtA9pzoEw8A3sigCJYb24Ac=";
          allowedIPs = [ "192.168.200.15/32" ];
        }
        { # Davy's iPhone
          publicKey = "HfXDTWqTrH0s8htD3M+vXZ9YU2kxhhv8cEEWoxwKn1c=";
          allowedIPs = [ "192.168.200.16/32" ];
        }
        { # Emily's iPhone
          publicKey = "TfFuR+VR7I0MzwRkxnZLjGnR6qXH5Fd6LJs7MuI+HBI=";
          allowedIPs = [ "192.168.200.17/32" ];
        }
        { # Robby's Macbook
          publicKey = "UqLRK9q/ZaPGK8SDwaHQCAqWidh9lN4cUM4UnLgTY1Y=";
          allowedIPs = [ "192.168.200.50/32" ];
        }
        { # Robby's Windows 10
          publicKey = "aQjqAsh57KaNbhbcBqYzcLXdeQLcby2JnZcKDrThTSg=";
          allowedIPs = [ "192.168.200.51/32" ];
        }
        { # Robby's iPhone
          publicKey = "Di2Xk2D+ruCF6rsDAhHm+Tp/fEy8tOTAoXk0w0BEh2o=";
          allowedIPs = [ "192.168.200.52/32" ];
        }
        { # Joanna's iPhone 13
          publicKey = "3dC3V6r5muqAo+CeT8ZoEwHeqtHLIhW8G4/UfSDDAnQ=";
          allowedIPs = [ "192.168.200.54/32" ];
        }
        { # Kirby's Raspberry Pi
          publicKey = "X0DjlOYb0ssPnSRcy3Nde8Db4uNnsMwWoF7z3yfb5Eg=";
          allowedIPs = [ "192.168.200.60/32" "192.168.30.0/24" ];
        }
        { # Davy's Virtual Machine
          publicKey = "O8fWMOOFpVevyv5ob2DLMqe0U3Oa6fEdQJEBYkGU7Go=";
          allowedIPs = [ "192.168.200.61/32" ];
        }
      ];
    };
  };
/*  
Old configuration postup and postdown commands
[Interface]
Address = 192.168.200.10/24
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ens18 -j MASQUERADE; ip6tables -A FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -A POSTROUTING -o ens18 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ens18 -j MASQUERADE; ip6tables -D FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -D POSTROUTING -o ens18 -j MASQUERADE

*/

}

