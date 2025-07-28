{ pkgs, ... }:
{
  boot.kernelModules = [
    "ip_tables"
    "iptable_nat"
  ];
  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  environment.systemPackages = with pkgs; [
    podman-compose
    virt-manager
    virt-viewer
    win-virtio
    adwaita-icon-theme
  ];
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  programs.dconf.enable = true;

  users.users.ivan.extraGroups = [ "libvirtd" "kvm-amd" "qemu-libvirtd"];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
  systemd.services.libvirtd.postStart = ''
    sleep 1  # Дать libvirtd время на инициализацию
    sudo -u root virsh net-start default || true
    sudo -u root virsh net-autostart default || true
  '';
}
