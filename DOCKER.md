# Docker Deployment for RyanCheley.com

This Pelican static site has been configured to run in Docker containers, with support for Coolify deployment.

## Local Development

### Development Mode (with drafts)

For local development where you want to see draft articles:

```bash
# Build with development config
docker compose -f docker-compose.dev.yml build

# Start the container
docker compose -f docker-compose.dev.yml up -d

# The site will be available at http://localhost
# Drafts will be accessible at http://localhost/drafts/
```

Stop the container:
```bash
docker compose -f docker-compose.dev.yml down
```

### Production Mode (Local Testing)

Build and run using production configuration (no drafts):

```bash
docker compose build
docker compose up -d
```

**Note**: The production docker-compose.yaml doesn't map port 80 to localhost (for Coolify compatibility). To test production builds locally, you can either:
1. Temporarily add `ports: ["80:80"]` to docker-compose.yaml, or
2. Use the dev configuration: `docker compose -f docker-compose.dev.yml build --build-arg BUILD_ENV=production && docker compose -f docker-compose.dev.yml up -d`

Stop the container:
```bash
docker compose down
```

### View Logs

```bash
docker compose logs -f
```

### Rebuild After Changes

If you make changes to content or configuration:

**Development mode:**
```bash
docker compose -f docker-compose.dev.yml down
docker compose -f docker-compose.dev.yml build --no-cache
docker compose -f docker-compose.dev.yml up -d
```

**Production mode:**
```bash
docker compose down
docker compose build --no-cache
docker compose up -d
```

### Development vs Production

The key differences between the two modes:

| Feature | Development | Production |
|---------|------------|------------|
| Config file | `pelicanconf.py` | `publishconf.py` |
| Draft articles | ✅ Included at `/drafts/` with directory listing | ❌ Excluded |
| Future-dated posts | ❌ Excluded (`WITH_FUTURE_DATES = False`) | ❌ Excluded |
| RSS/Atom feeds | ❌ Disabled | ✅ Enabled |
| Site URL | `http://localhost` | `https://www.ryancheley.com` |
| Relative URLs | Enabled | Disabled |

### Accessing Draft Articles

In development mode, draft articles (marked with `Status: draft` in their metadata) are:
- Generated in the `/drafts/` directory
- Accessible via directory listing at http://localhost/drafts/
- Each draft can be clicked to view the rendered HTML

## Architecture

### Multi-Stage Build

The Dockerfile uses a multi-stage build process:

1. **Builder Stage** (Python 3.13-slim)
   - Installs build dependencies (git, build-essential)
   - Installs Python dependencies from requirements.txt
   - Copies project files (content, config, theme)
   - Generates static site using `pelican content -s publishconf.py`

2. **Production Stage** (nginx:alpine)
   - Copies built static files from builder stage
   - Copies custom nginx configuration (`nginx.conf`)
   - Serves content via nginx on port 80
   - Enables directory listing for `/drafts/` (useful in development)
   - Lightweight final image (no Python or build tools)

### Healthcheck

The container includes a healthcheck that:
- Runs every 30 seconds
- Checks if nginx is serving content on port 80
- Allows 5 seconds startup time before first check
- Retries 3 times before marking as unhealthy

## Coolify Deployment

