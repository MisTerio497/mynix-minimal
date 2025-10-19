{pkgs, ...}
{
systemd.user.services.home-clean = {
  Unit = {
    Description = "Clean old Home Manager generations";
  };
  Service = {
    Type = "oneshot";
    ExecStart = ''
      ${pkgs.bash}/bin/bash -c '${pkgs.home-manager}/bin/home-manager expire-generations "-7 days" '
    '';
  };
};

systemd.user.timers.home-clean = {
  Unit = {
    Description = "Run weekly Home Manager cleanup";
  };
  Timer = {
    OnCalendar = "weekly";
    Persistent = true;
  };
  Install = {
    WantedBy = [ "timers.target" ];
  };
};

}
