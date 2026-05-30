# Makefile - atalhos do curso MLOps.  Uso:  make <alvo>   (ex.: make start)
# Requer GNU make + bash (Linux/macOS; ou Windows via git-bash/choco).
# Windows sem make? Use o menu:  .\scripts_windows\start.ps1
#
# Recipes inline (target: ; cmd) para evitar problemas de TAB.

.DEFAULT_GOAL := help
.PHONY: help start start-windows start-linux setup validate repo bootstrap data-dvc pipeline server train promote serve test docker ci compose-up drift evaluate

help: ; @echo "Sabado: start-windows | start-linux | setup | validate | repo | bootstrap | data-dvc | pipeline | server | train | promote | serve | test | docker"; echo "Domingo: ci | compose-up | drift | evaluate"

# Menu interativo por SO
start-windows: ; @powershell -ExecutionPolicy Bypass -File scripts_windows/start.ps1
start-linux:   ; @bash scripts_linux/start.sh
# 'start' detecta o SO (Windows_NT no Windows; senao bash)
start: ; @if [ "$$OS" = "Windows_NT" ]; then powershell -ExecutionPolicy Bypass -File scripts_windows/start.ps1; else bash scripts_linux/start.sh; fi
setup:     ; @bash scripts_linux/00_setup.sh
validate:  ; @uv run python -c "import fastapi, uvicorn, evidently, mlflow, sklearn; print('OK imports')"
repo:      ; @bash scripts_linux/01_repo.sh
bootstrap: ; @bash scripts_linux/02_bootstrap_uv.sh
data-dvc:  ; @bash scripts_linux/03_data_dvc.sh
pipeline:  ; @bash scripts_linux/04_pipeline_data.sh
server:    ; @bash scripts_linux/05_mlflow_server.sh
train:     ; @bash scripts_linux/06_train.sh
promote:   ; @bash scripts_linux/07_promote.sh
serve:     ; @bash scripts_linux/08_serve.sh
test:      ; @bash scripts_linux/09_test_predict.sh
docker:    ; @bash scripts_linux/10_docker.sh
# Domingo
ci:         ; @bash scripts_linux/11_ci_local.sh
compose-up: ; @bash scripts_linux/12_compose_up.sh
drift:      ; @bash scripts_linux/13_drift_report.sh
evaluate:   ; @bash scripts_linux/14_evaluate.sh
