# 🐾 Sistema de Gestión de Clínica Veterinaria

Aplicación Java para gestionar una clínica veterinaria con conexión a PostgreSQL.

## 📋 Requisitos

### Software necesario:
- **Java JDK 8 o superior**
- **PostgreSQL 12 o superior**
- **Driver JDBC de PostgreSQL** (postgresql-42.x.x.jar)

## 🚀 Instalación

### 1. Configurar la Base de Datos

Primero, asegúrate de que PostgreSQL esté corriendo y ejecuta los scripts de la base de datos:

```bash
# Navega a la carpeta de scripts
cd documentacion/postgres

# Ejecuta el script de creación de la base de datos
psql -U postgres -f veterinaria_db_creation_postgres.sql

# Ejecuta el script de datos de prueba (seed data)
psql -U postgres -d veterinariadb -f veterinaria_seed_data_postgres.sql
```

### 2. Descargar el Driver JDBC de PostgreSQL

Descarga el driver JDBC desde: https://jdbc.postgresql.org/download/

Coloca el archivo `postgresql-XX.X.X.jar` en la carpeta `application/lib/`

### 3. Configurar la Conexión

Edita el archivo `config.properties` con tus credenciales de PostgreSQL:

```properties
db.url=jdbc:postgresql://localhost:5432/veterinariadb
db.username=postgres
db.password=tu_contraseña
```

### 4. Compilar la Aplicación

```bash
cd application

# En Windows:
javac -encoding UTF-8 -cp ".;lib/postgresql-XX.X.X.jar" -d bin VeterinariaApp.java model/*.java dao/*.java database/*.java

# En Linux/Mac:
javac -encoding UTF-8 -cp ".:lib/postgresql-XX.X.X.jar" -d bin VeterinariaApp.java model/*.java dao/*.java database/*.java
```

### 5. Ejecutar la Aplicación

```bash
# En Windows:
java -cp "bin;lib/postgresql-XX.X.X.jar" VeterinariaApp

# En Linux/Mac:
java -cp "bin:lib/postgresql-XX.X.X.jar" VeterinariaApp
```

## 🎯 Funcionalidades Principales

### ✅ Funcionalidades Requeridas:

1. **📝 Registrar una nueva mascota**
   - Seleccionar cliente existente
   - Elegir especie y raza
   - Ingresar datos básicos (nombre, fecha de nacimiento, peso, género)
   - Opcionalmente agregar número de microchip

2. **📅 Asignar una cita a un veterinario**
   - Seleccionar mascota
   - Elegir veterinario disponible
   - Definir fecha, hora y motivo de consulta
   - Verificación de disponibilidad del veterinario

3. **📋 Consultar historial de una mascota**
   - Ver todas las consultas médicas previas
   - Diagnósticos, tratamientos y observaciones
   - Datos vitales registrados (peso, temperatura, frecuencia cardíaca)
   - Lista de citas programadas

4. **📊 Visualizar consultas avanzadas**
   - Estadísticas de citas por veterinario
   - Top 5 mascotas con más consultas
   - Distribución de mascotas por especie con estadísticas

### ➕ Funcionalidades Adicionales:

5. **🐕 Listar todas las mascotas registradas**
   - Vista general de todas las mascotas activas

6. **🕐 Ver próximas citas programadas**
   - Calendario de citas pendientes

## 📁 Estructura del Proyecto

```
application/
├── VeterinariaApp.java          # Aplicación principal con menú interactivo
├── config.properties            # Configuración de conexión a BD
├── model/                       # Clases de modelo (POJOs)
│   ├── Mascota.java
│   ├── Cliente.java
│   ├── Cita.java
│   ├── HistorialMedico.java
│   ├── Veterinario.java
│   ├── Especie.java
│   └── Raza.java
├── dao/                         # Clases de acceso a datos
│   ├── MascotaDAO.java
│   ├── ClienteDAO.java
│   ├── VeterinarioDAO.java
│   ├── CitaDAO.java
│   ├── HistorialMedicoDAO.java
│   └── ConsultasAvanzadasDAO.java
├── database/                    # Gestión de conexión
│   └── DatabaseConnection.java
└── lib/                         # Librerías externas
    └── postgresql-XX.X.X.jar
```

## 🗄️ Modelo de Base de Datos

La aplicación utiliza una base de datos normalizada en 3FN con los siguientes módulos:

- **Gestión de Ubicaciones**: Provincias, Ciudades
- **Gestión de Clientes**: Clientes, Teléfonos
- **Gestión de Mascotas**: Especies, Razas, Mascotas
- **Gestión de Veterinarios**: Especialidades, Veterinarios
- **Gestión de Citas**: Citas
- **Historial Médico**: Historial, Tratamientos, Medicamentos

## 📝 Ejemplos de Uso

### Registrar una Mascota
1. Selecciona opción `1` del menú principal
2. Elige el cliente dueño de la mascota
3. Selecciona especie (ej: Perro, Gato)
4. Selecciona raza
5. Ingresa los datos solicitados
6. La mascota se registrará con un ID único

### Asignar una Cita
1. Selecciona opción `2` del menú principal
2. Elige la mascota que necesita atención
3. Selecciona el veterinario
4. Ingresa fecha y hora (formato: YYYY-MM-DD y HH:MM)
5. Describe el motivo de la consulta
6. La cita se programará y verificará disponibilidad

### Consultar Historial
1. Selecciona opción `3` del menú principal
2. Elige la mascota
3. Se mostrará el historial completo con:
   - Todas las consultas previas
   - Diagnósticos y tratamientos
   - Datos vitales
   - Citas programadas

## ⚠️ Notas Importantes

- Asegúrate de que PostgreSQL esté corriendo antes de ejecutar la aplicación
- El archivo `config.properties` debe estar en el mismo directorio que la aplicación compilada
- Se recomienda tener datos de prueba en la base de datos para probar todas las funcionalidades
- La aplicación usa codificación UTF-8 para soportar caracteres especiales

## 🔧 Solución de Problemas

### Error: No se encontró el driver de PostgreSQL
**Solución**: Asegúrate de incluir el JAR de PostgreSQL en el classpath al compilar y ejecutar

### Error: No se pudo conectar a la base de datos
**Solución**: 
- Verifica que PostgreSQL esté corriendo
- Revisa las credenciales en `config.properties`
- Verifica que la base de datos `veterinariadb` exista

### Error: tabla no existe
**Solución**: Ejecuta los scripts de creación de la base de datos ubicados en `documentacion/postgres/`

## 👨‍💻 Autor

Desarrollado como parte del Sistema de Gestión de Clínica Veterinaria
