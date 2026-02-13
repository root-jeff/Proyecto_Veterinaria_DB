@echo off
echo ========================================
echo   Ejecutando Aplicacion GUI Veterinaria
echo ========================================
echo.

REM Buscar el driver de PostgreSQL
set POSTGRES_JAR=
for %%f in (lib\postgresql*.jar) do set POSTGRES_JAR=%%f

if not defined POSTGRES_JAR (
    echo ERROR: No se encontro el driver de PostgreSQL en lib/
    echo Por favor, descarga postgresql-XX.X.X.jar y colocalo en lib/
    pause
    exit /b 1
)

REM Verificar que existan las clases compiladas
if not exist bin\gui\VeterinariaGUI.class (
    echo ERROR: No se encontraron las clases compiladas.
    echo Por favor, ejecuta primero compilar_gui.bat
    echo.
    pause
    exit /b 1
)

echo Iniciando interfaz grafica...
echo.
java -cp "bin;%POSTGRES_JAR%" gui.VeterinariaGUI

if errorlevel 1 (
    echo.
    echo ERROR al ejecutar la aplicacion
    pause
)
