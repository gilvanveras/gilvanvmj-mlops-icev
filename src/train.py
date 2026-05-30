"""Etapa 'train' do pipeline.

Lê data/processed/wine.parquet, treina um Pipeline scikit-learn
(StandardScaler + RandomForest), rastreia tudo no MLflow e registra o
resultado no Model Registry como 'wine-classifier'.

O Pipeline embute o pré-processamento, então o MESMO objeto que treina é o
que vai pra produção — sem risco de o serving esquecer de escalar os dados
(training/serving skew). É o padrão 'modelo = pipeline inteiro'.

O tracking URI vem da env var MLFLOW_TRACKING_URI (default: servidor local),
para o mesmo script funcionar na sua máquina e no CI sem edição.
"""

import os
import sys
from pathlib import Path

import mlflow
import mlflow.sklearn
import pandas as pd

# No Windows o console usa cp1252 e o MLflow imprime emojis (🏃) ao fim do run,
# o que derruba o script com UnicodeEncodeError. Forçar UTF-8 evita isso.
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")
from sklearn.compose import ColumnTransformer
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import f1_score
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler

DATA = Path("data/processed/wine.parquet")
MODEL_NAME = "wine-classifier"


def main() -> None:
    mlflow.set_tracking_uri(os.getenv("MLFLOW_TRACKING_URI", "http://127.0.0.1:5000"))
    mlflow.set_experiment(MODEL_NAME)

    df = pd.read_parquet(DATA)
    X = df.drop(columns=["y"])
    y = df["y"]
    X_train, X_val, y_train, y_val = train_test_split(
        X, y, test_size=0.2, random_state=42, stratify=y
    )

    # Todas as 13 colunas do Wine são numéricas.
    num_features = X_train.columns.tolist()
    pre = ColumnTransformer([("num", StandardScaler(), num_features)])

    params = {"n_estimators": 200, "max_depth": 8, "random_state": 42}
    pipe = Pipeline(
        [
            ("preprocess", pre),
            ("model", RandomForestClassifier(**params)),
        ]
    )

    with mlflow.start_run(run_name="rf-pipeline") as run:
        mlflow.log_params(params)
        pipe.fit(X_train, y_train)

        f1 = f1_score(y_val, pipe.predict(X_val), average="macro")
        mlflow.log_metric("f1_macro", f1)

        # name= é o parâmetro do MLflow 3.x (substitui o antigo artifact_path).
        mlflow.sklearn.log_model(
            sk_model=pipe,
            name="model",
            registered_model_name=MODEL_NAME,
        )
        print(f"[train] run_id={run.info.run_id}  f1_macro={f1:.4f}")


if __name__ == "__main__":
    main()
