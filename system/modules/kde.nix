{ pkgs, ...}:
{
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "ivan";
  
  environment.systemPackages = with pkgs; [ 
    kdePackages.breeze-gtk
    kdePackages.breeze
  ];
}