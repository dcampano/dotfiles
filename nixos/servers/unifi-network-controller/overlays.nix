self: super:
let
  unifiVersion = "7.4.162";
  unifiHash = "069652f793498124468c985537a569f3fe1d8dd404be3fb69df6b2d18b153c4c";
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
