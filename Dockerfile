# Use PHP 8.2 CLI image
FROM php:8.2-cli

# Install necessary system dependencies and libzip
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev zip git \
    libmariadb-dev-compat libicu-dev pkg-config libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql intl zip \
    && apt-get clean

# Install Composer for managing PHP dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory inside the container
WORKDIR /var/www/html

# Copy the Laravel application files into the container
COPY . /var/www/html

# Install Laravel dependencies with Composer
RUN composer install --no-interaction --prefer-dist

# Run migrations and seed the database
RUN php artisan migrate:fresh --seed

# Expose port 8000 for the Laravel server
EXPOSE 8083

# Run the Laravel server with php artisan serve
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8083"]
