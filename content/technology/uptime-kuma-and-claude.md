Title: Uptime Kuma and Claude
Date: 2025-05-07
Author: ryan
Tags: oss, monitoring
Slug: uptime-kuma-and-claude
Status: published

While talking to a colleague of mine he had mentioned something called [Uptime Kuma](https://uptime.kuma.pet/), which is an open source alternative to Uptime Robot. This was interesting for me because I have Uptime Robot checking a couple of my websites and I thought, "Hey, maybe I can use Uptime Kuma as a replacement for Uptime Robot."

I dove into the [docs](https://github.com/louislam/uptime-kuma/blob/master/README.md) a bit and discovered that there was a Docker image for it, which was nice. 

I then used Claude to take the `docker run` command 

```
docker run -d \
    --restart=always \
    -p 3001:3001 \
    -v uptime-kuma:/app/data \
    --name uptime-kuma louislam/uptime-kuma:1
```

and turn it into a compose file, which gave me this

```
version: '3'

services:
  uptime-kuma:
    image: louislam/uptime-kuma:1
    container_name: uptime-kuma
    restart: always
    ports:
      - "3001:3001"
    volumes:
      - uptime-kuma:/app/data

volumes:
  uptime-kuma:
```

Next, I took the output of that compose file and asked Claude to also generate a caddy configuration for me and it gave me this

```
monitor.yourdomain.com {
    # Enable compression
    encode gzip zstd

    # Add security headers
    header {
        # Enable HSTS
        Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
        # Prevent content-type sniffing
        X-Content-Type-Options "nosniff"
        # Referrer policy
        Referrer-Policy "strict-origin-when-cross-origin"
    }

    # Reverse proxy to Uptime Kuma
    reverse_proxy localhost:3001
}
```

I then SSH'd into one of my servers using [Shellfish](https://secureshellfish.app/) [ref]this is an amazing app on the iPad, highly recommend[/ref]. 

I updated the `docker-compose.yml` file and my `Caddyfile` to include what Claude had output. 

I restarted my docker containers and didn't get my new container running. 

So I took the whole Docker Compose file from my server and I put that into Claude and said, 

> Hey, is there anything wrong with my Docker Compose file? 

It indicated that there were some issues and provided updates for. I made those changes and did the same thing with the `Caddyfile`. Again, Claude offered up some changes. I applied the recommended changes for the `docker-compose.yml` file and the `Caddyfile` stopped and started my docker containers. 

I suddenly had an instance of Uptime Kuma. All in all, it took about a half hour from start to finish while I was watching a [hockey game](https://theahl.com/stats/game-center/1027706) ... from my iPad. 

I didn't really have to do anything other than a couple of tweaks here and there on the Docker Compose file and a couple of tweaks here and there on the Caddyfile. and I suddenly have this tool that allows me to monitor the uptime of various websites that I'm interested in. 

As I wrapped up it hit me ... holy crap, this is an amazing time to live[ref]Yes, there's also some truly horrific shit going on too[/ref]. You have an idea, Claude (or whatever AI tool you want to use) outputs a thing, and then you're up and running. This really reduces that barrier to entry to just try new things. 

Is the Docker Compose file the most performant? I don't know. Is the Caddyfile the most secured lockdown thing? I don't know. 

But for these small projects that are just me, I don't know how much it really matters. 
