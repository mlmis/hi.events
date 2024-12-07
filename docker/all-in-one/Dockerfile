# Use a Node.js image for the frontend build
FROM node:18 AS frontend-builder

WORKDIR /app

# Copy frontend dependencies and build files
COPY package*.json ./
COPY frontend/package*.json ./frontend/
RUN npm install
COPY frontend/ ./frontend/
RUN npm run build

# Use PHP image for the backend
FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo pdo_pgsql zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configure Apache
RUN a2enmod rewrite
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# Set working directory
WORKDIR /var/www/html

# Copy backend files
COPY . .
COPY --from=frontend-builder /app/dist ./public

# Install PHP dependencies
RUN composer install --no-interaction --no-dev --optimize-autoloader

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage

# Set environment variables
ENV VITE_FRONTEND_URL=${VITE_FRONTEND_URL} \
    VITE_API_URL_CLIENT=${VITE_API_URL_CLIENT} \
    VITE_API_URL_SERVER=${VITE_API_URL_SERVER} \
    VITE_STRIPE_PUBLISHABLE_KEY=${VITE_STRIPE_PUBLISHABLE_KEY} \
    LOG_CHANNEL=${LOG_CHANNEL} \
    QUEUE_CONNECTION=${QUEUE_CONNECTION} \
    MAIL_MAILER=${MAIL_MAILER} \
    APP_KEY=${APP_KEY} \
    JWT_SECRET=${JWT_SECRET} \
    FILESYSTEM_PUBLIC_DISK=${FILESYSTEM_PUBLIC_DISK} \
    FILESYSTEM_PRIVATE_DISK=${FILESYSTEM_PRIVATE_DISK} \
    APP_CDN_URL=${APP_CDN_URL} \
    DATABASE_URL=postgresql://postgres:secret@postgres:5432/hi-events

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]