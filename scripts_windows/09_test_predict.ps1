# =====================================================================
# 09 - Testar a API (TERMINAL 3, com o 08 servindo)
# Usa Invoke-RestMethod (nativo do PowerShell).
# =====================================================================

Write-Host "==> GET /health" -ForegroundColor Cyan
$health = Invoke-RestMethod -Uri "http://127.0.0.1:8000/health"
Write-Host "status = $($health.status)"

Write-Host "`n==> POST /predict" -ForegroundColor Cyan
$amostra = @{
    alcohol                      = 13.0
    malic_acid                   = 2.0
    ash                          = 2.3
    alcalinity_of_ash            = 15.6
    magnesium                    = 120
    total_phenols                = 2.8
    flavanoids                   = 3.0
    nonflavanoid_phenols         = 0.3
    proanthocyanins              = 2.0
    color_intensity              = 5.0
    hue                          = 1.0
    od280_od315_of_diluted_wines = 3.0
    proline                      = 1000
} | ConvertTo-Json

$resp = Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -ContentType "application/json" -Body $amostra
Write-Host "prediction = $($resp.prediction)"   # esperado: 0
