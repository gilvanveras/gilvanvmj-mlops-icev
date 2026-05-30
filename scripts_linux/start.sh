#!/usr/bin/env bash
# =====================================================================
# start.sh - Menu interativo do curso (Linux/macOS / bash)
# Rode da raiz do repo:  ./scripts_linux/start.sh
# Menu: 0=setup, 1=validar ambiente, 2..11 = passos 01..10.
# =====================================================================

# Trabalha sempre a partir da RAIZ do repo (pai desta pasta).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.." || exit 1

run_step() {
  local f="$SCRIPT_DIR/$1"
  if [ -f "$f" ]; then bash "$f"; else echo "Script nao encontrado: $f"; fi
}

validate() {
  echo "==> Validando ambiente..."
  uv --version
  uv run python --version
  git --version
  docker --version
  gh --version || true
  uv run python -c "import fastapi, uvicorn, evidently, mlflow, sklearn; print('OK imports (fastapi/uvicorn/evidently/mlflow/sklearn)')"
}

show_menu() {
  echo
  echo "==== Curso MLOps - Wine Classifier (Linux/macOS) ===="
  echo "  0) Setup: instalar ferramentas (uma vez)"
  echo "  1) Validar ambiente"
  echo "  2) Criar repo no GitHub"
  echo "  3) Bootstrap uv (deps + .gitignore)"
  echo "  4) Dados + DVC (raw + push)"
  echo "  5) Pipeline: raw -> processed"
  echo "  6) MLflow server          [Terminal 1 - BLOQUEANTE]"
  echo "  7) Treinar (registra wine-classifier)"
  echo "  8) Promover @champion"
  echo "  9) Servir API             [BLOQUEANTE]"
  echo " 10) Testar /health e /predict"
  echo " 11) Docker build + run"
  echo "  --- Domingo: CI/CD, deploy, monitoramento, ciclo de vida ---"
  echo " 12) CI local (lint + testes)"
  echo " 13) docker compose up      [BLOQUEANTE]"
  echo " 14) Drift report (Evidently)"
  echo " 15) Avaliar challenger vs champion"
  echo "  q) Sair"
}

while true; do
  show_menu
  read -rp "Opcao: " opt
  case "$opt" in
    0)  run_step 00_setup.sh ;;
    1)  validate ;;
    2)  run_step 01_repo.sh ;;
    3)  run_step 02_bootstrap_uv.sh ;;
    4)  run_step 03_data_dvc.sh ;;
    5)  run_step 04_pipeline_data.sh ;;
    6)  run_step 05_mlflow_server.sh ;;
    7)  run_step 06_train.sh ;;
    8)  run_step 07_promote.sh ;;
    9)  run_step 08_serve.sh ;;
    10) run_step 09_test_predict.sh ;;
    11) run_step 10_docker.sh ;;
    12) run_step 11_ci_local.sh ;;
    13) run_step 12_compose_up.sh ;;
    14) run_step 13_drift_report.sh ;;
    15) run_step 14_evaluate.sh ;;
    q|Q) break ;;
    *)  echo "Opcao invalida: $opt" ;;
  esac
  if [ "$opt" != "q" ] && [ "$opt" != "Q" ]; then
    read -rp $'\nPressione Enter para voltar ao menu...' _
  fi
done
