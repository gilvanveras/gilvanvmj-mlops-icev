# =====================================================================
# 04 - Etapa 'data' do pipeline (rode da RAIZ do repo)
# raw -> processed: src/data.py normaliza nomes de coluna ('/' -> '_').
# =====================================================================

# Opcao A: rodar o script direto
uv run python src/data.py

# Opcao B (equivalente, via DVC): reproduz so o estagio 'data' do dvc.yaml
# uv run dvc repro data

Write-Host "`n==> Checkpoint: colunas do processed (od280_od315 com underscore)" -ForegroundColor Green
uv run python -c "import pandas as pd; print(list(pd.read_parquet('data/processed/wine.parquet').columns)[-3:])"
