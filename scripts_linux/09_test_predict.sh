#!/usr/bin/env bash
# =====================================================================
# 09 - Testar a API (TERMINAL 3, com o 08 servindo)  [Linux/macOS]
# Usa curl. Para JSON formatado, instale 'jq' (opcional).
# =====================================================================
set -euo pipefail

echo "==> GET /health"
curl -s http://127.0.0.1:8000/health
echo

echo "==> POST /predict"
curl -s -X POST http://127.0.0.1:8000/predict \
  -H 'Content-Type: application/json' \
  -d '{
    "alcohol": 13.0, "malic_acid": 2.0, "ash": 2.3, "alcalinity_of_ash": 15.6,
    "magnesium": 120, "total_phenols": 2.8, "flavanoids": 3.0,
    "nonflavanoid_phenols": 0.3, "proanthocyanins": 2.0, "color_intensity": 5.0,
    "hue": 1.0, "od280_od315_of_diluted_wines": 3.0, "proline": 1000
  }'
echo            # esperado: {"prediction":0}
