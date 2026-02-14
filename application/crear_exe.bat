@echo off
REM ================================================================
REM Script para crear EXE ejecutable de Sistema Veterinaria
REM Requiere: jpackage (incluido en JDK 14+)
REM ================================================================

REM Buscar JDK y agregar al PATH
set "JDK_FOUND="
for /d %%i in ("C:\Program Files\Java\jdk*") do (
    if exist "%%i\bin\jpackage.exe" (
        set "JAVA_HOME=%%i"
        set "PATH=%%i\bin;%PATH%"
        set "JDK_FOUND=1"
        goto :jdk_found_exe
    )
)
:jdk_found_exe

if not defined JDK_FOUND (
    echo ERROR: No se encontro el JDK 14+ con jpackage
    echo.
    echo jpackage requiere JDK 14 o superior.
    echo Descarga el JDK desde: https://www.oracle.com/java/technologies/downloads/
    pause
    exit /b 1
)

echo.
echo ============================================================
echo   CREANDO EXE EJECUTABLE - Sistema Veterinaria
echo ============================================================
echo.

REM Verificar que existe el JAR
if not exist "VeterinariaApp.jar" (
    echo ERROR: No se encuentra VeterinariaApp.jar
    echo.
    echo Por favor, ejecuta primero crear_jar.bat para generar el JAR.
    echo.
    pause
    exit /b 1
)

echo [1/2] Preparando archivos...

REM Limpiar directorios anteriores
if exist "installer" rmdir /S /Q installer
mkdir installer

echo [2/2] Creando ejecutable con jpackage...
echo (Esto puede tomar varios minutos...)
echo.

REM Crear ejecutable con jpackage
jpackage ^
    --input . ^
    --name "SistemaVeterinaria" ^
    --main-jar VeterinariaApp.jar ^
    --type exe ^
    --dest installer ^
    --win-dir-chooser ^
    --win-menu ^
    --win-shortcut ^
    --description "Sistema de Gestion de Clinica Veterinaria" ^
    --vendor "Sistema Veterinaria" ^
    --app-version "1.0" ^
    --copyright "Copyright 2026"

if errorlevel 1 (
    echo.
    echo ERROR: No se pudo crear el ejecutable EXE
    pause
    exit /b 1
)

if exist "installer\SistemaVeterinaria-1.0.exe" (
    echo.
    echo ============================================================
    echo   EXE CREADO EXITOSAMENTE
    echo ============================================================
    echo.
    echo   Archivo: SistemaVeterinaria-1.0.exe
    echo   Ubicacion: %CD%\installer\
    echo.
    echo   El instalador:
    echo   - Instala la aplicacion en Archivos de Programa
    echo   - Crea un acceso directo en el Menu Inicio
    echo   - Crea un acceso directo en el Escritorio
    echo   - Incluye un JRE completo (no requiere Java instalado)
    echo.
    echo ============================================================
) else (
    echo.
    echo ERROR: No se encontro el archivo EXE generado
    pause
    exit /b 1
)

pause
