"""Etapa 'promote': escolhe a melhor versão registrada de 'wine-classifier'
e aponta o alias @champion para ela.

Este passo costuma faltar nos tutoriais: treinar e registrar NÃO coloca o
modelo em produção. O serving carrega 'models:/wine-classifier@champion', e
esse alias só existe se alguém (ou um job) promover uma versão. Aqui a
promoção é por mérito: maior f1_macro vence (padrão Champion vs. Challenger).

Uso:
    uv run python src/promote.py            # promove a melhor versão por f1
    uv run python src/promote.py 3          # força a versão 3
"""

import os
import sys

from mlflow import MlflowClient

MODEL_NAME = "wine-classifier"
ALIAS = "champion"
METRIC = "f1_macro"


def main() -> None:
    client = MlflowClient(
        tracking_uri=os.getenv("MLFLOW_TRACKING_URI", "http://127.0.0.1:5000")
    )

    if len(sys.argv) > 1:
        version = sys.argv[1]
    else:
        # Escolhe a versão cujo run tem o maior f1_macro.
        versions = client.search_model_versions(f"name='{MODEL_NAME}'")
        best = max(
            versions,
            key=lambda v: client.get_run(v.run_id).data.metrics.get(METRIC, -1.0),
        )
        version = best.version

    client.set_registered_model_alias(MODEL_NAME, ALIAS, version)
    f1 = client.get_run(
        client.get_model_version(MODEL_NAME, version).run_id
    ).data.metrics.get(METRIC)
    print(f"[promote] {MODEL_NAME}@{ALIAS} -> v{version}  ({METRIC}={f1})")


if __name__ == "__main__":
    main()
