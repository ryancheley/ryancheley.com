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

### Production Mode

Build and run using production configuration (no drafts):

```bash
docker compose build
docker compose up -d
```

The site will be available at http://localhost

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

The `docker-compose.yml` file follows Coolify best practices:

- **Port 80 Exposure**: The service exposes port 80 for Coolify's proxy to route traffic
- **Environment Variables**: Uses Docker Compose variable syntax (${VAR:-default}) for Coolify auto-detection
- **Healthcheck**: Integrated healthcheck for deployment status monitoring
- **Restart Policy**: `unless-stopped` for automatic recovery

### Environment Variables

Coolify will auto-detect these variables (defaults are provided for local development):

- `SITE_URL`: Production URL (default: https://www.ryancheley.com)
- `SITE_NAME`: Site name (default: RyanCheley.com)
- `AUTHOR`: Author name (default: Ryan Cheley)
- `TIMEZONE`: Timezone (default: America/Los_Angeles)

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

### Build Failures

If the build fails during dependency installation:
- Check that requirements.txt is valid
- Ensure build-essential is included in Dockerfile (needed for packages with native extensions)

### Site Not Accessible

If the site isn't accessible after starting:
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
