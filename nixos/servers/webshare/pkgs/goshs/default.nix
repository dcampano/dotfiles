{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "goshs";
  version = "0.1.8";
  src = pkgs.fetchzip {
    url = "https://github.com/patrickhener/goshs/releases/download/v${version}/goshs_${version}_Linux_x86_64.tar.gz";
    sha256 = "00d9gvvrfhrwsic5yixld7wkl1b2dg3ccyyjkgxynvs0s19w8w5g";
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
