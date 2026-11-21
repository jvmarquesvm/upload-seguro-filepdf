@echo off
REM Script de execucao direta via Linha de Comando (Opcao 3)
echo =========================================================
echo  Iniciando Servidor JSP Java 17 via Linha de Comando...
echo =========================================================

java -cp "target\classes;target\app\WEB-INF\lib\*" com.exemplo.Main
