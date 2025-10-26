# Multi-stage Dockerfile for Pelican static site
# Stage 1: Build the Pelican site
FROM python:3.13-slim AS builder

# Build arguments
ARG BUILD_ENV=production
ARG SITE_URL=https://www.ryancheley.com

# Set environment variable so Pelican can use it
ENV SITE_URL=${SITE_URL}

# Set working directory
WORKDIR /app

# Install system dependencies including build tools for packages that need compilation
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency files
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY pelicanconf.py publishconf.py ./
COPY tasks.py Makefile ./
COPY content/ ./content/
COPY pelican-clean-blog/ ./pelican-clean-blog/

# Build the site with appropriate settings based on BUILD_ENV
RUN if [ "$BUILD_ENV" = "development" ]; then \
        pelican content -s pelicanconf.py; \
    else \
        pelican content -s publishconf.py; \
    fi

# Stage 2: Serve with nginx
FROM nginx:alpine

# Copy built site from builder stage
COPY --from=builder /app/output /usr/share/nginx/html

# Copy custom nginx configuration for drafts directory listing
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 for Coolify
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
