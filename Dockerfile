FROM python:3.14-slim

WORKDIR /app

# Install nginx and build dependencies
RUN apt-get update && apt-get install -y nginx build-essential && rm -rf /var/lib/apt/lists/* && \
    rm /etc/nginx/sites-enabled/default

# Copy dependency files
COPY requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Remove build dependencies to reduce image size
RUN apt-get remove -y build-essential && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

# Copy the rest of the application
COPY . .

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy nginx configuration
COPY nginx.conf /etc/nginx/sites-available/default
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
