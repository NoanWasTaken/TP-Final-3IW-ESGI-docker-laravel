FROM php:8.1-fpm



RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev


RUN docker-php-ext-install pdo pdo_mysql


RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs


COPY --from=composer:latest /usr/bin/composer /usr/bin/composer


WORKDIR /var/www


COPY . .

RUN composer install --no-interaction --prefer-dist && \
    npm install && npm run build

RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache


EXPOSE 9000




CMD ["php-fpm"]
