{ config, pkgs, ... }:

{

  users.users.dcampano = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC49uiq6PNv7h5EYXdwyFDry0hXjCf1F4/yryysxgIqQxRm6BW/V8EDtgS/J01OnygvyBY19IjCbP0SbM03H2FL+L1xPu+c6zfeT8PtXl0eitKpceJiYQjH4l/j3RBrrNL3Fygag53eEljVk0A/GPGgqqMY3fzp6Vmww/dcKLpTIwD2noGaU6Rky+ft6r8xkEU7NnNDuBK3KqGP61qUuWcZl7BVwN3j7vN9fKFqWeiKk6lraJKGblBmMTjKixq+cQSib0XSmO9rn2WW8DWnSKTsnMvbIO/rWYHd/xF3obMbx32tF1nzgnD5YNCVT/dq4XV5gUQ/ZNa1bC5VHOeHOO0kqAfmbv5V5w71Sy/sMrAw1bE37h+SwRm9ZUcy+LAUybwPbJ7IgVAKThH/34BViZRCK65VaU5cKllFxt7ztuYpcnSoO5B0QHDFY+FuuKFxqLo9nD09GT7HXmAhCyJRc+QhrUOtZy44FiLN4YALVH19ITp1NGt0m0ZYKV5TcORIofc= dcampano@dcampano-robs"
    ];
  };

}
