# scripts_windows/ — passo a passo executável (PowerShell)

Cada script é **um passo** do curso, numerado a partir de `00`. Rode na ordem.
São o par executável do `ROTEIRO.md` (o roteiro **explica**; os scripts **executam**).

> **Linux/macOS?** Use a pasta irmã `scripts_linux/` (mesmos passos em bash `.sh`).

## Menu interativo (recomendado)

Em vez de decorar os nomes, abra o menu numérico e escolha o passo:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\scripts_windows\start.ps1
```

> Com `make` instalado: `make start-windows`. Menu: `0` setup, `1` validar
> ambiente, `2`–`11` = passos `01`–`10`; `q` sai.

## Como executar um passo isolado

Por padrão o Windows bloqueia `.ps1`. Libere só nesta sessão e rode:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\scripts_windows\00_setup.ps1
```

> Alternativa por script: `powershell -ExecutionPolicy Bypass -File .\scripts_windows\00_setup.ps1`

## Ordem dos passos

| # | Script | Onde roda | Observação |
|---|--------|-----------|------------|
| 00 | `00_setup.ps1` | pasta de trabalho | instala uv, gh; checa versões (uma vez por máquina) |
| 01 | `01_repo.ps1` | pasta de trabalho | gh auth, identidade Git, cria e clona o repo |
| 02 | `02_bootstrap_uv.ps1` | **raiz do repo** | uv init, dependências, .gitignore |
| 03 | `03_data_dvc.ps1` | raiz do repo | dvc init, remote, dataset bruto, push |
| 04 | `04_pipeline_data.ps1` | raiz do repo | raw → processed (`src/data.py`) |
| 05 | `05_mlflow_server.ps1` | raiz do repo · **Terminal 1** | **bloqueante** — deixe aberto |
| 06 | `06_train.ps1` | raiz do repo · Terminal 2 | treina e registra `wine-classifier` |
| 07 | `07_promote.ps1` | raiz do repo · Terminal 2 | promove a melhor versão a `@champion` |
| 08 | `08_serve.ps1` | raiz do repo · **Terminal 2** | **bloqueante** — sobe a API |
| 09 | `09_test_predict.ps1` | raiz do repo · Terminal 3 | testa `/health` e `/predict` |
| 10 | `10_docker.ps1` | raiz do repo | build + run da imagem |

### Domingo (Encontro 2) — CI/CD, deploy, monitoramento, ciclo de vida

| # | Script | Onde roda | Observação |
|---|--------|-----------|------------|
| 11 | `11_ci_local.ps1` | raiz do repo | lint + testes (espelha o job `quality` do CI) |
| 12 | `12_compose_up.ps1` | raiz do repo | **bloqueante** — `docker compose up` (MLflow + API) |
| 13 | `13_drift_report.ps1` | raiz do repo | relatório de Data Drift (Evidently) → `reports/` |
| 14 | `14_evaluate.ps1` | raiz do repo · server no ar | challenger vs champion + recomendação |

> Artefatos de domingo no repo: `.github/workflows/ci.yml`, `docker-compose.yml`,
> `src/monitor.py`, `src/evaluate.py`, `tests/`, e log de predições em
> `logs/predictions.jsonl` (gerado pela API).

## Bootstrap (importante)

`00` e `01` rodam **antes** do repo existir — rode-os de uma pasta de trabalho
(ex.: `b:\GitProjects`). Depois que `01` criar e entrar no repo, **copie as pastas
`scripts_windows/` e `src/` (e os arquivos `dvc.yaml`, `Dockerfile`) para dentro dele** e
siga de `02` em diante de dentro do repositório.

## Dois (ou três) terminais

- **Terminal 1:** `05_mlflow_server.ps1` (fica rodando o tempo todo).
- **Terminal 2:** `06`, `07`, depois `08_serve.ps1` (fica rodando).
- **Terminal 3:** `09_test_predict.ps1` (enquanto o `08` serve).

## Iniciais

Os scripts `01` e `10` têm uma linha `$INICIAIS = "gilvanvmj"` no topo — **troque
pelas suas** uma vez em cada.
