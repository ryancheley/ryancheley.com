#!/bin/bash
set -e

# Use SITEURL from environment variable, with a default fallback
SITEURL=${SITEURL:-"https://ryancheley.com"}

echo "Building site with SITEURL: $SITEURL"

# Generate the static site with properly JSON-formatted SITEURL
pelican content -s publishconf.py -e SITEURL='"'${SITEURL}'"'

echo "Starting HTTP server on port 80"

# Serve the static files
exec python -m http.server 80 --bind 0.0.0.0 --directory output
