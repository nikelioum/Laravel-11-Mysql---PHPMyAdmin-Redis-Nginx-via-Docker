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

# Copy Laravel project
COPY ./src /var/www

# ------------------------------------------------------------
# 5. Adjust permissions to match host user
# ------------------------------------------------------------
ARG UID=1000
ARG GID=1000
RUN usermod -u ${UID} www-data && groupmod -g ${GID} www-data && \
    chown -R www-data:www-data /var/www

# ------------------------------------------------------------
# 6. Expose PHP-FPM port
# ------------------------------------------------------------
EXPOSE 9000

# ------------------------------------------------------------
# 7. Run Laravel setup and start PHP-FPM
# ------------------------------------------------------------
USER www-data

CMD bash -c "\
if [ ! -f /var/www/.env ]; then \
  echo 'Creating .env from .env.example...'; \
  cp .env.example .env; \
  php artisan key:generate; \
fi && \
composer install --no-interaction --optimize-autoloader && \
php-fpm"
