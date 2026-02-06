@echo off
REM Script para compilar la aplicación de Veterinaria en Windows
echo ====================================
echo Compilando aplicacion Veterinaria
echo ====================================

REM Crear directorio bin si no existe
if not exist "bin" mkdir bin

REM Compilar todos los archivos Java
echo Compilando archivos Java...
javac -encoding UTF-8 -cp ".;lib/postgresql-42.7.9.jar" -d bin VeterinariaApp.java model/*.java dao/*.java database/*.java

if %errorlevel% equ 0 (
    echo.
    echo ====================================
    echo Compilacion exitosa!
    echo ====================================
    echo.
    echo Para ejecutar la aplicacion usa:
    echo java -cp "bin;lib/postgresql-42.7.9.jar" VeterinariaApp
    echo.
) else (
    echo.
    echo ====================================
    echo Error en la compilacion
    echo ====================================
    echo.
)

pause
