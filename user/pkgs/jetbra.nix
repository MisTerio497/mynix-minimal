{ pkgs, ... }:

let
  url = "https://www.kdaiyu.com/3.jetbra.in/files/jetbra-2024.zip";

  jetbrainsFiles = pkgs.stdenv.mkDerivation {
    name = "jetbrains-vmoptions";

    src = pkgs.fetchurl {
      url = url;
      sha256 = "sha256-0rg8hqvqkq4anj4brh0igshgk940mbd6417ky584y9j3hvp47mfm";
    };

    buildInputs = [ pkgs.unzip ];

    buildCommand = ''
      mkdir -p $out
      unzip $src -d $out

      # добавляем безопасную строку
      for f in $out/vmoptions/*.vmoptions; do
        echo "-javaagent:$out/ja-netfilter.jar=jetbrains" >> "$f"
      done
    '';
  };

in
{
  home.sessionVariables = {
    IDEA_VM_OPTIONS = "${jetbrainsFiles}/vmoptions/idea.vmoptions";
    CLION_VM_OPTIONS = "${jetbrainsFiles}/vmoptions/clion.vmoptions";
    PHPSTORM_VM_OPTIONS = "${jetbrainsFiles}/vmoptions/phpstorm.vmoptions";
    GOLAND_VM_OPTIONS = "${jetbrainsFiles}/vmoptions/goland.vmoptions";
    PYCHARM_VM_OPTIONS = "${jetbrainsFiles}/vmoptions/pycharm.vmoptions";
    WEBSTORM_VM_OPTIONS = "${jetbrainsFiles}/vmoptions/webstorm.vmoptions";
    WEBIDE_VM_OPTIONS = "${jetbrainsFiles}/vmoptions/webide.vmoptions";
    RIDER_VM_OPTIONS = "${jetbrainsFiles}/vmoptions/rider.vmoptions";
    DATAGRIP_VM_OPTIONS = "${jetbrainsFiles}/vmoptions/datagrip.vmoptions";
    RUBYMINE_VM_OPTIONS = "${jetbrainsFiles}/vmoptions/rubymine.vmoptions";
    DATASPELL_VM_OPTIONS = "${jetbrainsFiles}/vmoptions/dataspell.vmoptions";
    AQUA_VM_OPTIONS = "${jetbrainsFiles}/vmoptions/aqua.vmoptions";
    RUSTROVER_VM_OPTIONS = "${jetbrainsFiles}/vmoptions/rustrover.vmoptions";
    GATEWAY_VM_OPTIONS = "${jetbrainsFiles}/vmoptions/gateway.vmoptions";
    JETBRAINS_CLIENT_VM_OPTIONS = "${jetbrainsFiles}/vmoptions/jetbrains_client.vmoptions";
    JETBRAINSCLIENT_VM_OPTIONS = "${jetbrainsFiles}/vmoptions/jetbrainsclient.vmoptions";
    STUDIO_VM_OPTIONS = "${jetbrainsFiles}/vmoptions/studio.vmoptions";
    DEVECOSTUDIO_VM_OPTIONS = "${jetbrainsFiles}/vmoptions/devecostudio.vmoptions";
  };
}
