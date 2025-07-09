#!/usr/bin/env bash

set -euo pipefail

# Цвета
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
BLUE="\e[34m"
RESET="\e[0m"

# Тестовый порт
TEST_PORT=54321
PROTOCOL="TCP"
TIMEOUT=5

# Проверка зависимостей
check_deps() {
  local missing=()
  for cmd in curl ip systemctl; do
    if ! command -v "$cmd" &> /dev/null; then
      missing+=("$cmd")
    fi
  done
  
  if [[ ${#missing[@]} -gt 0 ]]; then
    echo -e "${RED}❌ Отсутствуют необходимые команды: ${missing[*]}${RESET}"
    exit 1
  fi
}

# Проверка miniupnpd
check_upnp_service() {
  echo -e "🧪 ${BLUE}Проверка miniupnpd...${RESET}"
  if systemctl is-active --quiet miniupnpd; then
    echo -e "${GREEN}✅ miniupnpd работает${RESET}"
  else
    echo -e "${RED}❌ miniupnpd не запущен${RESET}"
    echo -e "Попробуйте: ${YELLOW}sudo systemctl start miniupnpd${RESET}"
    exit 1
  fi
}

# Проверка IGD
check_igd() {
  echo -e "\n🌐 ${BLUE}Проверка IGD (UPnP роутера)...${RESET}"
  if ! command -v upnpc &> /dev/null; then
    echo -e "${YELLOW}ℹ️ Установка miniupnpc через nix-shell...${RESET}"
    nix-shell -p miniupnpc --run "upnpc -l"
  else
    timeout "$TIMEOUT" upnpc -l || {
      echo -e "${RED}❌ Не удалось получить данные от роутера${RESET}"
      echo -e "Проверьте:"
      echo -e "1. UPnP включен в настройках роутера"
      echo -e "2. Брандмауэр разрешает порт 1900/UDP"
      exit 1
    }
  fi
}

# Получение IP-адресов
get_ips() {
  echo -e "\n📡 ${BLUE}Получение IP-адресов...${RESET}"
  LOCAL_IP=$(ip route get 1.1.1.1 | awk '{for(i=1;i<=NF;i++) if($i=="src") print $(i+1)}')
  PUBLIC_IP=$(timeout "$TIMEOUT" curl -s https://api.ipify.org || echo "unknown")
  
  echo -e "🖥️ Локальный IP: ${GREEN}$LOCAL_IP${RESET}"
  echo -e "🌍 Внешний IP:   ${GREEN}$PUBLIC_IP${RESET}"
}

# Проверка NAT
check_nat() {
  echo -e "\n🔍 ${BLUE}Проверка NAT...${RESET}"
  if [[ "$LOCAL_IP" == "$PUBLIC_IP" ]]; then
    echo -e "${GREEN}🌐 Прямое подключение (NAT: OPEN)${RESET}"
    NAT_STATUS="OPEN"
  else
    echo -e "${YELLOW}🔒 Обнаружен NAT, проверяем проброс портов...${RESET}"
    
    echo -e "⏳ Пробрасываем порт $TEST_PORT → $TEST_PORT ($PROTOCOL)"
    if timeout "$TIMEOUT" upnpc -a "$LOCAL_IP" "$TEST_PORT" "$TEST_PORT" "$PROTOCOL" 2>&1 | grep -q "is redirected to"; then
      echo -e "${GREEN}✅ Проброс порта успешен! (NAT: OPEN)${RESET}"
      NAT_STATUS="OPEN"
    else
      echo -e "${YELLOW}⚠️ Не удалось пробросить порт (NAT: MODERATE)${RESET}"
      NAT_STATUS="MODERATE"
    fi
  fi
}

# Очистка
cleanup() {
  echo -e "\n🧹 ${BLUE}Очистка...${RESET}"
  if [[ "$NAT_STATUS" == "OPEN" ]]; then
    timeout "$TIMEOUT" upnpc -d "$TEST_PORT" "$PROTOCOL" &> /dev/null && \
    echo -e "${GREEN}✅ Порт $TEST_PORT закрыт${RESET}" || \
    echo -e "${YELLOW}⚠️ Не удалось закрыть порт $TEST_PORT${RESET}"
  fi
}

# Главная функция
main() {
  check_deps
  check_upnp_service
  check_igd
  get_ips
  check_nat
  cleanup
  
  echo -e "\n${BLUE}=== Результат проверки ===${RESET}"
  case "$NAT_STATUS" in
    "OPEN") echo -e "${GREEN}✅ NAT: OPEN — оптимальная конфигурация${RESET}" ;;
    "MODERATE") echo -e "${YELLOW}⚠️ NAT: MODERATE — возможны проблемы с P2P${RESET}" ;;
    *) echo -e "${RED}❌ Не удалось определить NAT-статус${RESET}" ;;
  esac
}

main