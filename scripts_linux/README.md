# scripts_linux/ — passo a passo executável (bash)

Cada script é **um passo** do curso, numerado a partir de `00`. Rode na ordem.
São o par executável do `ROTEIRO.md` (o roteiro **explica**; os scripts **executam**).

> **Windows?** Use a pasta irmã `scripts_windows/` (mesmos passos em PowerShell `.ps1`).

## Menu interativo (recomendado)

Em vez de decorar os nomes, abra o menu numérico e escolha o passo:

```bash
chmod +x scripts_linux/*.sh        # uma vez
./scripts_linux/start.sh
```

> Com `make` instalado: `make start-linux`. Menu: `0` setup, `1` validar
> ambiente, `2`–`11` = passos `01`–`10`; `q` sai.

## Como executar um passo isolado

```bash
./scripts_linux/00_setup.sh
```

> Ou: `bash scripts_linux/00_setup.sh`

## Ordem dos passos

| # | Script | Onde roda | Observação |
|---|--------|-----------|------------|
| 00 | `00_setup.sh` | pasta de trabalho | instala uv, gh; checa versões (uma vez por máquina) |
| 01 | `01_repo.sh` | pasta de trabalho | gh auth, identidade Git, cria e clona o repo |
| 02 | `02_bootstrap_uv.sh` | **raiz do repo** | uv init, dependências, .gitignore |
| 03 | `03_data_dvc.sh` | raiz do repo | dvc init, remote, dataset bruto, push |
| 04 | `04_pipeline_data.sh` | raiz do repo | raw → processed (`src/data.py`) |
| 05 | `05_mlflow_server.sh` | raiz do repo · **Terminal 1** | **bloqueante** — deixe aberto |
| 06 | `06_train.sh` | raiz do repo · Terminal 2 | treina e registra `wine-classifier` |
| 07 | `07_promote.sh` | raiz do repo · Terminal 2 | promove a melhor versão a `@champion` |
| 08 | `08_serve.sh` | raiz do repo · **Terminal 2** | **bloqueante** — sobe a API |
| 09 | `09_test_predict.sh` | raiz do repo · Terminal 3 | testa `/health` e `/predict` (curl) |
| 10 | `10_docker.sh` | raiz do repo | build + run da imagem |

### Domingo (Encontro 2) — CI/CD, deploy, monitoramento, ciclo de vida

| # | Script | Onde roda | Observação |
|---|--------|-----------|------------|
| 11 | `11_ci_local.sh` | raiz do repo | lint + testes (espelha o job `quality` do CI) |
| 12 | `12_compose_up.sh` | raiz do repo | **bloqueante** — `docker compose up` (MLflow + API) |
| 13 | `13_drift_report.sh` | raiz do repo | relatório de Data Drift (Evidently) → `reports/` |
| 14 | `14_evaluate.sh` | raiz do repo · server no ar | challenger vs champion + recomendação |

> Artefatos de domingo no repo: `.github/workflows/ci.yml`, `docker-compose.yml`,
> `src/monitor.py`, `src/evaluate.py`, `tests/`, e log de predições em
> `logs/predictions.jsonl` (gerado pela API).

## Bootstrap (importante)

`00` e `01` rodam **antes** do repo existir — rode-os de uma pasta de trabalho
(ex.: `~/projetos`). Depois que `01` criar e entrar no repo, **copie as pastas
`scripts_linux/` e `src/` (e os arquivos `dvc.yaml`, `Dockerfile`) para dentro
dele** e siga de `02` em diante de dentro do repositório.

## Dois (ou três) terminais

- **Terminal 1:** `05_mlflow_server.sh` (fica rodando o tempo todo).
- **Terminal 2:** `06`, `07`, depois `08_serve.sh` (fica rodando).
- **Terminal 3:** `09_test_predict.sh` (enquanto o `08` serve).

## Diferenças em relação ao `scripts_windows/`

- **gh:** instalado via `apt` (Debian/Ubuntu) ou `brew` (macOS).
- **/predict:** testado com `curl` (em vez de `Invoke-RestMethod`).
- **Docker:** usa `--add-host=host.docker.internal:host-gateway`, porque no
  Docker Linux esse host não existe por padrão (diferente do Docker Desktop).

## Iniciais

Os scripts `01` e `10` têm uma linha `INICIAIS="gilvanvmj"` no topo — **troque
pelas suas** uma vez em cada.
