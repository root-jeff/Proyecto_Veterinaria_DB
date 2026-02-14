@echo off
REM ================================================================
REM Script ALTERNATIVO para crear EXE usando Launch4j
REM Más ligero que jpackage (no incluye JRE)
REM ================================================================

echo.
echo ============================================================
echo   CREANDO EXE con Launch4j - Sistema Veterinaria
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

echo NOTA: Este metodo requiere Launch4j instalado
echo.
echo Si no tienes Launch4j:
echo   1. Descarga desde: https://launch4j.sourceforge.net/
echo   2. Instala en C:\Program Files\Launch4j o actualiza la ruta abajo
echo   3. Ejecuta este script nuevamente
echo.

set LAUNCH4J_DIR=C:\Program Files\Launch4j
set LAUNCH4J_EXE=%LAUNCH4J_DIR%\launch4jc.exe

if not exist "%LAUNCH4J_EXE%" (
    set LAUNCH4J_DIR=C:\Program Files (x86)\Launch4j
    set LAUNCH4J_EXE=!LAUNCH4J_DIR!\launch4jc.exe
)

if not exist "%LAUNCH4J_EXE%" (
    echo ERROR: Launch4j no encontrado en:
    echo   - C:\Program Files\Launch4j\
    echo   - C:\Program Files (x86)\Launch4j\
    echo.
    echo Por favor, instala Launch4j o actualiza la ruta en este script.
    echo.
    pause
    exit /b 1
)

echo [1/2] Creando configuracion de Launch4j...

REM Crear archivo de configuración XML para Launch4j
(
echo ^<?xml version="1.0" encoding="UTF-8"?^>
echo ^<launch4jConfig^>
echo   ^<dontWrapJar^>false^</dontWrapJar^>
echo   ^<headerType^>gui^</headerType^>
echo   ^<jar^>%CD%\VeterinariaApp.jar^</jar^>
echo   ^<outfile^>%CD%\SistemaVeterinaria.exe^</outfile^>
echo   ^<errTitle^>Sistema Veterinaria^</errTitle^>
echo   ^<cmdLine^>^</cmdLine^>
echo   ^<chdir^>.^</chdir^>
echo   ^<priority^>normal^</priority^>
echo   ^<downloadUrl^>https://www.java.com/download/^</downloadUrl^>
echo   ^<supportUrl^>^</supportUrl^>
echo   ^<stayAlive^>false^</stayAlive^>
echo   ^<restartOnCrash^>false^</restartOnCrash^>
echo   ^<manifest^>^</manifest^>
echo   ^<icon^>^</icon^>
echo   ^<jre^>
echo     ^<path^>^</path^>
echo     ^<bundledJre64Bit^>false^</bundledJre64Bit^>
echo     ^<bundledJreAsFallback^>false^</bundledJreAsFallback^>
echo     ^<minVersion^>11^</minVersion^>
echo     ^<maxVersion^>^</maxVersion^>
echo     ^<jdkPreference^>preferJre^</jdkPreference^>
echo     ^<runtimeBits^>64/32^</runtimeBits^>
echo   ^</jre^>
echo   ^<versionInfo^>
echo     ^<fileVersion^>1.0.0.0^</fileVersion^>
echo     ^<txtFileVersion^>1.0.0^</txtFileVersion^>
echo     ^<fileDescription^>Sistema de Gestion Veterinaria^</fileDescription^>
echo     ^<copyright^>Copyright 2026^</copyright^>
echo     ^<productVersion^>1.0.0.0^</productVersion^>
echo     ^<txtProductVersion^>1.0.0^</txtProductVersion^>
echo     ^<productName^>Sistema Veterinaria^</productName^>
echo     ^<companyName^>Sistema Veterinaria^</companyName^>
echo     ^<internalName^>VeterinariaApp^</internalName^>
echo     ^<originalFilename^>SistemaVeterinaria.exe^</originalFilename^>
echo   ^</versionInfo^>
echo ^</launch4jConfig^>
) > launch4j_config.xml

echo [2/2] Generando ejecutable EXE...

"%LAUNCH4J_EXE%" launch4j_config.xml

if errorlevel 1 (
    echo.
    echo ERROR: No se pudo crear el ejecutable EXE
    del launch4j_config.xml
    pause
    exit /b 1
)

del launch4j_config.xml

if exist "SistemaVeterinaria.exe" (
    echo.
    echo ============================================================
    echo   EXE CREADO EXITOSAMENTE
    echo ============================================================
    echo.
    echo   Archivo: SistemaVeterinaria.exe
    echo   Ubicacion: %CD%\SistemaVeterinaria.exe
    echo.
    echo   NOTA: Este EXE requiere Java 11+ instalado en el equipo.
    echo   Si quieres un EXE que incluya Java, usa crear_exe.bat
    echo.
    echo ============================================================
) else (
    echo.
    echo ERROR: No se encontro el archivo EXE generado
    pause
    exit /b 1
)

pause
