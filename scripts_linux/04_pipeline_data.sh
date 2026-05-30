#!/usr/bin/env bash
# =====================================================================
# 04 - Etapa 'data' do pipeline (rode da RAIZ do repo)  [Linux/macOS]
# raw -> processed: src/data.py normaliza nomes de coluna ('/' -> '_').
# =====================================================================
set -euo pipefail

# Opcao A: rodar o script direto
uv run python src/data.py

# Opcao B (equivalente, via DVC): reproduz so o estagio 'data' do dvc.yaml
# uv run dvc repro data

echo
echo "==> Checkpoint: colunas do processed (od280_od315 com underscore)"
uv run python -c "import pandas as pd; print(list(pd.read_parquet('data/processed/wine.parquet').columns)[-3:])"
