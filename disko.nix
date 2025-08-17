# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount disko.nix
{
  lib,
  disks ? [ "/dev/nvme0n1" ],
  ...
}:
{
  disko.devices = {
    disk = {
      nvme = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            # EFI Partition (500MB)
            boot = {
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                #mountpoint = "/boot/efi";
                mountpoint = "/boot";
                mountOptions = [
                  "fmask=0077"
                  "dmask=0077"
                ];
              };
            };

            # windows = {
            #   size = "300G";
            #   type = "0700"; # NTFS
            #   content = {
            #     type = "raw"; # Windows сама отформатирует в NTFS
            #   };
            # };

            # LVM Physical Volume (Remaining space)
            lvm = {
              size = "100FREE%";
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };
    };

    lvm_vg = {
      "pool" = {
        type = "lvm_vg";
        lvs = {
          # delete games in future
          games = {
            size = "200G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home/ivan/Games";
            };
          };
          root = {
            size = "100%FREE";
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
