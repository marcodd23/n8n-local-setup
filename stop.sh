#!/bin/bash
set -e
cd "$(dirname "$0")"

docker compose down >/dev/null || true

echo "🛑 n8n stopped"
