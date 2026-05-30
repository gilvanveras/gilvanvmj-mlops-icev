# =====================================================================
# 10 - Empacotar e rodar em Docker (rode da RAIZ do repo)
# O container fala com o MLflow do HOST via host.docker.internal.
# Precisa do Docker Desktop rodando e do server MLflow (05) no ar.
# =====================================================================

$INICIAIS = "gilvanvmj"          # <-- TROQUE pelas suas iniciais
$IMG = "$INICIAIS/wine-classifier:0.1.0"

Write-Host "==> Build da imagem $IMG..." -ForegroundColor Cyan
docker build -t $IMG .

Write-Host "==> Subindo o container (Ctrl+C para parar)..." -ForegroundColor Cyan
docker run --rm -p 8000:8000 `
    -e MLFLOW_TRACKING_URI="http://host.docker.internal:5000" `
    $IMG

# Em outro terminal:  Invoke-RestMethod http://localhost:8000/health
