FROM php:7.4-apache

# Enable mysqli extension
RUN docker-php-ext-install mysqli

# Copy app files to Apache root
COPY . /var/www/html/
