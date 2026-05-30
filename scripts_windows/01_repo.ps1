# =====================================================================
# 01 - Identidade Git + repositorio no GitHub
# Rode da SUA PASTA DE TRABALHO (ex.: b:\GitProjects). Cria e entra no repo.
# =====================================================================

$INICIAIS = "gilvanvmj"          # <-- TROQUE pelas suas iniciais
$REPO = "$INICIAIS-mlops-icev"

Write-Host "==> Autenticando no GitHub (interativo)..." -ForegroundColor Cyan
gh auth login
gh auth status

Write-Host "==> Configurando identidade do Git..." -ForegroundColor Cyan
git config --global user.name  "Gilvan Veras"          # <-- ajuste
git config --global user.email "gilvanvmj@gmail.com"   # <-- ajuste

Write-Host "==> Criando e clonando o repositorio $REPO..." -ForegroundColor Cyan
gh repo create $REPO --public --clone
Set-Location $REPO

Write-Host "`n==> Repo criado. Voce esta em: $(Get-Location)" -ForegroundColor Green
Write-Host "PROXIMO: copie as pastas scripts_windows/ e src/ (e dvc.yaml, Dockerfile) para ca" -ForegroundColor Yellow
Write-Host "e rode .\scripts_windows\02_bootstrap_uv.ps1 de DENTRO deste repositorio." -ForegroundColor Yellow
