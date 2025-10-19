FROM php:8.3-fpm

# ------------------------------------------------------------
# 1. Install system and PHP dependencies
# ------------------------------------------------------------
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd sockets

# ------------------------------------------------------------
# 2. Install Node.js 20 + npm
# ------------------------------------------------------------
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest

# ------------------------------------------------------------
# 3. Install Composer
# ------------------------------------------------------------
COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

# ------------------------------------------------------------
# 4. Set working directory
# ------------------------------------------------------------
WORKDIR /var/www

# Copy Laravel project (for initial image build)
COPY ./src /var/www

# ------------------------------------------------------------
# 5. Expose PHP-FPM port
# ------------------------------------------------------------
EXPOSE 9000

# ------------------------------------------------------------
# 6. Auto setup + build + start PHP-FPM
# ------------------------------------------------------------
CMD bash -c "\
composer install && \
php artisan key:generate && \
php artisan migrate --force && \
npm install && \
npm run build && \
php-fpm"
