#!/bin/bash

echo "========================================"
echo "  Ejecutando Aplicacion GUI Veterinaria"
echo "========================================"
echo ""

# Buscar el driver de PostgreSQL
POSTGRES_JAR=$(ls lib/postgresql*.jar 2>/dev/null | head -n 1)

if [ -z "$POSTGRES_JAR" ]; then
    echo "ERROR: No se encontró el driver de PostgreSQL en lib/"
    echo "Por favor, descarga postgresql-XX.X.X.jar y colócalo en lib/"
    exit 1
fi

# Verificar que existan las clases compiladas
if [ ! -f "bin/gui/VeterinariaGUI.class" ]; then
    echo "ERROR: No se encontraron las clases compiladas."
    echo "Por favor, ejecuta primero ./compilar_gui.sh"
    echo ""
    exit 1
fi

echo "Iniciando interfaz gráfica..."
echo ""
java -cp "bin:$POSTGRES_JAR" gui.VeterinariaGUI

if [ $? -ne 0 ]; then
    echo ""
    echo "ERROR al ejecutar la aplicación"
fi
