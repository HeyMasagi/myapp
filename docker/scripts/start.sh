#!/bin/bash

# Storage ve bootstrap/cache dizinlerindeki izinleri ayarlama
if [ -d "/var/www/storage" ]; then
  chmod -R 775 /var/www/storage
  chown -R www-data:www-data /var/www/storage
fi

if [ -d "/var/www/bootstrap/cache" ]; then
  chmod -R 775 /var/www/bootstrap/cache
  chown -R www-data:www-data /var/www/bootstrap/cache
fi

# PHP-FPM'i başlatma
php-fpm

# Laravel veritabanı tablolarını oluştur
cd /var/www/html
php artisan migrate --force

# Migration başarısız olursa tekrar dene (veritabanı başlangıçta hazır olmayabilir)
if [ $? -ne 0 ]; then
    echo "Veritabanı bağlantısı bekliyor, 10 saniye sonra tekrar denenecek..."
    sleep 10
    php artisan migrate --force
fi

# Test verilerini ekle (isteğe bağlı)
# php artisan db:seed

# Diğer uygulamanıza özgü başlangıç komutları...

# Apache'yi başlat (veya nginx kullanıyorsanız)
apache2-foreground 