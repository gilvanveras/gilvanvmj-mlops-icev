# =====================================================================
# 06 - Treino instrumentado (TERMINAL 2, com o server do passo 05 no ar)
# Treina um Pipeline (scaler + RF), loga no MLflow e registra 'wine-classifier'.
# =====================================================================

$env:PYTHONIOENCODING = "utf-8"
$env:MLFLOW_TRACKING_URI = "http://127.0.0.1:5000"

uv run python src/train.py

Write-Host "`n==> Veja a nova versao na UI: http://127.0.0.1:5000  (Models -> wine-classifier)" -ForegroundColor Green
