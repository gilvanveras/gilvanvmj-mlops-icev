"""Microsserviço de serving (Model Serving).

Carrega o modelo 'wine-classifier@champion' UMA vez, no startup do servidor
(via lifespan), e o mantém em memória num dict de estado compartilhado entre
as requisições. Expõe /health (liveness/readiness) e /predict.

O tracking URI vem de MLFLOW_TRACKING_URI:
  - local:  http://127.0.0.1:5000
  - docker: http://host.docker.internal:5000  (ver ROTEIRO.md, passo Docker)
"""

import json
import os
import time
import uuid
from contextlib import asynccontextmanager
from datetime import datetime, timezone
from pathlib import Path

import mlflow.sklearn
import pandas as pd
from fastapi import FastAPI
from pydantic import BaseModel

mlflow.set_tracking_uri(os.getenv("MLFLOW_TRACKING_URI", "http://127.0.0.1:5000"))

# Log de predicoes (Unidade 4): cada chamada vira uma linha JSON, materia-prima
# para monitoramento de drift e feedback loops.
LOG_PATH = Path("logs/predictions.jsonl")

state: dict = {}


# Contrato de entrada: as 13 features do dataset Wine (nomes já normalizados
# em src/data.py, por isso usamos underscore em od280_od315...).
class WineInput(BaseModel):
    alcohol: float
    malic_acid: float
    ash: float
    alcalinity_of_ash: float
    magnesium: float
    total_phenols: float
    flavanoids: float
    nonflavanoid_phenols: float
    proanthocyanins: float
    color_intensity: float
    hue: float
    od280_od315_of_diluted_wines: float
    proline: float


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Carrega o modelo uma única vez na inicialização.
    state["model"] = mlflow.sklearn.load_model("models:/wine-classifier@champion")
    yield
    state.clear()


app = FastAPI(title="wine-classifier", lifespan=lifespan)


@app.get("/health")
def health():
    return {"status": "ok"}


def _log_predicao(payload: dict, prediction: int, latency_ms: float) -> None:
    """Registra a predição (request_id, timestamp, modelo, payload, latência)."""
    LOG_PATH.parent.mkdir(parents=True, exist_ok=True)
    registro = {
        "request_id": str(uuid.uuid4()),
        "ts": datetime.now(timezone.utc).isoformat(),
        "model": "wine-classifier@champion",
        "payload": payload,
        "prediction": prediction,
        "latency_ms": latency_ms,
    }
    with LOG_PATH.open("a", encoding="utf-8") as f:
        f.write(json.dumps(registro) + "\n")


@app.post("/predict")
def predict(data: WineInput):
    t0 = time.perf_counter()
    # O Pipeline embute o StandardScaler, então basta passar os dados crus.
    input_df = pd.DataFrame([data.model_dump()])
    prediction = int(state["model"].predict(input_df)[0])
    latency_ms = round((time.perf_counter() - t0) * 1000, 2)
    _log_predicao(data.model_dump(), prediction, latency_ms)
    return {"prediction": prediction}
