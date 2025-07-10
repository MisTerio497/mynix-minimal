{ config, pkgs, inputs,... }:

{
  # Включение Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    
    # Основные настройки
    settings = {
      # Мониторы (адаптируйте под вашу систему)
      monitor = ",preferred,auto,1";
      
      # Автозапуск компонентов
      exec-once = [
        "waybar &"
        "mako &"
        "swayidle -w timeout 300 'swaylock -f'"
        "nm-applet --indicator"
      ];

      # Входные устройства
      input = {
        kb_layout = "us,ru";
        kb_options = "grp:alt_shift_toggle";
        touchpad.natural_scroll = true;
      };

      # Оформление
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(7aa2f7ee)";
      };

      # Анимации
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 5, myBezier"
          "fade, 1, 5, default"
        ];
      };

      # Клавиши
      bind = [
        # Основные
        "SUPER, Return, exec, kitty"
        "SUPER, Q, killactive,"
        "SUPER, M, exit,"
        "SUPER, V, togglefloating,"
        
        # Переключение рабочих столов
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
      ];
    };
  };

  # Дополнительные пакеты
  home.packages = with pkgs; [
    kitty       # Терминал
    waybar      # Панель
    mako        # Уведомления
    swaylock    # Блокировка экрана
    swayidle    # Автоблокировка
    wofi        # Меню запуска
    grim        # Скриншоты
    slurp       # Выбор области для скриншотов
  ];

  # Настройка Wayland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Переменные окружения
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";  # Для Wayland-приложений
    QT_QPA_PLATFORM = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };
}