FROM php:8.3-fpm

# ------------------------------------------------------------
# 1. Install system and PHP dependencies
# ------------------------------------------------------------
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd sockets \
    && pecl install redis \
    && docker-php-ext-enable redis

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
# 6. Auto setup + start PHP-FPM safely
# ------------------------------------------------------------
CMD bash -c "\
if [ ! -f /var/www/.env ]; then \
  echo 'Creating .env from .env.example...'; \
  cp .env.example .env; \
  php artisan key:generate; \
fi && \
composer install --no-interaction --optimize-autoloader && \
php-fpm"
