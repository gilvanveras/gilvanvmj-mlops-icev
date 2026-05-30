# =====================================================================
# 11 - CI local (espelha o job 'quality' do .github/workflows/ci.yml)
# Roda os MESMOS gates que o GitHub Actions: lint + testes (fail fast).
# =====================================================================

Write-Host "==> ruff (lint)..." -ForegroundColor Cyan
uv run ruff check .

Write-Host "==> pytest (testes)..." -ForegroundColor Cyan
uv run pytest -q

Write-Host "`n==> Se passou aqui, o job 'quality' do CI tambem passa." -ForegroundColor Green
