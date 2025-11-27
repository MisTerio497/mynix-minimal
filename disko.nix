# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount disko.nix
{
  disko.devices = {
    disk = {
      nvme = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            windows = {
              size = "300G";
            };
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
            # LVM Physical Volume (Remaining space)
            lvm = {
              size = "100%";
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
# disko.nix
# { lib, pkgs, ... }:

# {
#   disk = {
#     main = {
#       type = "disk";
#       device = "/dev/sda"; # или /dev/nvme0n1 для NVMe
#       content = {
#         type = "gpt";
#         partitions = {
#           boot = {
            #   size = "500M";
            #   type = "EF00";
            #   content = {
            #     type = "filesystem";
            #     format = "vfat";
            #     #mountpoint = "/boot/efi";
            #     mountpoint = "/boot";
            #     mountOptions = [
            #       "fmask=0077"
            #       "dmask=0077"
            #     ];
            #   };
            # };
#           main = {
#             name = "main";
#             size = "100%";
#             content = {
#               type = "btrfs";
#               extraArgs = [ "-f" ];
#               # Опции файловой системы
#               extraFormatArgs = [
#                 "--label=main"
#               ];
#               # Монтирование с опциями
#               mountOptions = [
#                 "defaults"
#                 "noatime"
#                 "compress=zstd"
#                 "ssd" # если SSD диск
#                 "autodefrag"
#               ];
              
#               subvolumes = {
#                 # Корневой subvolume (не монтируется напрямую)
#                 "@" = {
#                   mountpoint = null; # не монтировать
#                 };
                
#                 # Root subvolume
#                 "@root" = {
#                   mountpoint = "/";
#                   mountOptions = [
#                     "subvol=@root"
#                     "noatime"
#                     "compress=zstd"
#                     "ssd"
#                   ];
#                 };
                
#                 # Home subvolume
#                 "@home" = {
#                   mountpoint = "/home";
#                   mountOptions = [
#                     "subvol=@home"
#                     "noatime"
#                     "compress=zstd"
#                     "ssd"
#                   ];
#                 };
                
#                 # Nix store subvolume
#                 "@nix" = {
#                   mountpoint = "/nix";
#                   mountOptions = [
#                     "subvol=@nix"
#                     "noatime"
#                     "compress=zstd"
#                     "ssd"
#                     "noautodefrag" # отключить дефрагментацию для nix store
#                   ];
#                 };
                
#                 # Logs subvolume
#                 "@var_log" = {
#                   mountpoint = "/var/log";
#                   mountOptions = [
#                     "subvol=@var_log"
#                     "noatime"
#                     "compress=zstd"
#                   ];
#                 };
                
#                 # Cache subvolume
#                 "@var_cache" = {
#                   mountpoint = "/var/cache";
#                   mountOptions = [
#                     "subvol=@var_cache"
#                     "noatime"
#                     "compress=zstd"
#                   ];
#                 };
                
#                 # Temporary files
#                 "@tmp" = {
#                   mountpoint = "/tmp";
#                   mountOptions = [
#                     "subvol=@tmp"
#                     "noatime"
#                     "nodatacow"
#                     "nodatasum"
#                   ];
#                 };
#               };
#             };
#           };
#         };
#       };
#     };
#   };
# }
