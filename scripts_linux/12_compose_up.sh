#!/usr/bin/env bash
# =====================================================================
# 12 - docker compose up (MLflow + API juntos)  ***BLOQUEANTE***
# Sobe os dois servicos definidos no docker-compose.yml.
#   API:    http://localhost:8000/docs     MLflow: http://localhost:5000
# Precisa do Docker rodando.
# =====================================================================
set -euo pipefail

echo "==> docker compose up --build (Ctrl+C para parar)..."
docker compose up --build

# Em outro terminal:  curl http://localhost:8000/health
# Para derrubar:      docker compose down
