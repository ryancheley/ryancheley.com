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

This project uses a `.env` file for environment-specific configuration. The docker-compose.yaml file reads from `.env` automatically.

#### Configuration Files

- **`.env.example`** - Template showing all available variables with defaults
- **`.env`** - Your local environment file (git-ignored, create from .env.example)

#### Available Variables

##### Build-Time Variables (Required for correct URLs)

- `SITE_URL`: **CRITICAL** - The full URL where the site will be deployed
  - This is used by Pelican to generate all internal links
  - Must be set at BUILD time, not runtime
  - Examples:
    - Production: `https://www.ryancheley.com`
    - UAT: `https://hetzner.uat.ryancheley.com`
    - Local: `http://localhost`

##### Runtime Variables (Optional)

- `SITE_NAME`: Site name (default: RyanCheley.com)
- `AUTHOR`: Author name (default: Ryan Cheley)
- `TIMEZONE`: Timezone (default: America/Los_Angeles)

#### Local Development

```bash
# Copy the example file
cp .env.example .env

# Edit .env with your local settings
# For local dev, you typically want:
# SITE_URL=http://localhost

# Run docker compose (it will automatically use .env)
docker compose -f docker-compose.dev.yml up -d
```

#### Coolify Deployment

Coolify needs to set environment variables for each deployment. There are two approaches:

##### Option 1: Using Coolify's Environment Variables (Recommended)

1. In Coolify, go to your application
2. Navigate to **"Environment Variables"**
3. Add these variables with **"Build Time"** enabled:
   ```
   SITE_URL=https://hetzner.uat.ryancheley.com
   ```
4. Save and redeploy

**Important**: The variable must be available at **build time** because Pelican generates static HTML during the Docker build process.

##### Option 2: Commit Environment-Specific .env Files (Alternative)

If Coolify doesn't easily support build-time variables, you can:

1. Create environment-specific branches or use a different approach
2. Commit a `.env.uat` file to your repo:
   ```bash
   echo "SITE_URL=https://hetzner.uat.ryancheley.com" > .env.uat
   git add .env.uat
   ```
3. Modify docker-compose.yaml to use `.env.uat` for that deployment
4. Configure Coolify to use the appropriate file

However, **Option 1 is preferred** as it keeps secrets out of git.

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
├── docker-compose.yaml     # Production service orchestration
├── docker-compose.dev.yml  # Development service orchestration
├── .env.example           # Environment variable template
├── .env                   # Your local environment (git-ignored)
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

**Solution 1**: Set `SITE_URL` as a **build-time** environment variable in Coolify:

1. Go to your application in Coolify
2. Navigate to **Environment Variables**
3. Add:
   ```
   SITE_URL=https://hetzner.uat.ryancheley.com
   ```
4. **Critical**: Look for a checkbox or toggle that says:
   - "Available at build time"
   - "Build variable"
   - "Build time environment variable"

   Make sure this is **enabled/checked**.
5. Save and redeploy

**Solution 2**: If build-time variables aren't working in your Coolify version:

Create a `.env.uat` file in your repository:
```bash
echo "SITE_URL=https://hetzner.uat.ryancheley.com" > .env.uat
git add .env.uat
git commit -m "Add UAT environment configuration"
```

Then in Coolify, configure it to copy this file:
- Add a pre-build command: `cp .env.uat .env`
- Or modify your docker-compose.yaml to reference the specific env file

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
