#!/bin/bash
set -e
cd "$(dirname "$0")"

# Enable tunnel (ensure override exists)
if [ -f compose.override.yml.disabled ]; then
  mv compose.override.yml.disabled compose.override.yml
elif [ ! -f compose.override.yml ]; then
  cat > compose.override.yml << 'EON'
services:
  n8n:
    command: ["start", "--tunnel"]
EON
fi

echo "N8N_TUNNEL_ENABLED=true" > .env

docker compose down >/dev/null || true

docker compose up -d >/dev/null
sleep 5

echo "✅ Tunnel enabled and n8n restarted"
echo "Local:  http://localhost:5678"
TUNNEL=$(docker compose logs n8n 2>/dev/null | grep -E "Tunnel URL:" | tail -1 | awk '{print $NF}')
if [ -n "$TUNNEL" ]; then
  echo "Public: $TUNNEL"
else
  echo "Public: (initializing) -> run: docker compose logs n8n | grep 'Tunnel URL'"
fi
