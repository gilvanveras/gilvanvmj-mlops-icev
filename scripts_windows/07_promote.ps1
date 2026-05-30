# =====================================================================
# 07 - Promover o Champion (TERMINAL 2)
# Registrar NAO poe em producao. O serving carrega wine-classifier@champion,
# e esse alias so existe depois deste passo.
# =====================================================================

$env:MLFLOW_TRACKING_URI = "http://127.0.0.1:5000"

# Sem argumento: promove a melhor versao por f1_macro.
uv run python src/promote.py

# Para forcar uma versao especifica:  uv run python src/promote.py 3
