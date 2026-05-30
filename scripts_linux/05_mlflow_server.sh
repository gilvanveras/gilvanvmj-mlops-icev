#!/usr/bin/env bash
# =====================================================================
# 05 - Tracking Server do MLflow  ***TERMINAL 1 - BLOQUEANTE***  [Linux/macOS]
# Deixe este terminal ABERTO. UI em http://127.0.0.1:5000
# =====================================================================
set -euo pipefail

# Em Linux/macOS o locale costuma ser UTF-8; definimos por seguranca.
export PYTHONIOENCODING=utf-8

echo "==> Subindo MLflow server em http://127.0.0.1:5000 (Ctrl+C para parar)..."
uv run mlflow server \
    --host 127.0.0.1 --port 5000 \
    --backend-store-uri sqlite:///mlflow.db \
    --artifacts-destination ./mlartifacts \
    --serve-artifacts
