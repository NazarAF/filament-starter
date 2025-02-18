# Use PHP 8.2 CLI image
FROM php:8.2-cli

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev zip git curl \
    libmariadb-dev-compat libicu-dev pkg-config libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql intl zip \
    && apt-get clean

# Install Node.js (>=18) and NPM from NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Verify Node.js and NPM versions
RUN node -v && npm -v

# Install Composer for managing PHP dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Yarn globally
RUN npm install -g yarn

# Set the working directory inside the container
WORKDIR /var/www/html

# Copy the Laravel application files into the container
COPY . /var/www/html

# Install Laravel dependencies with Composer
RUN composer install --no-interaction --prefer-dist

# Install front-end dependencies and build assets
RUN yarn install && yarn build

# Expose port 8083 for the Laravel server
EXPOSE 8083

# Start the Laravel server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8083"]
