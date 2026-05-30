# =====================================================================
# 00 - Instalacao das ferramentas (uma vez por maquina)
# Rode em QUALQUER pasta. Alguns instaladores pedem confirmacao/admin.
# =====================================================================

Write-Host "==> Instalando uv (gerenciador de Python)..." -ForegroundColor Cyan
Invoke-RestMethod https://astral.sh/uv/install.ps1 | Invoke-Expression

# O instalador do uv adiciona ~\.local\bin ao PATH de NOVAS sessoes.
# Para usar uv JA nesta sessao, adicionamos manualmente:
$env:Path = "$env:USERPROFILE\.local\bin;$env:Path"

Write-Host "==> Instalando GitHub CLI (gh)..." -ForegroundColor Cyan
winget install --id GitHub.cli --accept-package-agreements --accept-source-agreements

Write-Host "==> Git e Docker Desktop: instale dos sites oficiais se ainda nao tiver." -ForegroundColor Yellow

Write-Host "`n==> Checkpoint de versoes (esperado ao lado):" -ForegroundColor Green
uv --version              # 0.5+
uv python install 3.11    # baixa o interpretador se faltar
uv run python --version   # 3.11.x
git --version             # 2.40+
docker --version          # 24+
docker compose version    # v2.20+
gh --version              # opcional

Write-Host "`nSe algum comando falhou, feche e reabra o terminal e rode este script de novo." -ForegroundColor Yellow
