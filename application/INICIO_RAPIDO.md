# 🚀 GUÍA DE INICIO RÁPIDO

## Pasos para ejecutar la aplicación

### 1️⃣ Preparar la Base de Datos

```bash
# Asegúrate de que PostgreSQL esté corriendo

# Navega a la carpeta de scripts
cd documentacion/postgres

# Crea la base de datos (Windows/Linux/Mac)
psql -U postgres -f veterinaria_db_creation_postgres.sql

# Carga datos de prueba
psql -U postgres -d veterinariadb -f veterinaria_seed_data_postgres.sql
```

### 2️⃣ Descargar el Driver JDBC

1. Descarga desde: https://jdbc.postgresql.org/download/
2. Coloca `postgresql-42.7.2.jar` en `application/lib/`

### 3️⃣ Configurar Conexión

Edita `application/config.properties`:
```properties
db.url=jdbc:postgresql://localhost:5432/veterinariadb
db.username=postgres
db.password=TU_CONTRASEÑA
```

### 4️⃣ Compilar y Ejecutar

#### En Windows:
```bash
cd application
compilar.bat
ejecutar.bat
```

#### En Linux/Mac:
```bash
cd application
chmod +x compilar.sh ejecutar.sh
./compilar.sh
./ejecutar.sh
```

---

## 📋 Menú de la Aplicación

Una vez ejecutada, verás:

```
======================================================================
    🐾 SISTEMA DE GESTIÓN DE CLÍNICA VETERINARIA 🐾
======================================================================

1. 📝 Registrar una nueva mascota
2. 📅 Asignar una cita a un veterinario
3. 📋 Consultar historial médico de una mascota
4. 📊 Visualizar consultas avanzadas
5. 🐕 Listar todas las mascotas registradas
6. 🕐 Ver próximas citas programadas
0. ❌ Salir
```

---

## ⚡ Comandos Manuales (Alternativa)

### Compilar manualmente:
```bash
# Windows
javac -encoding UTF-8 -cp ".;lib/postgresql-42.7.2.jar" -d bin VeterinariaApp.java model/*.java dao/*.java database/*.java

# Linux/Mac
javac -encoding UTF-8 -cp ".:lib/postgresql-42.7.2.jar" -d bin VeterinariaApp.java model/*.java dao/*.java database/*.java
```

### Ejecutar manualmente:
```bash
# Windows
java -cp "bin;lib/postgresql-42.7.2.jar" VeterinariaApp

# Linux/Mac
java -cp "bin:lib/postgresql-42.7.2.jar" VeterinariaApp
```

---

## ❓ Problemas Comunes

| Problema | Solución |
|----------|----------|
| "No se encontró el driver" | Descarga postgresql-XX.jar y colócalo en lib/ |
| "No se pudo conectar a BD" | Verifica PostgreSQL corriendo y config.properties |
| "Tabla no existe" | Ejecuta los scripts de creación de BD |
| Errores de compilación | Verifica que JAVA_HOME esté configurado |

---

## 📞 Archivos Importantes

- `README.md` - Documentación completa
- `RESUMEN_PROYECTO.md` - Detalles técnicos del proyecto
- `config.properties` - Configuración de conexión
- `lib/INSTRUCCIONES_DRIVER.md` - Cómo obtener el driver JDBC

---

**¡Listo! Ya puedes usar el sistema de gestión veterinaria 🐾**
