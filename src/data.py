"""Etapa 'data' do pipeline.

Lê o dataset bruto (data/raw/wine.parquet), limpa os nomes das colunas e
grava a versão processada (data/processed/wine.parquet).

Por que limpar nomes aqui? O dataset Wine traz a coluna
'od280/od315_of_diluted_wines' com uma BARRA, que não é um identificador
Python válido (a API com Pydantic não consegue ter um campo com '/'). Se o
modelo for treinado com a barra e a API enviar com underscore, o sklearn
quebra com "feature names should match". Resolvemos na FRONTEIRA DE DADOS:
normalizamos o nome uma única vez, e daqui pra frente train e API concordam.
"""

from pathlib import Path

import pandas as pd

RAW = Path("data/raw/wine.parquet")
OUT = Path("data/processed/wine.parquet")


def normalize_columns(df: pd.DataFrame) -> pd.DataFrame:
    """Troca '/' por '_' nos nomes das colunas (função pura e testável)."""
    out = df.copy()
    out.columns = [c.replace("/", "_") for c in out.columns]
    return out


def main() -> None:
    df = pd.read_parquet(RAW)

    # '/' -> '_' para que treino e serving usem o mesmo nome de feature.
    df = normalize_columns(df)

    OUT.parent.mkdir(parents=True, exist_ok=True)
    df.to_parquet(OUT, index=False)
    print(f"[data] {RAW} -> {OUT}  shape={df.shape}")


if __name__ == "__main__":
    main()
