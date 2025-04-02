Title: Setting up my own Forgejo instance
Date: 2025-04-04
Author: ryan
Tags: forgejo, docker
Slug: setting-up-my-own-forgejo-instance
Status: draft

## Introduction

Have you ever wondered if you could run your own Git hosting service without relying on third-party platforms, like GitHub, Bitbucket, or GitLab? I certainly did, and that curiosity led me down the path of setting up my own [Forgejo](https://forgejo.org/) instance. What started as a "let's see if I can do this" experiment quickly turned into an excellent opportunity to deepen my Docker skills while gaining complete control over my code repository.

In this tutorial, I'll walk you through the process of setting up a personal Forgejo instance using Docker on a Virtual Prive Server. I'll show both the straightforward steps and the unexpected challenges I encountered along the way. This guide covers the practical details that are easy to miss in other tutorials.

Whether you're looking to take ownership of your code or simply want to experiment with self-hosted Git services, this step-by-step guide will help you get your personal Forgejo instance up and running smoothly.

## Steps

I'll be using a Droplet (Digital Ocean's term for a VPS) to host my forgejo instance.

I won't repeat the tutorial on creating a droplet as the office Digital Ocean one can be found [here](https://docs.digitalocean.com/products/droplets/how-to/create/)

In my case I selected a droplet with the following

- Region: SFO3
- 1GB RAM
- 256GB Disk
- Ubuntu 24.04 LTS

I chose the $6 per month option from the Regular SSD. Once I had the IP address from Digital Ocean I went over to my registrar to add an `A` record at for my domain.

