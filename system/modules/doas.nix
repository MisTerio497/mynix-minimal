{
  security.sudo.enable = false;  # Отключаем sudo
  security.doas = {
    enable = true;
    extraRules = [{
      users = ["ivan"];  # Или groups = ["wheel"];
      keepEnv = true;  # Сохраняет переменные окружения (важно для NixOS)
      persist = true;  # Запоминает аутентификацию на время сессии
    }];
  };
}