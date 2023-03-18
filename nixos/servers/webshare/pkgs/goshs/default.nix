{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "goshs";
  version = "0.3.0";
  src = pkgs.fetchzip {
    url = "https://github.com/patrickhener/goshs/releases/download/v${version}/goshs_${version}_Linux_x86_64.tar.gz";
    sha256 = "sha256-WYtV6qGwm1KH2lvzz/QGKFL6FLOKM+1xO9zM9j77+eA=";
    stripRoot = false;
  };
  phases = [ "installPhase" ];
  # probably a better way to extract this stuff that I can research
  # but this works for now
  installPhase = ''
    mkdir -p $out/bin
    cp $src/goshs $out/bin/goshs
    chmod +x $out/bin/goshs
  '';
}
