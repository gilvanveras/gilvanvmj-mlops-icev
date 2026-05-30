"""Testes do contrato da API. Importar o módulo NÃO carrega o modelo
(isso só acontece no lifespan), então roda no CI sem servidor MLflow."""

from src.api.main import WineInput


def test_wineinput_tem_13_campos():
    assert len(WineInput.model_fields) == 13


def test_wineinput_aceita_payload_valido():
    amostra = {nome: 1.0 for nome in WineInput.model_fields}
    obj = WineInput(**amostra)
    assert obj.alcohol == 1.0
    assert obj.od280_od315_of_diluted_wines == 1.0
