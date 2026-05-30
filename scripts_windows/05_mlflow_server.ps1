# =====================================================================
# 05 - Tracking Server do MLflow  ***TERMINAL 1 - BLOQUEANTE***
# Deixe este terminal ABERTO. UI em http://127.0.0.1:5000
# =====================================================================

# Evita UnicodeEncodeError (MLflow imprime emojis no console Windows).
$env:PYTHONIOENCODING = "utf-8"

Write-Host "==> Subindo MLflow server em http://127.0.0.1:5000 (Ctrl+C para parar)..." -ForegroundColor Cyan
uv run mlflow server `
    --host 127.0.0.1 --port 5000 `
    --backend-store-uri sqlite:///mlflow.db `
    --artifacts-destination ./mlartifacts `
    --serve-artifacts
