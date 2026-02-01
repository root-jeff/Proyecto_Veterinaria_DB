# Migración a PostgreSQL - Sistema Veterinaria

## Descripción

Este directorio contiene los scripts SQL migrados desde SQL Server a PostgreSQL para el Sistema de Gestión de Clínica Veterinaria.

## Archivos Incluidos

### 1. `veterinaria_db_creation_postgres.sql`
Script para la creación completa de la base de datos y todas sus tablas.

**Características:**
- 19 tablas normalizadas (3FN)
- Constraints de integridad referencial
- Índices optimizados para búsquedas frecuentes
- Comentarios en tablas principales

**Módulos incluidos:**
- Gestión de Ubicaciones (Provincias, Ciudades)
- Gestión de Clientes
- Gestión de Mascotas
- Gestión de Veterinarios
- Gestión de Citas
- Historial Médico y Tratamientos
- Medicamentos
- Vacunas
- Servicios y Empleados

### 2. `veterinaria_seed_data_postgres.sql`
Script con datos de prueba para todas las tablas.

**Datos incluidos:**
- 4 Provincias de Ecuador
- 8 Ciudades
- 8 Clientes con teléfonos
- 5 Especies y 14 Razas
- 12 Mascotas
- 6 Especialidades y 5 Veterinarios
- 11 Citas (completadas, pendientes y canceladas)
- 5 Historiales médicos con tratamientos
- 7 Medicamentos con recetas
- 6 Vacunas con 10 aplicaciones
- 10 Servicios y 5 Empleados
- 9 Servicios realizados

### 3. `veterinaria_queries_postgres.sql`
Consultas SQL avanzadas para análisis y reportes.

**Incluye:**
- 5+ Consultas con JOIN (múltiples tablas)
- 2+ Subconsultas anidadas
- 3+ Funciones agregadas (COUNT, AVG, SUM, MIN, MAX)
- Consultas de reportes y análisis
- Consultas de alertas (vacunas próximas a vencer)

## Cambios Principales en la Migración

### De SQL Server a PostgreSQL

| Característica | SQL Server | PostgreSQL |
|---------------|------------|------------|
| **Auto-incremento** | `IDENTITY(1,1)` | `SERIAL` |
| **Booleanos** | `BIT` | `BOOLEAN` |
| **Texto largo** | `NVARCHAR(MAX)` | `TEXT` |
| **Concatenación** | `+` | `\|\|` |
| **Fecha actual** | `GETDATE()` | `CURRENT_TIMESTAMP`, `CURRENT_DATE` |
| **Diferencia fechas** | `DATEDIFF()` | `AGE()`, operadores `-` |
| **Condicional** | `ISNULL()` | `COALESCE()` |
| **GO** | `GO` | `;` (removido) |
| **USE database** | `USE database` | `\c database` |
| **PRINT** | `PRINT` | `RAISE NOTICE` o `\echo` |
| **Nombres** | PascalCase | snake_case |
| **Strings** | `NVARCHAR` | `VARCHAR` |
| **Límite resultados** | `TOP n` | `LIMIT n` |

## Instrucciones de Uso

### Requisitos Previos
- PostgreSQL 12 o superior instalado
- Cliente psql o herramienta de administración (pgAdmin, DBeaver, etc.)
- Permisos de superusuario para crear base de datos

### Instalación Paso a Paso

#### 1. Crear la Base de Datos

```bash
# Opción A: Usando psql desde la terminal
psql -U postgres -f veterinaria_db_creation_postgres.sql

# Opción B: Ejecutar manualmente
psql -U postgres
\i /ruta/completa/veterinaria_db_creation_postgres.sql
```

#### 2. Insertar Datos de Prueba

```bash
# Opción A: Usando psql
psql -U postgres -d veterinariadb -f veterinaria_seed_data_postgres.sql

# Opción B: Ejecutar manualmente
psql -U postgres -d veterinariadb
\i /ruta/completa/veterinaria_seed_data_postgres.sql
```

#### 3. Ejecutar Consultas de Prueba

```bash
# Opción A: Usando psql
psql -U postgres -d veterinariadb -f veterinaria_queries_postgres.sql

# Opción B: Ejecutar manualmente
psql -U postgres -d veterinariadb
\i /ruta/completa/veterinaria_queries_postgres.sql
```

### Conexión a la Base de Datos

```bash
# Usando psql
psql -U postgres -d veterinariadb

# Desde código (ejemplo Node.js con pg)
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'veterinariadb',
  password: 'tu_password',
  port: 5432,
});

# Desde Python (ejemplo con psycopg2)
import psycopg2
conn = psycopg2.connect(
    dbname="veterinariadb",
    user="postgres",
    password="tu_password",
    host="localhost",
    port="5432"
)
```

## Verificación de la Instalación

Después de ejecutar los scripts, verifica que todo se creó correctamente:

```sql
-- Conectar a la base de datos
\c veterinariadb

-- Ver todas las tablas
\dt

-- Contar registros en cada tabla
SELECT 'clientes' as tabla, COUNT(*) as total FROM clientes
UNION ALL
SELECT 'mascotas', COUNT(*) FROM mascotas
UNION ALL
SELECT 'veterinarios', COUNT(*) FROM veterinarios
UNION ALL
SELECT 'citas', COUNT(*) FROM citas;

-- Ver índices creados
\di

-- Ver constraints
\d+ mascotas
```

## Estructura de la Base de Datos

### Diagrama de Módulos

