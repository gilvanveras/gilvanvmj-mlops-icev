"""Avaliacao Challenger vs Champion (Unidade 4 / ciclo de vida).

Compara o modelo @champion vigente com um CHALLENGER (por padrao, a versao
mais recente registrada) na MESMA fatia de validacao e recomenda promover ou
manter, com base em f1_macro. E o passo que decide o ciclo de vida do modelo.

Uso:
    uv run python src/evaluate.py        # challenger = versao mais recente
    uv run python src/evaluate.py 6      # challenger = versao 6
"""

import os
import sys
from pathlib import Path

import mlflow.sklearn
import pandas as pd
from mlflow import MlflowClient
from sklearn.metrics import f1_score
from sklearn.model_selection import train_test_split

MODEL_NAME = "wine-classifier"
DATA = Path("data/processed/wine.parquet")


def _f1(model, X, y) -> float:
    return f1_score(y, model.predict(X), average="macro")


def main() -> None:
    uri = os.getenv("MLFLOW_TRACKING_URI", "http://127.0.0.1:5000")
    mlflow.set_tracking_uri(uri)
    client = MlflowClient(tracking_uri=uri)

    df = pd.read_parquet(DATA)
    X, y = df.drop(columns=["y"]), df["y"]
    _, X_val, _, y_val = train_test_split(
        X, y, test_size=0.2, random_state=42, stratify=y
    )

    # Champion vigente
    champ = client.get_model_version_by_alias(MODEL_NAME, "champion")
    champ_model = mlflow.sklearn.load_model(f"models:/{MODEL_NAME}@champion")
    f1_champ = _f1(champ_model, X_val, y_val)

    # Challenger: versao via argumento, ou a mais recente registrada
    if len(sys.argv) > 1:
        chal_v = sys.argv[1]
    else:
        versoes = client.search_model_versions(f"name='{MODEL_NAME}'")
        chal_v = str(max(int(v.version) for v in versoes))
    chal_model = mlflow.sklearn.load_model(f"models:/{MODEL_NAME}/{chal_v}")
    f1_chal = _f1(chal_model, X_val, y_val)

    print(f"[evaluate] champion   v{champ.version}: f1_macro={f1_champ:.4f}")
    print(f"[evaluate] challenger v{chal_v}: f1_macro={f1_chal:.4f}")

    if f1_chal > f1_champ:
        print(f"[evaluate] RECOMENDACAO: promover v{chal_v} (challenger superou).")
        print(f"           uv run python src/promote.py {chal_v}")
    else:
        print("[evaluate] RECOMENDACAO: manter o champion (challenger nao superou).")


if __name__ == "__main__":
    main()
