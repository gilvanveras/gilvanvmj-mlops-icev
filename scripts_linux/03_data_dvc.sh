#!/usr/bin/env bash
# =====================================================================
# 03 - Dados versionados com DVC (rode da RAIZ do repo)  [Linux/macOS]
# Gera o dataset BRUTO (nomes originais, com '/') e versiona com DVC.
# =====================================================================
set -euo pipefail

if [ ! -d .dvc ]; then uv run dvc init; else echo ".dvc ja existe - pulando init."; fi

# Remote local (pasta no disco). Em producao: S3/Azure/GCS.
REMOTE="$HOME/dvcstore"
mkdir -p "$REMOTE"
uv run dvc remote add -d -f local "$REMOTE"

echo "==> Gerando data/raw/wine.parquet a partir do scikit-learn..."
mkdir -p data/raw
uv run python -c "from sklearn.datasets import load_wine; import pandas as pd; w=load_wine(as_frame=True); pd.concat([w.data, w.target.rename('y')], axis=1).to_parquet('data/raw/wine.parquet')"

echo "==> Versionando o RAW com DVC..."
uv run dvc add data/raw/wine.parquet
uv run dvc push

git add data/raw/wine.parquet.dvc data/raw/.gitignore .dvc/ .dvcignore
git commit -m "feat: bootstrap dvc + wine raw v1"
git push

echo
echo "==> Checkpoint: existe data/raw/wine.parquet e .dvc"
ls -l data/raw
