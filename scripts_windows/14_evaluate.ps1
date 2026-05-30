# =====================================================================
# 14 - Avaliacao Challenger vs Champion (ciclo de vida)
# Precisa do server MLflow (passo 6) no ar. Recomenda promover ou manter.
# =====================================================================

$env:MLFLOW_TRACKING_URI = "http://127.0.0.1:5000"

# Sem argumento: challenger = versao mais recente.
uv run python src/evaluate.py

# Para comparar uma versao especifica:  uv run python src/evaluate.py 6
# Se o challenger vencer, promova:        uv run python src/promote.py <versao>
