# wine-classifier — MLOps ponta a ponta (ICEV)

Projeto-base do curso de **MLOps**: leva um classificador do dataset *Wine* do
notebook à produção e o mantém lá — com ambiente reprodutível, versionamento de
dados, rastreio de experimentos, serving HTTP, CI/CD, deploy em container e
monitoramento de drift.

## Stack

`uv` · `Git` + `DVC` · `MLflow` (tracking + registry) · `scikit-learn` ·
`FastAPI` + `Uvicorn` · `Docker` / `docker compose` · `GitHub Actions` ·
`Evidently` · `pytest` + `ruff`.

## Fluxo (espinha dorsal)

```
raw → data.py → processed → train.py → MLflow Registry → promote.py → @champion
      → FastAPI (/predict) → Docker
Domingo: CI/CD (Actions) · docker compose · drift (Evidently) · challenger × champion
```

## Começar rápido (menu interativo)

Não precisa decorar comandos — abra o menu numérico e escolha cada passo:

```powershell
# Windows
.\scripts_windows\start.ps1
```
```bash
# Linux / macOS
./scripts_linux/start.sh
```

Com `make`: `make start-windows` ou `make start-linux`. O passo a passo completo,
comentado e com checkpoints, está em **[ROTEIRO.md](ROTEIRO.md)**.

## Pré-requisitos

`uv`, Python 3.11, Git, Docker (e `gh` opcional). Veja o passo 0 do
[ROTEIRO.md](ROTEIRO.md) ou rode `00_setup` pelo menu.

> O serving carrega `models:/wine-classifier@champion`, cujos artefatos são
> resolvidos via **servidor MLflow** — suba-o (passo 6 / opção 6 do menu) antes
> de treinar ou servir.

## Estrutura

```
src/        data.py · train.py · promote.py · evaluate.py · monitor.py · api/main.py
tests/      testes mínimos (gate do CI)
data/       raw/ (DVC) · processed/ (saída do pipeline)
scripts_windows/ · scripts_linux/   passo a passo 00–14 + start (menu)
.github/workflows/ci.yml            CI: lint+test + build-push (GHCR)
dvc.yaml · Dockerfile · docker-compose.yml · Makefile
notebooks/01_mlflow_explore.ipynb   comparação de runs (interativo)
```

## Comandos úteis (com `make`)

| Alvo | Faz |
|---|---|
| `make pipeline` | gera `data/processed` (`src/data.py`) |
| `make server` | sobe o MLflow (bloqueante) |
| `make train` / `make promote` | treina e registra / promove `@champion` |
| `make serve` | sobe a API FastAPI (bloqueante) |
| `make ci` | lint + testes (espelha o CI) |
| `make compose-up` | MLflow + API via `docker compose` |
| `make drift` | relatório de Data Drift (Evidently) |
| `make evaluate` | challenger × champion |

## Curso

- **Encontro 1 (sábado):** ambientes reprodutíveis, Git+DVC, MLflow, Pipeline
  sklearn, serving FastAPI, Docker.
- **Encontro 2 (domingo):** CI/CD (GitHub Actions), estratégias de rollout,
  monitoramento (drift, log de predições, feedback loops), ciclo de vida.

Slides: `Slides_Sabado.pptx` e `Slides_Domingo.pptx`.