I use [Hover](https://www.hover.com/) and am setting this up [here](https://code.ryancheley.com). Hover had a good [tutorial](https://support.hover.com/support/solutions/articles/201000064728-managing-dns-records) on added A records for you to follow along with. Other registrars have similar guides I'm sure.

With the server administration and domain stuff out of the way we can actually start doing some stuff on our server!

You'll want to ssh into your new server. For this tutorial we're going to

- Update the server
- Install Docker
- Install Tailscale (this is optional, but I wanted the server on my Tailnet)

### Update the Server

In order to update the server you'll need to run the following commands

```bash
apt update
apt upgrade -y
```

After the first update occurs you'll get a screen asking ... you'll want to select

> Install the package maintainer's version

### Install Docker

Next we'll [Install Docker](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository).

First, we set up Docker's `apt` repository

```bash
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

Then we add the repository to Apt sources:

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### Install Tailscale

As I mentioned, I want this server on my tailnet, so I'm going to install [Tailscale](https://tailscale.com/). This part is totally optional. If you want more details on tailscale, check out ...

```bash
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up --ssh
```

The last command will display a URL for you to log into in order to authenticate on your tailnet. This will also add the server to your tailnet.

### Copying files to the server

There are 3 files that are needed to set up the server which you'll need to copy over. The are

- docker-compose.yaml
- Caddyfile
- .env

I use the `scp` command to copy the files from my local desktop to the server

```
scp file-name root@ip-address:/root
```

for example

```
scp docker-compose.yml root@192.168.1.2:/root
```

Do this for each file

### Start Docker Compose

Back at the server run the following command

```
docker compose up -d
```

This will build the docker image on your server in the background. Once you are back at the server prompt, visit your site (in my case it is https://code.ryancheley.com)

### Forgejo Config

Once your containers are up and running go to your site. You'll be prompted with a setup screen. The prompts are pretty intuitive so you should be able to just fill out the form and/or verify the settings.

The section at the bottom allows you to set up an admin user. Go ahead and enter the information there to allow you to log in as that admin user

Once you've logged in go to `../user/settings/keys`, for example on my instance I would go to

    `https://code.ryancheley.com/user/settings/keys`

You'll want to add an SSH key. If you're not sure if you have a key, or how to create one, this [link](https://docs.codeberg.org/security/ssh-key/) walks you through it.

Once you've added you're key you'll need to verify it by clicking on the `Verify Key` button. You'll get a short script to run that looks like this

```
echo -n 'superlongstringgoeshereitisverylongandhasletterseandnumbersinit' | ssh-keygen -Y sign -n gitea -f <public key file>
```
You'll get a value returned in the terminal that you'll want to copy to the Verification box in the Forgejo site

### Local Development Config

In order for you to be able to push code to your instance you'll need to edit your `~/.ssh/Config` and add the following entry at the end

```
Host nickname
  HostName url or IP address
  User username
  Post connection port
  IdentityFile ssh-key-file
```

for example

```
Host code.ryancheley.com
 45   HostName code.ryancheley.com
 46   User ryan
 47   Port 222
 48   IdentityFile ~/.ssh/id_ed25519
```

NB: note the `Port` is 222 not 22. This should match what you have in the `docker-compose.yml` file for the port mapping for the `server`

To test your connection run the following

```
ssh -T git@IPAddress
```

for example

```
ssh -T git@code.ryancheley.com
```

You should get a success message like this

> Hi there, user! You've successfully authenticated with the key named key, but Forgejo does not provide shell access.
If this is unexpected, please log in with password and setup Forgejo under another user.


## Conclusion

Setting up your own Forgejo instance provides a powerful alternative to relying on third-party Git hosting platforms. As we've seen throughout this tutorial, deploying Forgejo using Docker on a VPS is both accessible and rewarding. With $6/month Digital Ocean droplet, you can have complete control over your code repositories while gaining valuable experience with Docker, SSH configuration, and server management.

Remember that the SSH port configuration (port 222 instead of the standard port 22) is crucial for connecting to your Forgejo instance. This small but important detail can save you troubleshooting time when pushing your code.

Whether your motivation is privacy, learning, or simply the satisfaction of building your own infrastructure, self-hosting Forgejo offers flexibility that commercial platforms often can't match. You now have a personal Git service that you control completely - from access permissions to backup schedules.

I hope this tutorial has made the process clear and helped you avoid some of the pitfalls I encountered.

Happy coding!

### docker-compose.yaml

```
networks:
  forgejo:
    external: false
  database:
    external: false

services:
  server:
    image: codeberg.org/forgejo/forgejo:10
    container_name: forgejo
    env_file:
      - .env
    restart: always
    networks:
      - forgejo
      - database
    volumes:
      - ./forgejo:/data:rw
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    ports:
      - "3000:3000"
      - "222:22"
    depends_on:
      db:
        condition: service_healthy
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 1G
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/api/healthz"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

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
    networks:
      - forgejo
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

  db:
    image: postgres:16
    restart: always
    env_file:
      - .env
    networks:
      - database  # Only on database network
    volumes:
      - ./postgres:/var/lib/postgresql/data
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 1G
    healthcheck:
      test: ["CMD", "pg_isready", "-U", "${POSTGRES_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

volumes:
  caddy_data:
  caddy_config:

```


### Caddyfile

You'll need to edit line 1 to be your URL

```
dev.ryancheley.com {  # Change to your actual production domain
    # Use the container service name instead of IP
    reverse_proxy forgejo:3000 {
        header_up Host {host}
        header_up X-Real-IP {remote}
        header_up X-Forwarded-For {remote}
        header_up X-Forwarded-Proto {scheme}

        transport http {
            keepalive 30s
            keepalive_idle_conns 10
        }
        flush_interval -1
    }

    # Security headers
    header {
        Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
        X-Content-Type-Options "nosniff"
        X-Frame-Options "DENY"
        Referrer-Policy "strict-origin-when-cross-origin"
        Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; frame-ancestors 'none';"
        -Server
    }

    # Enable logging
    log {
        output file /var/log/caddy/access.log {
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

### .env

```
# User settings
USER_UID=1000
USER_GID=1000

# Forgejo database settings
FORGEJO__database__DB_TYPE=postgres
FORGEJO__database__HOST=db:5432
FORGEJO__database__NAME=forego
FORGEJO__database__USER=forgejo
FORGEJO__database__PASSWD=super-secret-and-secure-password

# PostgreSQL settings
POSTGRES_USER=forgejo
POSTGRES_PASSWORD=super-secret-and-secure-password
POSTGRES_DB=forgejo
```

> NB: POSTGRES_PASSWORD and FORGEJO__database__PASSWD need to be the same. This tripped me up pretty badly
