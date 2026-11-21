# Script PowerShell para execucao direta via Linha de Comando (Opcao 3)
Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host " Iniciando Servidor JSP Java 17 via Linha de Comando... " -ForegroundColor Green
Write-Host "=========================================================" -ForegroundColor Cyan

java -cp "target/classes;target/app/WEB-INF/lib/*" com.exemplo.Main
