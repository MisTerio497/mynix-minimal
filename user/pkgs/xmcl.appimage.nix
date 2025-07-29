
{ lib, stdenv, fetchurl, makeDesktopItem, appimageTools, fuse }:

let
  version = "0.51.2";
  pname = "xmcl";
  src = fetchurl {
    url = "https://github.com/Voxelum/x-minecraft-launcher/releases/download/v${version}/xmcl-${version}-x86_64.AppImage";
    sha256 = "sha256-KpbILfOxeBwEJNrZuRFWamASMRWv1Bzx8yTzmwe3e3g=";
  };
  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
  desktopItem = makeDesktopItem {
      name = pname;
      desktopName = "XMCL";
      comment = "Cross-platform Minecraft Launcher";  
      exec = "${pname}";  
      icon = "${appimageContents}/xmcl.png"; # Путь к иконке в распакованном AppImage
      categories = [ "Game" ];
      terminal = false;
    };
    
in appimageTools.wrapType2 rec {
  inherit pname version src;
  extraPkgs = pkgs: with pkgs; [ fuse ]; # Дополнительные зависимости, если нужны
  # profile = ''
  #   export XMCL_DATA_DIR="$HOME/.local/share/xmcl"
  # '';
  extraInstallCommands = ''
      mkdir -p $out/share/applications
      cp ${desktopItem}/share/applications/* $out/share/applications/
      # Копируем иконку (если она есть в AppImage)

      if [ -f "${appimageContents}/xmcl.png" ]; then
        mkdir -p $out/share/icons/hicolor/256x256/apps
        cp "${appimageContents}/xmcl.png" $out/share/icons/hicolor/256x256/apps/xmcl.png
      fi
    '';
  meta = with lib; {
    description = "Cross-platform Minecraft Launcher (AppImage)";
    homepage = "https://github.com/Voxelum/x-minecraft-launcher";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ yourname ];
  };
}