# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  # Set the postgresql version here so that the backup script and the postgresql service
  # can use the same version
  postgresqlVersionToUse = pkgs.postgresql_14;

  custom-backup-script = pkgs.writeShellScriptBin "backup-databases.sh" ''
    set -euo pipefail
    
    source /etc/backup-databases.secret
    
    date=$(date '+%Y-%m-%d-%H-%M-%S')
    FILENAME=postgresql-databases-$date.gz

    cd /tmp
    
    ${postgresqlVersionToUse}/bin/pg_dumpall | ${pkgs.gzip}/bin/gzip > $FILENAME
    
    ${pkgs.awscli2}/bin/aws s3api put-object --bucket postgresql-backups-4k3ab2zp --key $FILENAME --body $FILENAME
    
    rm $FILENAME

  '';


in {
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ./../users.nix
    ];

  users.motd = ''
   
    =====================================================
 
    nixos Postgresql Server

    =====================================================
    
  '';

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;

  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  boot.growPartition = true;

  networking.hostName = "nixos-postgresql"; # Define your hostname.

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

  security.sudo.wheelNeedsPassword = false;
  # Define a user account. Don't forget to set a password with ‘passwd’.

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    awscli2
    custom-backup-script # This is defined in the let up top
  ];

  services.postgresql = {
    enable = true;
    package = postgresqlVersionToUse;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
      host  all       all   0.0.0.0/0  md5
    '';
  };

  systemd.services.backup-databases = {
    serviceConfig = {
      Type = "oneshot";
      User = "postgres";
      PrivateTmp = "true";
    };
    path = [
      custom-backup-script
    ];
    script = "backup-databases.sh";

  };

  systemd.timers.backup-databases = {
    wantedBy = [ "timers.target" ];
    partOf = [ "backup-databases.service" ];
    timerConfig = {
      OnCalendar = "*-*-* 04:05:00";
      Unit = "backup-databases.service";
    };
  };

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
  services.openssh.settings.PermitRootLogin = "yes";

  # Auto-upgrade packages
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };

  # Disable the firewall
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

