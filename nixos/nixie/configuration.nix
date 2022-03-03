# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  services.xserver.videoDrivers = [ "nvidia" ]; 

  nix = {
    package = pkgs.nixFlakes; # or versioned attributes like nix_2_4

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernel.sysctl = {
    "vm.swappiness" = 30;
  };

  networking.hostName = "nixie"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.xkbOptions = "caps:super";

  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw 

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
    ];
  };


  users.users.dcampano = {
    isNormalUser = true;
    home = "/home/dcampano";
    description = "dcampano";
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "docker" ];
    


  };
  
  programs.dconf.enable = true;

  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget

  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

    # begin - used for i3/i3blocks
    sysstat
    feh
    flameshot
    font-awesome
    yad
    bc
    libqrencode
    xclip
    pasystray
    gnome.networkmanagerapplet
    # installs python3 along with the i3ipc package
    # needed for the 'autotiling' extension in
    # .config/i3/autotiling folder
    (python39.withPackages(ps: with ps; [ i3ipc ]))
    # end - used for i3/i3blocks

    direnv
    ack
    i3
    # hledger
    remmina
    wget
    firefox
    chromium
    virt-manager
    flatpak
    wireguard
    jetbrains.datagrip
    nix-diff
    gnomeExtensions.dash-to-dock
    vlc
    libreoffice
    vscode
    libheif
    gpicview
    gdk-pixbuf
    gthumb # To view HEIF/HEIC Files
    nvd
    git
  ];


  # Enable apc ups
  services.apcupsd.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  #
  # File Systems To Mount
  fileSystems."/mnt/diskstation/photo" = {
    device = "192.168.20.50:/volume3/photo";
    fsType = "nfs";
  };

  fileSystems."/mnt/diskstation/video" = {
    device = "192.168.20.50:/volume3/video";
    fsType = "nfs";
  };

  fileSystems."/mnt/diskstation/linux-backups" = {
    device = "192.168.20.50:/volume3/linux-backups";
    fsType = "nfs";
  };

  fileSystems."/mnt/backups" = {
    device = "/dev/disk/by-uuid/d2fa1d6b-ae44-4105-83ac-fb7c8e35f4ab";
    fsType = "ext4";
  };

  # List services that you want to enable:
  #
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Auto-upgrade packages
  system.autoUpgrade = {
    enable = true;
    flags = [ "-I" "nixos-config=/home/dcampano/.dotfiles/nixos/nixie/configuration.nix" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

