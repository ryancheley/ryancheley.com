#!/bin/bash
set -e

# Use SITEURL from environment variable, with a default fallback
SITEURL=${SITEURL:-"https://ryancheley.com"}

echo "Building site with SITEURL: $SITEURL"

# Generate the static site with properly JSON-formatted SITEURL
pelican content -s publishconf.py -e SITEURL='"'${SITEURL}'"'

# Copy generated files to nginx html directory
cp -r output/* /usr/share/nginx/html/

# nginx won't create the log dir itself; a persisted volume may shadow the
# image's dir, so ensure it exists on every start
mkdir -p /var/log/nginx/ryancheley.com

echo "Starting nginx server on port 8080"

# Start nginx in foreground
exec nginx -g 'daemon off;'
