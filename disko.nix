# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount disko.nix
{ lib, disks ? [ "/dev/nvme0n1" ], ... }:
{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = builtins.elemAt disks 0;  # Берём первый элемент массива
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
