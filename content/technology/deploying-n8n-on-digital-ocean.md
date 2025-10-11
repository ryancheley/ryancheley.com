Title: Deploying n8n on Digital Ocean
Date: 2025-10-09
Author: ryan
Tags: tutorial
Slug: deploying-n8n-on-digital-ocean
Status: published

I was talking with a coworker about n8n a few weeks back and it wasn't somehting that I had heard of. I did a bit more research, saw that there were two options and decided to sign up for the free trial before spinning up my own instance. 

After a few days with it I decided it was 'neat' enough to spin up an instance of it on a VPS. I use Digital Ocean, but you can really use any VPS. I told this same coworker what I had done and decided that it was straight forward enough to write up a Tutorial for it so that's what I'm doing. 

I'll assume that you're using Digital Ocean for this, but again, any VPS will work.

## Setting up the VPS

I [created a droplet](https://docs.digitalocean.com/products/droplets/how-to/create/) ($6 per month) with the following specs with Ubuntu 24.04: 

* 1GB RAM
* 25GB Memory
* 1 vcpu

Once the droplet was available, I ssh'd into it

```
ssh root@ipaddress
```

Once logged in, I ran the update and upgrade commands

```
apt update
apt upgrade -y
```

## Installing Docker

Once the update and upgrade were complete, I [installed docker](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)

```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker and it's components
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

```

Now we just want to check that the Docker service is running

```
sudo systemctl status docker
```

You should get something like this

```
● docker.service - Docker Application Container Engine
     Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled; preset: enabled)
     Active: active (running) since Wed 2025-10-08 23:28:46 UTC; 19s ago
 Invocation: d7b148be69354719ae625e6c6d264ce9
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
   Main PID: 13474 (dockerd)
      Tasks: 8
     Memory: 31.6M (peak: 31.6M)
        CPU: 381ms
     CGroup: /system.slice/docker.service
             └─13474 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

Oct 08 23:28:46 do-web-t-002 dockerd[13474]: time="2025-10-08T23:28:46.439065137Z" level=info msg="detected 127.0.0.53 nameserver, assuming systemd-re>
Oct 08 23:28:46 do-web-t-002 dockerd[13474]: time="2025-10-08T23:28:46.515566952Z" level=info msg="Creating a containerd client" address=/run/containe>
Oct 08 23:28:46 do-web-t-002 dockerd[13474]: time="2025-10-08T23:28:46.554097631Z" level=info msg="Loading containers: start."
Oct 08 23:28:46 do-web-t-002 dockerd[13474]: time="2025-10-08T23:28:46.937837478Z" level=info msg="Loading containers: done."
Oct 08 23:28:46 do-web-t-002 dockerd[13474]: time="2025-10-08T23:28:46.955799218Z" level=info msg="Docker daemon" commit=f8215cc containerd-snapshotte>
Oct 08 23:28:46 do-web-t-002 dockerd[13474]: time="2025-10-08T23:28:46.955915990Z" level=info msg="Initializing buildkit"
Oct 08 23:28:46 do-web-t-002 dockerd[13474]: time="2025-10-08T23:28:46.968310097Z" level=info msg="Completed buildkit initialization"
```

Once you have that, press `q` to escape out of the data being displayed

Now, we verify that the installation is succesful by running the Docker Hello World image

```
sudo docker run hello-world
```

This should output somethign like

```bash
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
17eec7bbc9d7: Pull complete
Digest: sha256:54e66cc1dd1fcb1c3c58bd8017914dbed8701e2d8c74d9262e26bd9cc1642d31
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

## Setting up my subdomain / domain

I use Hover to manage my domains. I set up a sub domain https://n8n.mydomain.com

## Caddy

I use Caddy to serve up ssl stuff



Create a `docker-compose.yml` and add the following:

```yaml
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

Caddyfile

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

## Setting up n8n

docker-compose.yml

```yaml
services:
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
  n8n_data:
```

## running the contianer

```
docker compose up -d
```

## Accessing n8n

Now that we've got everything set up, we can go to https://n8n.mydomain.com and follow the steps to set up n8n