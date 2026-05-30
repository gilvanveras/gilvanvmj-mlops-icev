#!/usr/bin/env bash
# =====================================================================
# 10 - Empacotar e rodar em Docker (rode da RAIZ do repo)  [Linux/macOS]
# No Docker Linux, host.docker.internal NAO existe por padrao: usamos
# --add-host=host.docker.internal:host-gateway (Docker 20.10+).
# Precisa do Docker rodando e do server MLflow (05) no ar.
# =====================================================================
set -euo pipefail

INICIAIS="gilvanvmj"          # <-- TROQUE pelas suas iniciais
IMG="${INICIAIS}/wine-classifier:0.1.0"

echo "==> Build da imagem ${IMG}..."
docker build -t "${IMG}" .

echo "==> Subindo o container (Ctrl+C para parar)..."
docker run --rm -p 8000:8000 \
    --add-host=host.docker.internal:host-gateway \
    -e MLFLOW_TRACKING_URI="http://host.docker.internal:5000" \
    "${IMG}"

# Em outro terminal:  curl http://localhost:8000/health