This project is configured for deployment with [Coolify](https://coolify.io/).

### Configuration

The `docker-compose.yaml` file follows Coolify best practices:

- **No Port Mapping**: Coolify manages networking through its own proxy, so we don't map ports to the host (no `ports:` section)
- **Internal Port 80**: The service listens on port 80 internally (defined in Dockerfile with `EXPOSE 80`)
- **Environment Variables**: Uses Docker Compose variable syntax (${VAR:-default}) for Coolify auto-detection
- **Healthcheck**: Integrated healthcheck for deployment status monitoring
- **Restart Policy**: `unless-stopped` for automatic recovery

**Important**: The production `docker-compose.yaml` does NOT include a `ports:` section because Coolify handles routing. Port mapping is only needed for local development (see `docker-compose.dev.yml`).

### Environment Variables

Coolify will auto-detect these variables. **IMPORTANT**: These must be set as **build-time** environment variables in Coolify, not runtime variables.

#### Build-Time Variables (Required)

- `SITE_URL`: **CRITICAL** - The full URL where the site will be deployed (e.g., `https://hetzner.uat.ryancheley.com`)
  - This is used by Pelican to generate all internal links
  - Must be set at BUILD time, not runtime
  - Default: `https://www.ryancheley.com`

#### Runtime Variables (Optional)

- `SITE_NAME`: Site name (default: RyanCheley.com)
- `AUTHOR`: Author name (default: Ryan Cheley)
- `TIMEZONE`: Timezone (default: America/Los_Angeles)

#### Setting SITE_URL in Coolify

To deploy to a custom domain (e.g., UAT):

1. In Coolify, go to your application
2. Click on **"Environment Variables"** or **"Build Variables"**
3. Add a **build-time** variable:
   ```
   SITE_URL=https://hetzner.uat.ryancheley.com
   ```
4. **Important**: Make sure it's marked as a **build variable**, not just a runtime variable
5. Save and redeploy

Without setting `SITE_URL`, all links will point to the production domain (https://www.ryancheley.com), even when deployed to UAT or other environments.

### Deployment Steps

1. **Create a new service in Coolify**
   - Choose "Docker Compose" as the service type
   - Point to this repository

2. **Configure environment variables**
   - Coolify will auto-detect variables from docker-compose.yml
   - Set production values as needed

3. **Deploy**
   - Coolify will build and deploy using the docker-compose.yml configuration
   - The service will be accessible via the assigned domain

## File Structure

```
.
├── Dockerfile              # Multi-stage build configuration
├── docker-compose.yml      # Production service orchestration
├── docker-compose.dev.yml  # Development service orchestration
├── nginx.conf             # Custom nginx config (enables /drafts/ listing)
├── .dockerignore          # Files excluded from build context
├── DOCKER.md              # This file
├── requirements.txt       # Python dependencies
├── pelicanconf.py         # Pelican development config
├── publishconf.py         # Pelican production config
├── content/               # Blog content
└── pelican-clean-blog/    # Theme
```

## Troubleshooting

### Coolify Deployment: "port is already allocated" Error

**Error**: `Bind for 0.0.0.0:80 failed: port is already allocated`

**Cause**: The docker-compose.yaml file has a `ports:` section mapping port 80 to the host.

**Solution**: Remove the `ports:` section from docker-compose.yaml. Coolify manages networking through its own proxy and doesn't need direct port mapping. The service should only expose port 80 internally (via `EXPOSE 80` in the Dockerfile).

**Correct docker-compose.yaml** (no ports section):
```yaml
services:
  web:
    build:
      context: .
      dockerfile: Dockerfile
    environment:
      - SITE_URL=${SITE_URL:-https://www.ryancheley.com}
    # NO ports: section here!
```

### Links Point to Wrong Domain

**Problem**: After deploying to UAT or custom domain, all internal links still point to `https://www.ryancheley.com`

**Cause**: The `SITE_URL` build variable isn't set in Coolify, so Pelican uses the default production URL when generating the site.

**Solution**: Set `SITE_URL` as a **build-time** environment variable in Coolify:

1. Go to your application in Coolify
2. Navigate to **Environment Variables**
3. Add:
   ```
   SITE_URL=https://hetzner.uat.ryancheley.com
   ```
4. Ensure it's marked as a **build variable** (not just runtime)
5. Redeploy the application

After redeployment, all internal links will use the correct domain.

### Build Failures

If the build fails during dependency installation:
- Check that requirements.txt is valid
- Ensure build-essential is included in Dockerfile (needed for packages with native extensions)

### Site Not Accessible (Local Development)

If the site isn't accessible after starting locally:
- Make sure you're using `docker-compose.dev.yml` which includes port mapping
- Check container status: `docker compose ps`
- View logs: `docker compose logs web`
- Verify port 80 isn't in use: `lsof -i :80`

### Content Not Updating

If content changes aren't reflected:
- Ensure you're rebuilding with `--no-cache`
- Check that content files are copied in Dockerfile
- Verify .dockerignore isn't excluding needed files

## Production Considerations

- **Static Content**: The site is fully static, generated at build time
- **No Dynamic Updates**: Content changes require a rebuild and redeployment
- **Nginx Configuration**: Uses default nginx config; customize by uncommenting the COPY line in Dockerfile and creating nginx.conf
- **SSL/HTTPS**: Handled by Coolify's proxy layer
- **CDN**: Consider adding a CDN for better performance

## GitHub Actions Integration

The existing GitHub Actions workflows can be updated to trigger Coolify deployments via webhooks, or you can let Coolify handle deployments directly via git push detection.
