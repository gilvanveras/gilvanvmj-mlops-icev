from contextlib import asynccontextmanager
from fastapi import FastAPI
from pydantic import BaseModel
import pandas as pd
import mlflow
import mlflow.sklearn

mlflow.set_tracking_uri("http://127.0.0.1:5000")

state = {}

@asynccontextmanager
async def lifespan(app: FastAPI):
    state["model"] = mlflow.sklearn.load_model(
        "models:/wine-classifier@champion"
    )
    yield
    state.clear()

app = FastAPI(title="wine-classifier", lifespan=lifespan)

@app.get("/health")
def health():
    # curl http://127.0.0.1:8000/health
    return {"status": "ok"}


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


@app.post("/predict")
def predict(data: WineInput):
    # curl -X POST http://127.0.0.1:8000/predict \
    #   -H "Content-Type: application/json" \
    #   -d '{"alcohol":13.2,"malic_acid":1.78,"ash":2.14,"alcalinity_of_ash":11.2,
    #        "magnesium":100.0,"total_phenols":2.65,"flavanoids":2.76,
    #        "nonflavanoid_phenols":0.26,"proanthocyanins":1.28,"color_intensity":4.38,
    #        "hue":1.05,"od280_od315_of_diluted_wines":3.4,"proline":1050.0}'
    # => {"prediction": 0}
    df = pd.DataFrame([data.model_dump()])
    pred = state["model"].predict(df)
    return {"prediction": int(pred[0])}
