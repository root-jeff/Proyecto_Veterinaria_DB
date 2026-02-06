#!/bin/bash
# Script para compilar la aplicación de Veterinaria en Linux/Mac

echo "===================================="
echo "Compilando aplicación Veterinaria"
echo "===================================="

# Crear directorio bin si no existe
mkdir -p bin

# Compilar todos los archivos Java
echo "Compilando archivos Java..."
javac -encoding UTF-8 -cp ".:lib/postgresql-42.7.9.jar" -d bin VeterinariaApp.java model/*.java dao/*.java database/*.java

if [ $? -eq 0 ]; then
    echo ""
    echo "===================================="
    echo "Compilación exitosa!"
    echo "===================================="
    echo ""
    echo "Para ejecutar la aplicación usa:"
    echo "java -cp \"bin:lib/postgresql-42.7.9.jar\" VeterinariaApp"
    echo ""
else
    echo ""
    echo "===================================="
    echo "Error en la compilación"
    echo "===================================="
    echo ""
fi
