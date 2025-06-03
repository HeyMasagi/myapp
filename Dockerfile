FROM php:8.2-fpm

# Sistem paketlerini güncelleme ve gerekli paketleri kurma
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev

# PHP eklentilerini kurma
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Redis extension kurulumu
RUN pecl install redis && docker-php-ext-enable redis

# Composer kurulumu
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Çalışma dizinini belirleme
WORKDIR /var/www

# Önce root olarak çalışacağız, izinleri ayarladıktan sonra www-data'ya geçeceğiz
USER root

# İzinlerin container başlatıldığında ayarlanacağı bir başlatma scripti oluşturma
COPY docker/scripts/start.sh /usr/local/bin/start-container
RUN chmod +x /usr/local/bin/start-container

# PHP-FPM'i başlatma
CMD ["/usr/local/bin/start-container"]

EXPOSE 9000
