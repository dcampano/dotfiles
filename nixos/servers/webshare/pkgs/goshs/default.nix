{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "goshs";
  version = "0.1.8";
  src = pkgs.fetchurl {
    url = "https://github.com/patrickhener/goshs/releases/download/v${version}/goshs_${version}_Linux_x86_64.tar.gz";
    sha256 = "0lggrhqna1n39sqfsmny433cd195bc5mfax0xgksgicksxbqv9dm";
  };
  phases = [ "installPhase" ];
  # probably a better way to extract this stuff that I can research
  # but this works for now
  installPhase = ''
    mkdir -p $out/bin
    cd $out/bin
    tar --extract --file=$src goshs
    chmod +x goshs
  '';
}
