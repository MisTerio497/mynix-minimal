{ stdenv, dpkg, fetchurl }:

stdenv.mkDerivation rec {
  pname = "package-name";
  version = "1.0";

  src = fetchurl {
    url = "https://example.com/package.deb";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };

  nativeBuildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    mkdir -p $out
    cp -r ./usr/* $out/
  '';
}