@echo off
REM ================================================================
REM Script para crear JAR ejecutable de Sistema Veterinaria
REM ================================================================

REM Buscar JDK y agregar al PATH
set "JDK_FOUND="
for /d %%i in ("C:\Program Files\Java\jdk*") do (
    if exist "%%i\bin\jar.exe" (
        set "JAVA_HOME=%%i"
        set "PATH=%%i\bin;%PATH%"
        set "JDK_FOUND=1"
        goto :jdk_found
    )
)
:jdk_found

if not defined JDK_FOUND (
    echo ERROR: No se encontro el JDK. Asegurate de tener el JDK instalado.
    echo El JDK incluye el comando 'jar' necesario para crear el archivo JAR.
    echo.
    echo Descarga el JDK desde: https://www.oracle.com/java/technologies/downloads/
    pause
    exit /b 1
)

echo.
echo ============================================================
echo   CREANDO JAR EJECUTABLE - Sistema Veterinaria
echo ============================================================
echo.

REM Limpiar directorio bin
echo [1/4] Limpiando directorio bin...
if exist bin\*.class del /S /Q bin\*.class >nul 2>&1
if not exist bin mkdir bin

REM Compilar todos los archivos Java
echo [2/4] Compilando archivos Java...
javac -encoding UTF-8 -d bin -cp "lib\postgresql-42.7.9.jar" ^
    model\*.java ^
    database\*.java ^
    dao\*.java ^
    gui\*.java ^
    VeterinariaApp.java

if errorlevel 1 (
    echo.
    echo ERROR: La compilacion fallo. Revisa los errores anteriores.
    pause
    exit /b 1
)

REM Copiar recursos necesarios
echo [3/4] Copiando recursos...
copy config.properties bin\ >nul 2>&1
if exist assets (
    xcopy /E /I /Y assets bin\assets >nul 2>&1
)

REM Crear JAR con dependencias incluidas
echo [4/4] Creando JAR ejecutable...

REM Crear directorio temporal
if exist temp_jar rmdir /S /Q temp_jar
mkdir temp_jar

REM Copiar clases compiladas
xcopy /E /I /Y bin\*.class temp_jar\ >nul 2>&1
xcopy /E /I /Y bin\model temp_jar\model >nul 2>&1
xcopy /E /I /Y bin\database temp_jar\database >nul 2>&1
xcopy /E /I /Y bin\dao temp_jar\dao >nul 2>&1
xcopy /E /I /Y bin\gui temp_jar\gui >nul 2>&1

REM Copiar config
copy bin\config.properties temp_jar\ >nul 2>&1

REM Copiar assets si existen
if exist bin\assets (
    xcopy /E /I /Y bin\assets temp_jar\assets >nul 2>&1
)

REM Extraer contenido del JAR de PostgreSQL
echo    - Extrayendo dependencias de PostgreSQL...
cd temp_jar
jar xf ..\lib\postgresql-42.7.9.jar
del /Q META-INF\*.SF >nul 2>&1
del /Q META-INF\*.RSA >nul 2>&1
del /Q META-INF\*.DSA >nul 2>&1
cd ..

REM Crear JAR ejecutable
jar cfm VeterinariaApp.jar MANIFEST.MF -C temp_jar .

REM Limpiar directorio temporal
rmdir /S /Q temp_jar

if exist VeterinariaApp.jar (
    echo.
    echo ============================================================
    echo   JAR CREADO EXITOSAMENTE
    echo ============================================================
    echo.
    echo   Archivo: VeterinariaApp.jar
    echo   Ubicacion: %CD%\VeterinariaApp.jar
    echo.
    echo   Para ejecutar:
    echo   - Doble clic en VeterinariaApp.jar
    echo   - O desde consola: java -jar VeterinariaApp.jar
    echo.
    echo ============================================================
) else (
    echo.
    echo ERROR: No se pudo crear el archivo JAR
    pause
    exit /b 1
)

pause
