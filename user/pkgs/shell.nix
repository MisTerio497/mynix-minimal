{ pkgs ? import <nixpkgs> {} }:
let
  tgui = pkgs.callPackage ./tgui.nix {};
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    cmake
    ninja
    sfml_2
    gcc
    udev
    tgui
    freetype
    xorg.libX11
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXcursor
    xorg.libXinerama
    libGL
    openal
    flac
    libogg
    libvorbis
  ];

  shellHook = ''
    export SFML_DIR="${pkgs.sfml_2}/lib/cmake/SFML"
    export CMAKE_PREFIX_PATH="
      ${pkgs.udev};
      ${pkgs.xorg.libX11};
      ${pkgs.xorg.libXext};
      ${pkgs.xorg.libXfixes};
      ${pkgs.xorg.libXi};
      ${pkgs.xorg.libXrandr};
      ${pkgs.xorg.libXcursor};
      ${pkgs.libGL}
    "
  '';
}