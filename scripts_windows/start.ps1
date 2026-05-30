# =====================================================================
# start.ps1 - Menu interativo do curso (Windows / PowerShell)
# Rode da raiz do repo:  .\scripts_windows\start.ps1
# Menu: 0=setup, 1=validar ambiente, 2..11 = passos 01..10.
# =====================================================================

# Trabalha sempre a partir da RAIZ do repo (pai desta pasta), para que
# caminhos como src/ e data/ resolvam, nao importa de onde foi chamado.
$ScriptDir = $PSScriptRoot
Set-Location (Split-Path $ScriptDir -Parent)

function Invoke-Step($file) {
    $path = Join-Path $ScriptDir $file
    if (Test-Path $path) {
        powershell -ExecutionPolicy Bypass -File $path
    } else {
        Write-Host "Script nao encontrado: $path" -ForegroundColor Red
    }
}

function Test-Ambiente {
    Write-Host "==> Validando ambiente..." -ForegroundColor Cyan
    uv --version
    uv run python --version
    git --version
    if (Get-Command docker -ErrorAction SilentlyContinue) { docker --version } else { Write-Host "docker: nao encontrado" -ForegroundColor Yellow }
    if (Get-Command gh -ErrorAction SilentlyContinue) { gh --version } else { Write-Host "gh: nao encontrado (opcional)" -ForegroundColor Yellow }
    uv run python -c "import fastapi, uvicorn, evidently, mlflow, sklearn; print('OK imports (fastapi/uvicorn/evidently/mlflow/sklearn)')"
}

function Show-Menu {
    Write-Host ""
    Write-Host "==== Curso MLOps - Wine Classifier (Windows) ====" -ForegroundColor Green
    Write-Host "  0) Setup: instalar ferramentas (uma vez)"
    Write-Host "  1) Validar ambiente"
    Write-Host "  2) Criar repo no GitHub"
    Write-Host "  3) Bootstrap uv (deps + .gitignore)"
    Write-Host "  4) Dados + DVC (raw + push)"
    Write-Host "  5) Pipeline: raw -> processed"
    Write-Host "  6) MLflow server          [Terminal 1 - BLOQUEANTE]" -ForegroundColor Yellow
    Write-Host "  7) Treinar (registra wine-classifier)"
    Write-Host "  8) Promover @champion"
    Write-Host "  9) Servir API             [BLOQUEANTE]" -ForegroundColor Yellow
    Write-Host " 10) Testar /health e /predict"
    Write-Host " 11) Docker build + run"
    Write-Host "  --- Domingo: CI/CD, deploy, monitoramento, ciclo de vida ---" -ForegroundColor DarkGray
    Write-Host " 12) CI local (lint + testes)"
    Write-Host " 13) docker compose up      [BLOQUEANTE]" -ForegroundColor Yellow
    Write-Host " 14) Drift report (Evidently)"
    Write-Host " 15) Avaliar challenger vs champion"
    Write-Host "  q) Sair"
}

while ($true) {
    Show-Menu
    $opt = Read-Host "Opcao"
    switch ($opt) {
        '0'  { Invoke-Step '00_setup.ps1' }
        '1'  { Test-Ambiente }
        '2'  { Invoke-Step '01_repo.ps1' }
        '3'  { Invoke-Step '02_bootstrap_uv.ps1' }
        '4'  { Invoke-Step '03_data_dvc.ps1' }
        '5'  { Invoke-Step '04_pipeline_data.ps1' }
        '6'  { Invoke-Step '05_mlflow_server.ps1' }
        '7'  { Invoke-Step '06_train.ps1' }
        '8'  { Invoke-Step '07_promote.ps1' }
        '9'  { Invoke-Step '08_serve.ps1' }
        '10' { Invoke-Step '09_test_predict.ps1' }
        '11' { Invoke-Step '10_docker.ps1' }
        '12' { Invoke-Step '11_ci_local.ps1' }
        '13' { Invoke-Step '12_compose_up.ps1' }
        '14' { Invoke-Step '13_drift_report.ps1' }
        '15' { Invoke-Step '14_evaluate.ps1' }
        'q'  { break }
        'Q'  { break }
        default { Write-Host "Opcao invalida: $opt" -ForegroundColor Red }
    }
    if ($opt -ne 'q' -and $opt -ne 'Q') {
        Read-Host "`nPressione Enter para voltar ao menu"
    }
}
