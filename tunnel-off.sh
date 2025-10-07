#!/bin/bash
set -e
cd "$(dirname "$0")"

# Disable tunnel (rename override if present)
if [ -f compose.override.yml ]; then
  mv compose.override.yml compose.override.yml.disabled
fi

echo "N8N_TUNNEL_ENABLED=false" > .env

docker compose down >/dev/null || true

docker compose up -d >/dev/null
sleep 5

echo "✅ Tunnel disabled and n8n restarted"
echo "Local:  http://localhost:5678"
