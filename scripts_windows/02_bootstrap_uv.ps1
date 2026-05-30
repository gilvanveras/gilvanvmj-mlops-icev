# =====================================================================
# 02 - Bootstrap do projeto com uv (rode da RAIZ do repo)
# uv init UMA vez. Como a pasta ja existe (veio do gh clone), usamos 'uv init .'
# =====================================================================

if (Test-Path "pyproject.toml") {
    Write-Host "pyproject.toml ja existe - pulando 'uv init'." -ForegroundColor Yellow
} else {
    uv init .
}

uv python pin 3.11

Write-Host "==> Adicionando dependencias de runtime..." -ForegroundColor Cyan
uv add scikit-learn pandas pyarrow mlflow fastapi uvicorn dvc evidently

Write-Host "==> Adicionando dependencias de desenvolvimento..." -ForegroundColor Cyan
uv add --dev pytest ruff

Write-Host "==> Escrevendo .gitignore..." -ForegroundColor Cyan
@"
.venv/
__pycache__/
.pytest_cache/
.ruff_cache/
"@ | Set-Content -Encoding utf8 .gitignore

Write-Host "`n==> Checkpoint do ambiente:" -ForegroundColor Green
uv run dvc --version    ; if ($?) { "OK dvc" }
uv run mlflow --version ; if ($?) { "OK mlflow" }
uv run python -c "import fastapi, uvicorn, evidently; print('OK fastapi+uvicorn+evidently')"

git add pyproject.toml uv.lock .gitignore README.md
git commit -m "chore: init uv project and lock dependencies"
git push -u origin main
