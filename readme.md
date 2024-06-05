# Visitor Count App

Brief description of your project.

## Prerequisites

Before you begin, ensure you have met the following requirements:

* You have installed the latest version of Docker and Docker Compose.

## Running the Project with Docker Compose

To run this project, follow these steps:

1. Open your terminal.
2. Navigate to the project directory.
3. Run the following command to start the Docker Compose setup:

```bash
docker-compose up --build -d
```

4. if it is the first time running the app, you have to execute the `php artisan migrate` command.
   
```bash
docker container exec laravel_app php artisan migrate 
```

## Containerization Process
1. First step was the Dockerfiles for the mysql databse which was based on the `FROM mysql:8.0` image, it didn't require any other steps to set up.
2. Second step was the Dockerfile for the laravel app which was based on the `php:8.1-apache` image
3. The steps for the laravel app were as follows:
   1. Install system dependencies
   ```
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
   ```
   2. Install PHP extensions
   ```
    RUN docker-php-ext-configure gd --with-freetype --with-jpeg
    RUN docker-php-ext-install gd mysqli pdo pdo_mysql
   ```
   3. Enable Apache mod_rewrite
   ```
    RUN a2enmod rewrite
   ```
   4. Set working directory
   ```
    WORKDIR /var/www/html
   ```
   5. Copy the existing application directory contents and permissions
   ```
    COPY . .
    COPY --chown=www-data:www-data . .
    RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
    RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
   ```
   6. Config Apache server
   ```
    COPY ./laravel.conf /etc/apache2/sites-available/000-default.conf
    RUN a2enmod rewrite
    RUN /etc/init.d/apache2 restart
   ```
   7. Install composer
   ```
    COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
   ```
   8. Add user for laravel application
   ```
    RUN useradd -u 1000 -ms /bin/bash -g www-data www
    USER www
   ```
   9.  Install application dependencies
   ```
    RUN composer install
   ```
   10. Change user to root and Expose port 80
   ```
   USER root
   RUN php artisan key:generate
   EXPOSE 80
   ```
4.  Finally, The Compose File that links both the database and the laravel app together, sets a volume to keep the my sql data and containes the network needed environment variables