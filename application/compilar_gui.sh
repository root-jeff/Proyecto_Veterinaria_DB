#!/bin/bash

echo "========================================"
echo "  Compilando Aplicacion GUI Veterinaria"
echo "========================================"
echo ""

# Limpiar directorio bin
rm -rf bin/gui
mkdir -p bin/gui

# Buscar el driver de PostgreSQL
POSTGRES_JAR=$(ls lib/postgresql*.jar 2>/dev/null | head -n 1)

if [ -z "$POSTGRES_JAR" ]; then
    echo "ERROR: No se encontró el driver de PostgreSQL en lib/"
    echo "Por favor, descarga postgresql-XX.X.X.jar y colócalo en lib/"
    exit 1
fi

echo "Usando driver: $POSTGRES_JAR"
echo ""

# Compilar clases model
echo "Compilando model..."
javac -d bin -encoding UTF-8 model/*.java
if [ $? -ne 0 ]; then
    echo "ERROR al compilar model"
    exit 1
fi

# Compilar clases database
echo "Compilando database..."
javac -d bin -cp "bin:$POSTGRES_JAR" -encoding UTF-8 database/*.java
if [ $? -ne 0 ]; then
    echo "ERROR al compilar database"
    exit 1
fi

# Compilar clases dao
echo "Compilando dao..."
javac -d bin -cp "bin:$POSTGRES_JAR" -encoding UTF-8 dao/*.java
if [ $? -ne 0 ]; then
    echo "ERROR al compilar dao"
    exit 1
fi

# Compilar clases gui
echo "Compilando gui..."
javac -d bin -cp "bin:$POSTGRES_JAR" -encoding UTF-8 gui/*.java
if [ $? -ne 0 ]; then
    echo "ERROR al compilar gui"
    exit 1
fi

# Copiar archivo de configuración
echo "Copiando config.properties..."
cp config.properties bin/

echo ""
echo "========================================"
echo "  Compilación completada con éxito!"
echo "========================================"
echo ""
echo "Para ejecutar la aplicación GUI, usa:"
echo "  ./ejecutar_gui.sh"
echo ""
