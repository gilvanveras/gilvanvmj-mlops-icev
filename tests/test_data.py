"""Testes da etapa de dados. Não dependem de arquivos nem de servidor."""

import pandas as pd
from sklearn.datasets import load_wine

from src.data import normalize_columns


def test_normalize_remove_barra():
    df = pd.DataFrame({"od280/od315_of_diluted_wines": [1.0], "alcohol": [13.0]})
    out = normalize_columns(df)
    assert "od280_od315_of_diluted_wines" in out.columns
    assert not any("/" in c for c in out.columns)


def test_wine_tem_13_features_apos_normalizar():
    w = load_wine(as_frame=True)
    df = normalize_columns(w.data)
    assert df.shape[1] == 13
    assert "od280_od315_of_diluted_wines" in df.columns
