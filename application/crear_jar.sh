#!/bin/bash
# ================================================================
# Script para crear JAR ejecutable de Sistema Veterinaria
# ================================================================

echo ""
echo "============================================================"
echo "  CREANDO JAR EJECUTABLE - Sistema Veterinaria"
echo "============================================================"
echo ""

# Limpiar directorio bin
echo "[1/4] Limpiando directorio bin..."
find bin -name "*.class" -type f -delete 2>/dev/null
mkdir -p bin

# Compilar todos los archivos Java
echo "[2/4] Compilando archivos Java..."
javac -encoding UTF-8 -d bin -cp "lib/postgresql-42.7.9.jar" \
    model/*.java \
    database/*.java \
    dao/*.java \
    gui/*.java \
    VeterinariaApp.java

if [ $? -ne 0 ]; then
    echo ""
    echo "ERROR: La compilación falló. Revisa los errores anteriores."
    exit 1
fi

# Copiar recursos necesarios
echo "[3/4] Copiando recursos..."
cp config.properties bin/ 2>/dev/null
if [ -d "assets" ]; then
    cp -r assets bin/ 2>/dev/null
fi

# Crear JAR con dependencias incluidas
echo "[4/4] Creando JAR ejecutable..."

# Crear directorio temporal
rm -rf temp_jar
mkdir temp_jar

# Copiar clases compiladas
cp bin/*.class temp_jar/ 2>/dev/null
cp -r bin/model temp_jar/ 2>/dev/null
cp -r bin/database temp_jar/ 2>/dev/null
cp -r bin/dao temp_jar/ 2>/dev/null
cp -r bin/gui temp_jar/ 2>/dev/null

# Copiar config
cp bin/config.properties temp_jar/ 2>/dev/null

# Copiar assets si existen
if [ -d "bin/assets" ]; then
    cp -r bin/assets temp_jar/ 2>/dev/null
fi

# Extraer contenido del JAR de PostgreSQL
echo "   - Extrayendo dependencias de PostgreSQL..."
cd temp_jar
jar xf ../lib/postgresql-42.7.9.jar
rm -f META-INF/*.SF META-INF/*.RSA META-INF/*.DSA 2>/dev/null
cd ..

# Crear JAR ejecutable
jar cfm VeterinariaApp.jar MANIFEST.MF -C temp_jar .

# Limpiar directorio temporal
rm -rf temp_jar

if [ -f "VeterinariaApp.jar" ]; then
    echo ""
    echo "============================================================"
    echo "  JAR CREADO EXITOSAMENTE"
    echo "============================================================"
    echo ""
    echo "  Archivo: VeterinariaApp.jar"
    echo "  Ubicación: $(pwd)/VeterinariaApp.jar"
    echo ""
    echo "  Para ejecutar:"
    echo "  - Doble clic en VeterinariaApp.jar"
    echo "  - O desde consola: java -jar VeterinariaApp.jar"
    echo ""
    echo "============================================================"
else
    echo ""
    echo "ERROR: No se pudo crear el archivo JAR"
    exit 1
fi
