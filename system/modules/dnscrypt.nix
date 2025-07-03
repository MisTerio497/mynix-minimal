{
  services.dnscrypt-proxy = {
    enable = true;
    settings = {
      # Используем Cloudflare DNS
      server_names = [ "cloudflare" ];  
      
      # Слушаем на localhost (127.0.0.1)
      listen_addresses = [ "127.0.0.1:53" ];
      
      # Разрешить только TCP (опционально)
      force_tcp = false;
      
      # Включить кэширование
      cache = true;
      
      # Блокировка рекламы и трекеров (опционально)
      blocked_query_response = "refused";
      blocked_ip_response = "refused";
      
      # Использовать DNSSEC
      dnscrypt_ephemeral_keys = true;
      dnssec_validation = true;
    };
  };
}