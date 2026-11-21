#!/bin/bash
# Script de execução para Linux / VPS
# Garante que as dependências estejam baixadas e inicia a aplicação

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

# Se a pasta de dependências não existir, compila e empacota automaticamente
if [ ! -d "target/app/WEB-INF/lib" ] || [ ! -d "target/classes" ]; then
    echo "Preparando projeto e baixando dependências via Maven Wrapper..."
    ./mvnw package
fi

echo "================================================="
echo " Servidor JSP iniciado com sucesso em Java 17!"
echo " Acesse no navegador: http://localhost:8080"
echo " Pressione Ctrl+C para encerrar o servidor."
echo "================================================="

java -cp "target/classes:target/app/WEB-INF/lib/*" com.exemplo.Main
