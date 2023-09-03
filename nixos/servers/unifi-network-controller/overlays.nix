self: super:
let
  unifiVersion = "7.4.156";
  unifiHash = "sha256-UJjzSC2qKi2ABwH5p0s/5fXfB3NVfYBb3wBfE/8NlK4=";
in
{
  unifiCustom = super.unifi.overrideAttrs (attrs: {
    name = "unifi-controller-${unifiVersion}";
    src = self.fetchurl {
      url = "https://dl.ubnt.com/unifi/${unifiVersion}/unifi_sysvinit_all.deb";
      sha256 = unifiHash;
    };
  });
}
