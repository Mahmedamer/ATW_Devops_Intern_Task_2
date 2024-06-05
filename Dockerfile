# Use the official PHP image with Apache
FROM php:8.1-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd mysqli pdo pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy the existing application directory contents
COPY . .

# Copy existing application directory permissions
COPY --chown=www-data:www-data . .

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Config Apache server
COPY ./laravel.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite

RUN /etc/init.d/apache2 restart

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Add user for laravel application
RUN useradd -u 1000 -ms /bin/bash -g www-data www

USER www

# Install application dependencies
RUN composer install

# Change user to root
USER root

RUN php artisan key:generate
# Expose port 80
EXPOSE 80
