#!/bin/bash
# Script para ejecutar la aplicación de Veterinaria en Linux/Mac

echo "===================================="
echo "Ejecutando aplicación Veterinaria"
echo "===================================="
echo ""

# Verificar que existe el directorio bin
if [ ! -d "bin" ]; then
    echo "Error: No se encuentra el directorio bin"
    echo "Ejecuta primero ./compilar.sh"
    exit 1
fi

# Copiar config.properties al directorio bin si existe
if [ -f "config.properties" ]; then
    cp config.properties bin/
fi

# Ejecutar la aplicación
java -cp "bin:lib/postgresql-42.7.9.jar" VeterinariaApp
