{
  pkgs,
  ...
}:

let
  jetbra = pkgs.stdenv.mkDerivation rec{
  pname = "jetbra";
  version = "2024";

  src = pkgs.fetchurl {
    url = "https://www.kdaiyu.com/3.jetbra.in/files/${pname}-${version}.zip";
    sha256 = "sha256-1dVD7oZDJk9Q8fMEYtqqgKT5oH4RwLyItIrgiTeG6GU=";
  };

  nativeBuildInputs = with pkgs;[ unzip ];

  unpackPhase = ''
    mkdir -p $out
    unzip $src -d $out
  '';

  installPhase = ''
    # patch vmoptions
    for f in $out/${pname}/vmoptions/*.vmoptions; do
      echo "-javaagent:$out/ja-netfilter.jar=jetbrains" >> "$f"
    done
  '';
  };
in 
{
  home.sessionVariables = {
      IDEA_VM_OPTIONS               = "${jetbra}/jetbra/vmoptions/idea.vmoptions";
      CLION_VM_OPTIONS              = "${jetbra}/jetbra/vmoptions/clion.vmoptions";
      PHPSTORM_VM_OPTIONS           = "${jetbra}/jetbra/vmoptions/phpstorm.vmoptions";
      GOLAND_VM_OPTIONS             = "${jetbra}/jetbra/vmoptions/goland.vmoptions";
      PYCHARM_VM_OPTIONS            = "${jetbra}/jetbra/vmoptions/pycharm.vmoptions";
      WEBSTORM_VM_OPTIONS           = "${jetbra}/jetbra/vmoptions/webstorm.vmoptions";
      WEBIDE_VM_OPTIONS             = "${jetbra}/jetbra/vmoptions/webide.vmoptions";
      RIDER_VM_OPTIONS              = "${jetbra}/jetbra/vmoptions/rider.vmoptions";
      DATAGRIP_VM_OPTIONS           = "${jetbra}/jetbra/vmoptions/datagrip.vmoptions";
      RUBYMINE_VM_OPTIONS           = "${jetbra}/jetbra/vmoptions/rubymine.vmoptions";
      DATASPELL_VM_OPTIONS          = "${jetbra}/jetbra/vmoptions/dataspell.vmoptions";
      AQUA_VM_OPTIONS               = "${jetbra}/jetbra/vmoptions/aqua.vmoptions";
      RUSTROVER_VM_OPTIONS          = "${jetbra}/jetbra/vmoptions/rustrover.vmoptions";
      GATEWAY_VM_OPTIONS            = "${jetbra}/jetbra/vmoptions/gateway.vmoptions";
      JETBRAINS_CLIENT_VM_OPTIONS   = "${jetbra}/jetbra/vmoptions/jetbrains_client.vmoptions";
      JETBRAINSCLIENT_VM_OPTIONS    = "${jetbra}/jetbra/vmoptions/jetbrainsclient.vmoptions";
      STUDIO_VM_OPTIONS             = "${jetbra}/jetbra/vmoptions/studio.vmoptions";
      DEVECOSTUDIO_VM_OPTIONS       = "${jetbra}/jetbra/vmoptions/devecostudio.vmoptions";
    };
}
