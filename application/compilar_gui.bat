@echo off
echo ========================================
echo   Compilando Aplicacion GUI Veterinaria
echo ========================================
echo.

REM Limpiar directorio bin
if exist bin\gui rmdir /s /q bin\gui
mkdir bin\gui

REM Buscar el driver de PostgreSQL
set POSTGRES_JAR=
for %%f in (lib\postgresql*.jar) do set POSTGRES_JAR=%%f

if not defined POSTGRES_JAR (
    echo ERROR: No se encontro el driver de PostgreSQL en lib/
    echo Por favor, descarga postgresql-XX.X.X.jar y colocalo en lib/
    pause
    exit /b 1
)

echo Usando driver: %POSTGRES_JAR%
echo.

REM Compilar clases model
echo Compilando model...
javac -d bin -encoding UTF-8 model\*.java
if errorlevel 1 (
    echo ERROR al compilar model
    pause
    exit /b 1
)

REM Compilar clases database
echo Compilando database...
javac -d bin -cp "bin;%POSTGRES_JAR%" -encoding UTF-8 database\*.java
if errorlevel 1 (
    echo ERROR al compilar database
    pause
    exit /b 1
)

REM Compilar clases dao
echo Compilando dao...
javac -d bin -cp "bin;%POSTGRES_JAR%" -encoding UTF-8 dao\*.java
if errorlevel 1 (
    echo ERROR al compilar dao
    pause
    exit /b 1
)

REM Compilar clases gui
echo Compilando gui...
javac -d bin -cp "bin;%POSTGRES_JAR%" -encoding UTF-8 gui\*.java
if errorlevel 1 (
    echo ERROR al compilar gui
    pause
    exit /b 1
)

REM Copiar archivo de configuracion
echo Copiando config.properties...
copy config.properties bin\ >nul

echo.
echo ========================================
echo   Compilacion completada con exito!
echo ========================================
echo.
echo Para ejecutar la aplicacion GUI, usa:
echo   ejecutar_gui.bat
echo.
pause
