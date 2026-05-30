# =====================================================================
# 12 - docker compose up (MLflow + API juntos)  ***BLOQUEANTE***
# Sobe os dois servicos definidos no docker-compose.yml.
#   API:    http://localhost:8000/docs     MLflow: http://localhost:5000
# Precisa do Docker Desktop rodando.
# =====================================================================

Write-Host "==> docker compose up --build (Ctrl+C para parar)..." -ForegroundColor Cyan
docker compose up --build

# Em outro terminal:  Invoke-RestMethod http://localhost:8000/health
# Para derrubar:      docker compose down