```
┌─────────────────────┐
│   UBICACIONES       │
│  - Provincias       │
│  - Ciudades         │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐     ┌─────────────────────┐
│   CLIENTES          │────▶│   MASCOTAS          │
│  - Datos personales │     │  - Especies         │
│  - Teléfonos        │     │  - Razas            │
└─────────────────────┘     └──────────┬──────────┘
                                       │
                    ┌──────────────────┼──────────────────┐
                    ▼                  ▼                  ▼
           ┌────────────────┐ ┌────────────────┐ ┌──────────────┐
           │   CITAS        │ │   VACUNAS      │ │  SERVICIOS   │
           └────────┬───────┘ │   APLICADAS    │ │  REALIZADOS  │
                    │         └────────────────┘ └──────────────┘
                    ▼
           ┌────────────────┐
           │   HISTORIAL    │
           │   MÉDICO       │
           └────────┬───────┘
                    │
                    ▼
           ┌────────────────┐     ┌────────────────┐
           │  TRATAMIENTOS  │────▶│  MEDICAMENTOS  │
           │                │     │  RECETADOS     │
           └────────────────┘     └────────────────┘
```

## Consultas Útiles

### Consultas Básicas

```sql
-- Ver todas las mascotas activas con sus dueños
SELECT m.nombre, c.nombre || ' ' || c.apellido as dueño, m.fecha_nacimiento
FROM mascotas m
JOIN clientes c ON m.id_cliente = c.id_cliente
WHERE m.estado = 'activo';

-- Próximas citas
SELECT fecha_cita, hora_cita, m.nombre as mascota, v.nombre as veterinario
FROM citas ci
JOIN mascotas m ON ci.id_mascota = m.id_mascota
JOIN veterinarios v ON ci.id_veterinario = v.id_veterinario
WHERE fecha_cita >= CURRENT_DATE AND estado_cita = 'pendiente'
ORDER BY fecha_cita, hora_cita;

-- Vacunas que vencen pronto
SELECT m.nombre, v.nombre_vacuna, va.fecha_proxima_dosis,
       (va.fecha_proxima_dosis - CURRENT_DATE) as dias_restantes
FROM vacunas_aplicadas va
JOIN mascotas m ON va.id_mascota = m.id_mascota
JOIN vacunas v ON va.id_vacuna = v.id_vacuna
WHERE va.fecha_proxima_dosis <= CURRENT_DATE + INTERVAL '30 days'
ORDER BY va.fecha_proxima_dosis;
```

## Mantenimiento

### Backup

```bash
# Backup completo
pg_dump -U postgres veterinariadb > backup_veterinaria_$(date +%Y%m%d).sql

# Backup solo datos
pg_dump -U postgres --data-only veterinariadb > datos_backup_$(date +%Y%m%d).sql

# Backup solo estructura
pg_dump -U postgres --schema-only veterinariadb > estructura_backup_$(date +%Y%m%d).sql
```

### Restauración

```bash
# Restaurar desde backup
psql -U postgres -d veterinariadb < backup_veterinaria_20260201.sql
```

### Optimización

```sql
-- Actualizar estadísticas
ANALYZE;

-- Reindexar tablas
REINDEX DATABASE veterinariadb;

-- Ver tamaño de tablas
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

## Seguridad

### Crear Usuario de Aplicación

```sql
-- Crear usuario con permisos limitados
CREATE USER app_veterinaria WITH PASSWORD 'tu_password_seguro';

-- Otorgar permisos de conexión
GRANT CONNECT ON DATABASE veterinariadb TO app_veterinaria;

-- Otorgar permisos sobre el esquema
GRANT USAGE ON SCHEMA public TO app_veterinaria;

-- Otorgar permisos SELECT, INSERT, UPDATE, DELETE en todas las tablas
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_veterinaria;

-- Otorgar permisos sobre secuencias (para SERIAL)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO app_veterinaria;
```

## Troubleshooting

### Problemas Comunes

1. **Error: database "veterinariadb" already exists**
   ```sql
   DROP DATABASE IF EXISTS veterinariadb;
   ```

2. **Error: no existe la base de datos**
   ```bash
   createdb -U postgres veterinariadb
   ```

3. **Codificación de caracteres**
   ```sql
   -- Verificar encoding
   SHOW SERVER_ENCODING;
   
   -- Cambiar cliente encoding
   SET CLIENT_ENCODING TO 'UTF8';
   ```

4. **Permisos insuficientes**
   ```bash
   # Ejecutar como superusuario
   sudo -u postgres psql
   ```

## Diferencias con SQL Server Original

- **Nombres en minúsculas**: PostgreSQL convierte todo a minúsculas por defecto
- **snake_case**: Se usa snake_case en lugar de PascalCase
- **Funciones de fecha**: Sintaxis diferente para operaciones con fechas
- **Concatenación**: Se usa `||` en lugar de `+`
- **Booleanos**: `TRUE/FALSE` en lugar de `1/0`

## Soporte y Contacto

Para dudas o problemas con la migración:
- Revisar logs de PostgreSQL: `/var/log/postgresql/`
- Documentación oficial: https://www.postgresql.org/docs/
- Stack Overflow: Tag `postgresql`

## Licencia

Este proyecto es parte del Sistema de Gestión de Clínica Veterinaria.

---
**Versión:** 1.0  
**Fecha de migración:** Febrero 2026  
**Motor destino:** PostgreSQL 12+  
**Motor origen:** SQL Server 2019+
