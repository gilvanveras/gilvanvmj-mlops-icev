# Dockerfile multi-stage enxuto.
#
# stage 1 (builder): instala dependências com uv num venv isolado.
# stage 2 (runtime): copia só o venv + o código, imagem final pequena.

# ---- stage 1: build ----
FROM python:3.11-slim AS builder
RUN pip install --no-cache-dir uv
WORKDIR /app
COPY pyproject.toml uv.lock ./
# --frozen: respeita o lock; --no-dev: não instala pytest/ruff em produção.
RUN uv sync --frozen --no-dev

# ---- stage 2: runtime ----
FROM python:3.11-slim
WORKDIR /app
COPY --from=builder /app/.venv /app/.venv
COPY src/ ./src/
ENV PATH="/app/.venv/bin:$PATH"
# O serving precisa falar com o MLflow do HOST. Em Docker Desktop, o host é
# acessível por host.docker.internal. Pode ser sobrescrito no `docker run`.
ENV MLFLOW_TRACKING_URI="http://host.docker.internal:5000"
EXPOSE 8000
CMD ["uvicorn", "src.api.main:app", "--host", "0.0.0.0", "--port", "8000"]
