#!/usr/bin/env bash
# =====================================================================
# 00 - Instalacao das ferramentas (uma vez por maquina)  [Linux/macOS]
# Rode em QUALQUER pasta.
# =====================================================================
set -euo pipefail

echo "==> Instalando uv (gerenciador de Python)..."
curl -LsSf https://astral.sh/uv/install.sh | sh
# Disponibiliza o uv nesta sessao (o instalador o coloca em ~/.local/bin)
export PATH="$HOME/.local/bin:$PATH"

echo "==> Instalando GitHub CLI (gh)..."
if command -v apt >/dev/null 2>&1; then
  sudo mkdir -p -m 755 /etc/apt/keyrings
  wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt update && sudo apt install gh -y
elif command -v brew >/dev/null 2>&1; then
  brew install gh        # macOS
else
  echo "Instale o gh manualmente: https://github.com/cli/cli#installation"
fi

echo "==> Git e Docker: instale pelo gerenciador do seu sistema se faltarem."

echo
echo "==> Checkpoint de versoes (esperado ao lado):"
uv --version              # 0.5+
uv python install 3.11    # baixa o interpretador se faltar
uv run python --version   # 3.11.x
git --version             # 2.40+
docker --version          # 24+
docker compose version    # v2.20+
gh --version              # opcional
