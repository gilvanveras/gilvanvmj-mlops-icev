# =====================================================================
# 03 - Dados versionados com DVC (rode da RAIZ do repo)
# Gera o dataset BRUTO (nomes originais, com '/') e versiona com DVC.
# =====================================================================

if (-not (Test-Path ".dvc")) { uv run dvc init } else { Write-Host ".dvc ja existe - pulando init." -ForegroundColor Yellow }

# Remote local (pasta no disco). Em producao: S3/Azure/GCS.
$REMOTE = "$env:USERPROFILE\dvcstore"
New-Item -ItemType Directory -Force $REMOTE | Out-Null
uv run dvc remote add -d -f local $REMOTE

Write-Host "==> Gerando data/raw/wine.parquet a partir do scikit-learn..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force data\raw | Out-Null
uv run python -c "from sklearn.datasets import load_wine; import pandas as pd; w=load_wine(as_frame=True); pd.concat([w.data, w.target.rename('y')], axis=1).to_parquet('data/raw/wine.parquet')"

Write-Host "==> Versionando o RAW com DVC..." -ForegroundColor Cyan
uv run dvc add data/raw/wine.parquet
uv run dvc push

git add data/raw/wine.parquet.dvc data/raw/.gitignore .dvc/ .dvcignore
git commit -m "feat: bootstrap dvc + wine raw v1"
git push

Write-Host "`n==> Checkpoint: existe data/raw/wine.parquet e .dvc" -ForegroundColor Green
Get-ChildItem data\raw
