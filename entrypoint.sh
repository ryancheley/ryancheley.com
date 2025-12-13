#!/bin/bash
set -e

# Use SITEURL from environment variable, with a default fallback
SITEURL=${SITEURL:-"https://ryancheley.com"}

echo "Building site with SITEURL: $SITEURL"

# Generate the static site with properly JSON-formatted SITEURL
pelican content -s publishconf.py -e SITEURL='"'${SITEURL}'"'

# Copy generated files to nginx html directory
cp -r output/* /usr/share/nginx/html/

echo "Starting nginx server on port 80"

# Start nginx in foreground
exec nginx -g 'daemon off;'
