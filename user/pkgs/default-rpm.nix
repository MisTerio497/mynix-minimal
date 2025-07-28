{ stdenv, rpm, fetchurl, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "my-rpm-package";
  version = "1.0";

  src = fetchurl {
    url = "https://example.com/package.rpm";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };

  nativeBuildInputs = [ rpm autoPatchelfHook ];

  unpackPhase = ''
    rpm2cpio $src | cpio -idmv
  '';

  installPhase = ''
    mkdir -p $out
    cp -r ./usr/* $out/
  '';

  postFixup = ''
    # Исправление библиотечных путей
    autoPatchelf $out/bin/program_name
  '';
}