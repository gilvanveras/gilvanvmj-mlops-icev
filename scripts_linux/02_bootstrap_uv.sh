#!/usr/bin/env bash
# =====================================================================
# 02 - Bootstrap do projeto com uv (rode da RAIZ do repo)  [Linux/macOS]
# uv init UMA vez. Como a pasta ja existe (veio do gh clone), usamos 'uv init .'
# =====================================================================
set -euo pipefail

if [ -f pyproject.toml ]; then
  echo "pyproject.toml ja existe - pulando 'uv init'."
else
  uv init .
fi

uv python pin 3.11

echo "==> Adicionando dependencias de runtime..."
uv add scikit-learn pandas pyarrow mlflow fastapi uvicorn dvc evidently

echo "==> Adicionando dependencias de desenvolvimento..."
uv add --dev pytest ruff

echo "==> Escrevendo .gitignore..."
cat > .gitignore <<'EOF'
.venv/
__pycache__/
.pytest_cache/
.ruff_cache/
EOF

echo
echo "==> Checkpoint do ambiente:"
uv run dvc --version    && echo "OK dvc"    || echo "FAIL dvc"
uv run mlflow --version && echo "OK mlflow" || echo "FAIL mlflow"
uv run python -c "import fastapi, uvicorn, evidently; print('OK fastapi+uvicorn+evidently')"

git add pyproject.toml uv.lock .gitignore README.md
git commit -m "chore: init uv project and lock dependencies"
git push -u origin main
