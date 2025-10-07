#!/bin/bash
set -e
cd "$(dirname "$0")"

docker compose up -d >/dev/null
sleep 5

echo "✅ n8n started"
echo "Local:  http://localhost:5678"
if [ -f compose.override.yml ]; then
  # Try to extract tunnel URL from logs (best-effort)
  TUNNEL=$(docker compose logs n8n 2>/dev/null | grep -E "Tunnel URL:" | tail -1 | awk '{print $NF}')
  if [ -n "$TUNNEL" ]; then
    echo "Public: $TUNNEL"
  else
    echo "Public: (initializing) -> run: docker compose logs n8n | grep 'Tunnel URL'"
  fi
fi
