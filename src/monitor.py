"""Monitoramento de Data Drift com Evidently (Unidade 4).

Compara uma janela de REFERENCIA (dados de treino) com uma janela ATUAL
(producao) e gera um relatorio HTML. Para a demo, simulamos 'producao'
deslocando algumas features (data drift = P(X) muda); troque por dados reais
logados quando tiver (ver logs/predictions.jsonl da API).

API do Evidently 0.7: report.run(...) retorna um Snapshot, e o .save_html()
e chamado NO RESULTADO (diferente do snippet antigo report.save_html()).
"""

from pathlib import Path

import pandas as pd
from evidently import Report
from evidently.presets import DataDriftPreset

PROCESSED = Path("data/processed/wine.parquet")
OUT_HTML = Path("reports/drift_report.html")


def carregar_janelas() -> tuple[pd.DataFrame, pd.DataFrame]:
    """Referencia = primeira metade; Atual = segunda metade com drift simulado."""
    df = pd.read_parquet(PROCESSED).drop(columns=["y"])
    meio = len(df) // 2
    ref = df.iloc[:meio].copy()
    cur = df.iloc[meio:].copy()
    # Drift artificial (remova quando usar dados de producao reais):
    cur["alcohol"] = cur["alcohol"] + 2.0
    cur["proline"] = cur["proline"] * 1.4
    return ref, cur


def main() -> None:
    ref, cur = carregar_janelas()

    report = Report(metrics=[DataDriftPreset()])
    snapshot = report.run(reference_data=ref, current_data=cur)

    OUT_HTML.parent.mkdir(parents=True, exist_ok=True)
    snapshot.save_html(str(OUT_HTML))
    print(f"[monitor] relatorio de drift salvo em {OUT_HTML}")

    # Resumo defensivo (a estrutura do dict varia entre versoes do Evidently).
    try:
        d = snapshot.dict()
        print(f"[monitor] metricas calculadas: {len(d.get('metrics', []))}")
    except Exception:
        pass
    print("[monitor] abra o HTML no navegador para inspecionar o drift por feature.")


if __name__ == "__main__":
    main()
