Title: Deploying n8n on Digital Ocean
Date: 2025-10-11
Author: ryan
Tags: how-to
Slug: deploying-n8n-on-digital-ocean
Status: published

This guide shows you how to deploy [n8n](https://n8n.io/), a workflow automation tool, on your own VPS. Self-hosting gives you full control over your data, avoids monthly subscription costs, and lets you run unlimited workflows without usage limits.

I'm using [Digital Ocean](https://m.do.co/c/cc5fdad15654)[ref]Referral Link[/ref] for this guide, but these steps work on any VPS provider. You'll need:

- A VPS with Ubuntu 24.04 (minimum 1GB RAM)
- A domain name with DNS access
- Basic familiarity with SSH and command line tools

## Create and configure the VPS

[Create a droplet](https://docs.digitalocean.com/products/droplets/how-to/create/) with Ubuntu 24.04. Select a plan with at least:

* 1GB RAM
* 25GB Disk
* 1 vCPU

Note the IP address - you'll need it for DNS configuration.

SSH into the server:

```
ssh root@ipaddress
```

Update the system:

```
apt update
apt upgrade -y
```

## Install Docker

[Install Docker](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository) using the official repository:

```
# Add Docker's official GPG key
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker and its components
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## Configure DNS

Create an A record at your domain registrar pointing your subdomain (e.g., `n8n.yourdomain.com`) to your droplet's IP address. If you're using Hover, follow [their DNS management guide](https://support.hover.com/support/solutions/articles/201000064728-managing-dns-records).

## Create Docker Compose configuration

Create a `docker-compose.yml` file on your server. Start with the Caddy service for handling SSL and reverse proxy:

```yaml
services:
  caddy:
    image: caddy:latest
    ports:
      - "80:80"
      - "443:443"
    restart: always
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - caddy_data:/data
      - caddy_config:/config
      - ./logs:/var/log/caddy
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 500M
    healthcheck:
      test: ["CMD", "caddy", "version"]
      interval: 30s
      timeout: 10s
      retries: 3
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
volumes:
  caddy_data:
  caddy_config:

```

Create a `Caddyfile` in the same directory, replacing `n8n.mydomain.com` with your actual domain:

```
n8n.mydomain.com {
    # Enable compression
    encode gzip zstd

    # Reverse proxy to n8n
    reverse_proxy n8n:5678 {
        header_up Host {host}
        header_up X-Real-IP {remote}
        header_up X-Forwarded-For {remote}
        header_up X-Forwarded-Proto {scheme}
        header_up X-Forwarded-Host {host}

        transport http {
            keepalive 30s
            keepalive_idle_conns 10
        }
        flush_interval -1
    }

    # Security headers (relaxed CSP for n8n's dynamic interface)
    header {
        Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
        X-Content-Type-Options "nosniff"
        X-Frame-Options "SAMEORIGIN"
        Referrer-Policy "strict-origin-when-cross-origin"
        Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: blob:; connect-src 'self' wss: ws:; frame-src 'self'; worker-src 'self' blob:;"
        -Server
    }

    # Enable logging
    log {
        output file /var/log/caddy/n8n-access.log {
            roll_size 10MB
            roll_keep 5
        }
        format json
    }

    # Enable TLS with reasonable settings
    tls {
        protocols tls1.2 tls1.3
    }
}
```

## Add n8n to Docker Compose

Add the n8n service under `services:` in your `docker-compose.yml` file. Replace `n8n.mydomain.com` with your domain in the environment variables:

```yaml
  n8n:
    image: n8nio/n8n:latest
    container_name: n8n
    restart: always
    environment:
      - N8N_HOST=n8n.mydomain.com
      - N8N_PORT=5678
      - WEBHOOK_URL=https://n8n.mydomain.com/
      - GENERIC_TIMEZONE=UTC
    ports:
      - "5678:5678"
    volumes:
      - n8n_data:/home/node/.n8n
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 1G
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:5678/healthz"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

Add `n8n_data:` to the `volumes:` section in your `docker-compose.yml` file:

```yaml
volumes:
  caddy_data:
  caddy_config:
  n8n_data: # new line
```

Your final `docker-compose.yml` file will look like this:

```yaml
services:
  caddy:
    image: caddy:latest
    ports:
      - "80:80"
      - "443:443"
    restart: always
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - caddy_data:/data
      - caddy_config:/config
      - ./logs:/var/log/caddy
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 500M
    healthcheck:
      test: ["CMD", "caddy", "version"]
      interval: 30s
      timeout: 10s
      retries: 3
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
  n8n:
    image: n8nio/n8n:latest
    container_name: n8n
    restart: always
    environment:
      - N8N_HOST=n8n.mydomain.com
      - N8N_PORT=5678
      - WEBHOOK_URL=https://n8n.mydomain.com/
      - GENERIC_TIMEZONE=UTC
    ports:
      - "5678:5678"
    volumes:
      - n8n_data:/home/node/.n8n
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 1G
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:5678/healthz"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
volumes:
  caddy_data:
  caddy_config:
  n8n_data:
```

## Start the containers

Run the containers in detached mode:

```
docker compose up -d
```

## Complete the setup

Navigate to `https://n8n.yourdomain.com` in your browser. Follow the setup wizard to create your admin account. Once complete, you can start building workflows.