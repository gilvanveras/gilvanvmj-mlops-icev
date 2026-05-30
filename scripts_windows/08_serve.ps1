# =====================================================================
# 08 - Servir o modelo com FastAPI  ***TERMINAL 2 - BLOQUEANTE***
# Precisa do server MLflow (05) no ar e do @champion (07) definido.
# Docs interativas em http://127.0.0.1:8000/docs
# =====================================================================

$env:MLFLOW_TRACKING_URI = "http://127.0.0.1:5000"

Write-Host "==> Subindo a API em http://127.0.0.1:8000 (Ctrl+C para parar)..." -ForegroundColor Cyan
uv run uvicorn src.api.main:app --host 127.0.0.1 --port 8000 --reload
