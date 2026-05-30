#!/usr/bin/env bash
# =====================================================================
# 11 - CI local (espelha o job 'quality' do .github/workflows/ci.yml)
# Roda os MESMOS gates que o GitHub Actions: lint + testes (fail fast).
# =====================================================================
set -euo pipefail

echo "==> ruff (lint)..."
uv run ruff check .

echo "==> pytest (testes)..."
uv run pytest -q

echo
echo "==> Se passou aqui, o job 'quality' do CI tambem passa."
