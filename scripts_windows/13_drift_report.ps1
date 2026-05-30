# =====================================================================
# 13 - Relatorio de Data Drift com Evidently (Unidade 4)
# Gera reports/drift_report.html comparando treino vs 'producao' (simulada).
# =====================================================================

uv run python src/monitor.py

$html = "reports/drift_report.html"
if (Test-Path $html) {
    Write-Host "==> Abrindo $html no navegador..." -ForegroundColor Green
    Start-Process (Resolve-Path $html)
}
