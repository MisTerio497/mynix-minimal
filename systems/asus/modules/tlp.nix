{
  services.tlp.enable = true;
  services.tlp.settings = {
    # Фиксируем максимальную производительность
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "schedutil"; # даже на батарее

    # Отключаем лимиты частот (если нужно)
    CPU_SCALING_MIN_FREQ_ON_AC = "0";
    CPU_SCALING_MAX_FREQ_ON_AC = "0";
    CPU_SCALING_MIN_FREQ_ON_BAT = "0";
    CPU_SCALING_MAX_FREQ_ON_BAT = "0";

    # Диски не засыпают
    DISK_IDLE_SECS_ON_AC = "0";
    DISK_IDLE_SECS_ON_BAT = "2";

    # SATA — максимум производительности
    SATA_LINKPWR_ON_AC = "max_performance";
    SATA_LINKPWR_ON_BAT = "med_power_with_dipm";

    # PCIe ASPM — отключаем энергосбережение
    PCIE_ASPM_ON_AC = "off";
    PCIE_ASPM_ON_BAT = "default";

    # USB — не засыпаем
    USB_AUTOSUSPEND = "0";

    # Wi-Fi — энергосбережение выключено
    WIFI_PWR_ON_AC = "off";
    WIFI_PWR_ON_BAT = "off";
  };
}
