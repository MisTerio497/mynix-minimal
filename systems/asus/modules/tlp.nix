{
  services.tlp.enable = true;
  services.tlp.settings = {
    # Режим производительности от сети
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    # Режим энергосбережения от батареи
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

    # Лимиты частот - более агрессивные на батарее
    CPU_SCALING_MIN_FREQ_ON_AC = "0";
    CPU_SCALING_MAX_FREQ_ON_AC = "0";
    CPU_SCALING_MIN_FREQ_ON_BAT = "800000";  # минимальная частота в кГц
    CPU_SCALING_MAX_FREQ_ON_BAT = "2000000"; # максимальная частота на батарее

    # Диски - быстрее засыпают на батарее
    DISK_IDLE_SECS_ON_AC = "0";
    DISK_IDLE_SECS_ON_BAT = "5";

    # SATA - энергосбережение на батарее
    SATA_LINKPWR_ON_AC = "max_performance";
    SATA_LINKPWR_ON_BAT = "min_power";

    # PCIe - включаем энергосбережение на батарее
    PCIE_ASPM_ON_AC = "off";
    PCIE_ASPM_ON_BAT = "powersave";

    # USB - разрешаем засыпание на батарее
    USB_AUTOSUSPEND = "1";
    USB_AUTOSUSPEND_DISABLE_ON_SHUTDOWN = "1";

    # Wi-Fi - включаем энергосбережение на батарее
    WIFI_PWR_ON_AC = "off";
    WIFI_PWR_ON_BAT = "off";

    # Дополнительные настройки для батареи
    RUNTIME_PM_ON_AC = "auto";
    RUNTIME_PM_ON_BAT = "auto";
    
    # Ядра процессора - отключаем неиспользуемые на батарее
    CPU_HWP_ON_AC = "performance";
    CPU_HWP_ON_BAT = "balance_power";
    
    # Яркость экрана
    START_CHARGE_THRESH_BAT0 = "75";
    STOP_CHARGE_THRESH_BAT0 = "80";
  };
}