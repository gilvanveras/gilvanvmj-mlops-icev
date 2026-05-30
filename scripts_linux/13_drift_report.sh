#!/usr/bin/env bash
# =====================================================================
# 13 - Relatorio de Data Drift com Evidently (Unidade 4)
# Gera reports/drift_report.html comparando treino vs 'producao' (simulada).
# =====================================================================
set -euo pipefail

uv run python src/monitor.py

HTML="reports/drift_report.html"
if [ -f "$HTML" ]; then
  echo "==> Relatorio em $HTML"
  if command -v xdg-open >/dev/null 2>&1; then xdg-open "$HTML"
  elif command -v open >/dev/null 2>&1; then open "$HTML"   # macOS
  fi
fi
