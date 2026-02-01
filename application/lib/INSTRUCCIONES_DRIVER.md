# Instrucciones para Descargar el Driver JDBC de PostgreSQL

## Opción 1: Descarga desde el sitio oficial

1. Visita: https://jdbc.postgresql.org/download/
2. Descarga la última versión estable (ej: postgresql-42.7.2.jar)
3. Coloca el archivo JAR en la carpeta `application/lib/`

## Opción 2: Maven Repository (alternativa)

1. Visita: https://mvnrepository.com/artifact/org.postgresql/postgresql
2. Selecciona la versión más reciente
3. Descarga el JAR
4. Coloca el archivo JAR en la carpeta `application/lib/`

## Opción 3: Descarga directa (versión 42.7.2)

URL directa: https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.2/postgresql-42.7.2.jar

## Nota Importante

Después de descargar el driver:
- Asegúrate de que el nombre del archivo coincida con el usado en los scripts de compilación
- Si descargaste una versión diferente (ej: postgresql-42.6.0.jar), actualiza:
  - compilar.bat (línea con javac)
  - ejecutar.bat (línea con java)
  - compilar.sh (línea con javac)
  - ejecutar.sh (línea con java)

## Estructura esperada

```
application/
├── lib/
│   └── postgresql-42.7.2.jar  ← El driver debe estar aquí
├── model/
├── dao/
├── database/
└── VeterinariaApp.java
```
