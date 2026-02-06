@echo off
REM Script para ejecutar la aplicación de Veterinaria en Windows
echo ====================================
echo Ejecutando aplicacion Veterinaria
echo ====================================
echo.

REM Verificar que existe el directorio bin
if not exist "bin" (
    echo Error: No se encuentra el directorio bin
    echo Ejecuta primero compilar.bat
    pause
    exit /b
)

REM Copiar config.properties al directorio bin si existe
if exist "config.properties" (
    copy /Y config.properties bin\ >nul
)

REM Ejecutar la aplicacion
java -cp "bin;lib/postgresql-42.7.9.jar" VeterinariaApp

pause
