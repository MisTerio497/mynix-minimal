{ lib, stdenv, fetchFromGitHub, cmake, sfml_2, ninja }:

stdenv.mkDerivation rec {
  pname = "tgui";
  version = "1.9.0"; # Укажите нужную версию

  src = fetchFromGitHub {
    owner = "texus";
    repo = "TGUI";
    rev = "v${version}";
    sha256 = "sha256-ytd6IJIJ3nZv7uqweHH2WiTMoXu8Lb2IShySLWUr1tM="; # Замените на реальный хеш
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ sfml_2 ];

  cmakeFlags = [
    "-DTGUI_BACKEND=SFML_GRAPHICS"
    "-DTGUI_BUILD_EXAMPLES=OFF"
    "-DTGUI_BUILD_TESTS=OFF"
    "-DTGUI_BUILD_GUI_BUILDER=OFF"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_FULL_LIBDIR=${placeholder "out"}/lib"
    "-DCMAKE_INSTALL_FULL_INCLUDEDIR=${placeholder "out"}/include"
  ];

  meta = with lib; {
    description = "Modern C++ GUI library for SFML";
    homepage = "https://tgui.eu";
    license = licenses.zlib;
    platforms = platforms.all;
  };
}
