#!/usr/bin/env bash
# =====================================================================
# 01 - Identidade Git + repositorio no GitHub  [Linux/macOS]
# Rode da SUA PASTA DE TRABALHO (ex.: ~/projetos). Cria e entra no repo.
# =====================================================================
set -euo pipefail

INICIAIS="gilvanvmj"          # <-- TROQUE pelas suas iniciais
REPO="${INICIAIS}-mlops-icev"

echo "==> Autenticando no GitHub (interativo)..."
gh auth login
gh auth status

echo "==> Configurando identidade do Git..."
git config --global user.name  "Gilvan Veras"          # <-- ajuste
git config --global user.email "gilvanvmj@gmail.com"   # <-- ajuste

echo "==> Criando e clonando o repositorio ${REPO}..."
gh repo create "${REPO}" --public --clone
cd "${REPO}"

echo
echo "==> Repo criado. Voce esta em: $(pwd)"
echo "PROXIMO: copie as pastas scripts_linux/ e src/ (e dvc.yaml, Dockerfile) para ca"
echo "e rode ./scripts_linux/02_bootstrap_uv.sh de DENTRO deste repositorio."
