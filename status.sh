#!/bin/bash
cd "$(dirname "$0")" || exit 1

# Check container state
RUNNING=$(docker compose ps --status running --services 2>/dev/null | grep -c '^n8n$' || true)

if [ "$RUNNING" -eq 1 ]; then
  echo "✅ n8n: RUNNING"
else
  echo "🛑 n8n: STOPPED"
fi

# Local URL (always valid when running)
echo "Local:  http://localhost:5678"

# Tunnel state from override file
if [ -f compose.override.yml ]; then
  echo "Tunnel: ENABLED"
  # Try to fetch the tunnel URL from logs (best effort)
  TUNNEL=$(docker compose logs n8n 2>/dev/null | grep -E "Tunnel URL:" | tail -1 | awk '{print $NF}')
  if [ -n "$TUNNEL" ]; then
    echo "Public: $TUNNEL"
  else
    echo "Public: (initializing) -> run: docker compose logs n8n | grep 'Tunnel URL'"
  fi
else
  echo "Tunnel: DISABLED"
fi
