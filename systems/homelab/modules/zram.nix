{
  zramSwap = {
    enable = true;
    memoryPercent = 100; # Макс. % RAM для ZRAM (реально займёт меньше)
    algorithm = "zstd"; # Лучший баланс скорости/сжатия
    priority = 100; # Выше, чем у дискового Swap
  };
  # Классический Swap (на SSD/HDD)
  swapDevices = [
    {
      device = "/swapfile";
      size = 4096; # 4 ГБ (или 25% от RAM, если RAM < 16 ГБ)
      priority = 10; # Ниже, чем у ZRAM
    }
  ];

  # # Оптимизация ядра
  # boot.kernel.sysctl = {
  #   "vm.swappiness" = 120; # Чаще использует ZRAM, реже — Swap
  #   "vm.vfs_cache_pressure" = 50; # Меньше агрессии к кешу файловой системы
  # };

  systemd.oomd.enable = true;
}
