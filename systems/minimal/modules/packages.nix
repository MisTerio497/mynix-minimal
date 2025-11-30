{
  pkgs,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    pciutils
    efibootmgr
    tree
    package-version-server
    git
    openssl
    curl
    wget
  ];
}
