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
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=utf-8 \
    MLFLOW_TRACKING_URI="http://host.docker.internal:5000"
# MLFLOW_TRACKING_URI aponta para o host no Docker Desktop (Windows/Mac).
# No docker-compose, é sobrescrito para http://mlflow:5000 (rede interna).
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
    CMD python -c "import urllib.request,sys; sys.exit(0 if urllib.request.urlopen('http://localhost:8000/health').status==200 else 1)"
CMD ["uvicorn", "src.api.main:app", "--host", "0.0.0.0", "--port", "8000"]
