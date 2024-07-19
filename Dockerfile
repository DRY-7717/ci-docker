# Use the official PHP image as a base image
FROM php:8.1-apache

# Set working directory
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    libicu-dev \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install intl zip pdo_mysql

# Enable Apache modules
RUN a2enmod rewrite

# Copy your CodeIgniter project files to the working directory
COPY . .

# Set file permissions securely
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 775 /var/www/html/writable \
    && chmod -R 775 /var/www/html/writable/cache

# Copy Apache virtual host configuration
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# Expose port 80 (default HTTP port)
EXPOSE 80

# Start Apache in foreground
CMD ["apache2-foreground"]
