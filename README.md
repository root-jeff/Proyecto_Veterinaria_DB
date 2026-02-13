# PROYECTO: SISTEMA DE GESTION DE CLINICA VETERINARIA
## Sistema Completo con Base de Datos y Aplicaciones Java

<div align="center">
  <img src="application/assets/logo.png" alt="Logo Clinica Veterinaria" width="200"/>
</div>

---

## OBJETIVO DEL PROYECTO

Diseñar e implementar un sistema completo de gestion para una clinica veterinaria que incluye:
- Base de datos relacional normalizada (3FN) en PostgreSQL
- Aplicacion de escritorio en Java (consola y GUI con Swing)
- Gestion eficiente de clientes y mascotas
- Control de citas medicas y veterinarios
- Historial medico completo
- Consultas avanzadas y reportes

## VERSIONES DISPONIBLES

### Version GUI (Interfaz Grafica) - RECOMENDADA
- Interfaz moderna con Java Swing
- Logo personalizado de la clinica
- Navegacion por menus y botones
- Tablas interactivas para consultas
- Formularios con validacion
- **Ubicacion:** `application/gui/`
- **Ejecutar:** `ejecutar_gui.bat` (Windows) o `./ejecutar_gui.sh` (Linux/Mac)

### Version Consola (Linea de Comandos)
- Interfaz de texto tradicional
- Todas las funcionalidades de la GUI
- Ideal para servidores sin entorno grafico
- **Ejecutar:** `ejecutar.bat` (Windows) o `./ejecutar.sh` (Linux/Mac)

---

## ENTREGABLES DEL PROYECTO

### FASE 1: DISEÑO DE BASE DE DATOS (PostgreSQL)

| # | Documento | Descripcion | Estado |
|---|-----------|-------------|--------|
| 1 | `veterinaria_db_design.md` | Proceso completo de normalizacion (0FN → 3FN) | Completado |
| 2 | `veterinaria_mer.md` | Modelo Entidad-Relacion con diagramas | Completado |
| 3 | `veterinaria_modelo_relacional.md` | Modelo Relacional con notacion formal | Completado |
| 4 | `veterinaria_db_creation_postgres.sql` | Script de creacion de BD en PostgreSQL | Completado |
| 5 | `veterinaria_seed_data_postgres.sql` | Datos de prueba para todas las tablas | Completado |
| 6 | `veterinaria_queries_postgres.sql` | 12+ consultas SQL avanzadas | Completado |

### FASE 2: APLICACION JAVA

| # | Componente | Descripcion | Estado |
|---|-----------|-------------|--------|
| 1 | `VeterinariaApp.java` | Aplicacion de consola con todas las funcionalidades | Completado |
| 2 | `gui/VeterinariaGUI.java` | Aplicacion GUI con Java Swing | Completado |
| 3 | `dao/` | Capa de acceso a datos (DAO Pattern) | Completado |
| 4 | `model/` | Modelos de datos (POJOs) | Completado |
| 5 | `database/DatabaseConnection.java` | Gestion de conexion con PostgreSQL | Completado |

---

## INICIO RAPIDO

### Requisitos Previos
- Java JDK 8 o superior
- PostgreSQL 12 o superior
- Driver JDBC de PostgreSQL (incluido en `lib/`)

### Configuracion

1. **Crear la base de datos:**
   ```bash
   # Ejecutar los scripts en PostgreSQL:
   psql -U postgres -f documentacion/postgres/veterinaria_db_creation_postgres.sql
   psql -U postgres -f documentacion/postgres/veterinaria_seed_data_postgres.sql
   ```

2. **Configurar la conexion:**
   Editar `application/config.properties`:
   ```properties
   db.url=jdbc:postgresql://localhost:5432/veterinaria_db
   db.user=tu_usuario
   db.password=tu_password
   ```

3. **Ejecutar la aplicacion:**

   **Version GUI (Recomendada):**
   ```bash
   cd application
   # Windows:
   compilar_gui.bat
   ejecutar_gui.bat
   
   # Linux/Mac:
   chmod +x compilar_gui.sh ejecutar_gui.sh
   ./compilar_gui.sh
   ./ejecutar_gui.sh
   ```

   **Version Consola:**
   ```bash
   cd application
   # Windows:
   compilar.bat
   ejecutar.bat
   
   # Linux/Mac:
   chmod +x compilar.sh ejecutar.sh
   ./compilar.sh
   ./ejecutar.sh
   ```

---

## ESTRUCTURA DE LA BASE DE DATOS

### Estadisticas Generales

```
Total de Tablas:           19
Total de Relaciones (FK):  28
Total de Constraints:      45+
Total de Indices:          27+
Normalizacion:             3FN (Tercera Forma Normal)
Motor de BD:               PostgreSQL 12+
```

### Modulos del Sistema

#### 1. **MODULO DE UBICACIONES** (2 tablas)
- `PROVINCIAS` - Provincias del pais
- `CIUDADES` - Ciudades por provincia

#### 2. **MODULO DE CLIENTES** (2 tablas)
- `CLIENTES` - Informacion de los duenos
- `TELEFONOS_CLIENTE` - Telefonos de contacto (multiples)

#### 3. **MODULO DE MASCOTAS** (3 tablas)
- `ESPECIES` - Catalogo de especies (perro, gato, ave, etc.)
- `RAZAS` - Razas por especie
- `MASCOTAS` - Registro de mascotas

#### 4. **MODULO DE VETERINARIOS** (2 tablas)
- `ESPECIALIDADES` - Especialidades medicas
- `VETERINARIOS` - Personal veterinario

#### 5. **MODULO DE CITAS** (1 tabla)
- `CITAS` - Agenda de citas medicas

#### 6. **MODULO DE HISTORIAL MEDICO** (2 tablas)
- `HISTORIAL_MEDICO` - Registros de consultas
- `TRATAMIENTOS` - Tratamientos prescritos

#### 7. **MODULO DE MEDICAMENTOS** (2 tablas)
- `MEDICAMENTOS` - Catalogo de medicamentos
- `MEDICAMENTOS_RECETADOS` - Recetas medicas

#### 8. **MODULO DE VACUNAS** (2 tablas)
- `VACUNAS` - Catalogo de vacunas
- `VACUNAS_APLICADAS` - Registro de vacunacion

#### 9. **MODULO DE SERVICIOS** (3 tablas)
- `SERVICIOS` - Catalogo de servicios (bano, peluqueria, etc.)
- `EMPLEADOS` - Personal no veterinario
- `SERVICIOS_REALIZADOS` - Servicios prestados

---

## FUNCIONALIDADES DE LA APLICACION JAVA

### Version GUI (Interfaz Grafica)

#### Pantalla Principal
- Logo de la clinica veterinaria
- Botones de acceso rapido a todas las funcionalidades
- Menu superior con navegacion organizada
- Diseño moderno y profesional

#### Modulo de Mascotas
- **Registrar Nueva Mascota**: Formulario completo con validaciones
  - Seleccion de cliente dueno
  - Seleccion de especie y raza (relacionadas automaticamente)
  - Datos completos: nombre, fecha nacimiento, color, peso, genero
  - Numero de microchip opcional
  
- **Listar Mascotas**: Tabla interactiva con todas las mascotas
  - Vista tabular con informacion completa
  - Boton de actualizacion para refrescar datos
  - Contador de registros total

#### Modulo de Citas
- **Asignar Cita**: Agendar citas veterinarias
  - Seleccion de mascota y veterinario
  - Verificacion automatica de disponibilidad
  - Campos para fecha, hora, motivo y observaciones
  - Alertas si hay conflictos de horario
  
- **Proximas Citas**: Ver agenda completa
  - Tabla con todas las citas programadas
  - Ordenadas por fecha
  - Informacion de veterinario y mascota

#### Modulo de Historial Medico
- **Consultar Historial**: Vista completa del historial de una mascota
  - Informacion general de la mascota
  - Tabla con todas las consultas medicas previas
  - Lista de citas programadas
  - Detalles medicos: peso, temperatura, frecuencia cardiaca
  - Diagnosticos y tratamientos

#### Modulo de Consultas Avanzadas
Todas las consultas se muestran en **tablas interactivas**:

- **Estadisticas por Veterinario**: 
  - Tabla con conteo de citas por veterinario
  - Columnas: Veterinario, Especialidad, Total, Completadas, Canceladas, Pendientes
  
- **Top 5 Mascotas con Mas Consultas**:
  - Las mascotas mas atendidas
  - Columnas: Mascota, Especie, Raza, Dueno, Total Consultas, Ultima Consulta
  
- **Distribucion por Especie**:
  - Estadisticas de mascotas por tipo
  - Columnas: Especie, Total, Edad Promedio, Mas Vieja, Mas Joven

### Version Consola

Todas las funcionalidades de la version GUI disponibles en formato texto:
- Menus numerados para navegacion
- Entrada de datos por teclado
- Resultados formateados en tablas ASCII
- Mismos datos y validaciones que la GUI

---

## PROCESO DE NORMALIZACION

### Evolucion del Diseño

| Forma Normal | # Tablas | Mejoras Logradas |
|--------------|----------|------------------|
| **0FN** (Inicial) | 1 | Tabla caotica con todo mezclado |
| **1FN** | 8 | Valores atomicos<br>Sin grupos repetitivos |
| **2FN** | 13 | Sin dependencias parciales<br>Catalogos separados |
| **3FN** | 19 | Sin dependencias transitivas<br>Maxima normalizacion |

### Ejemplos de Normalizacion Aplicada

**Problema Original (0FN):**
```
REGISTRO_CLINICA
├── Cliente_Nombre, Cliente_Apellido, Cliente_Telefono1, Cliente_Telefono2
├── Mascota_Nombre, Mascota_Raza, Mascota_Peso
├── Vacuna_Nombre, Vacuna_Fecha, Vacuna_Proxima
└── (Todo en una sola tabla = Redundancia masiva)
```

**Solucion (3FN):**
```
CLIENTES → MASCOTAS → VACUNAS_APLICADAS → VACUNAS
          ↓
          TELEFONOS_CLIENTE
```

---

## CONSULTAS SQL IMPLEMENTADAS

### Requisitos Cumplidos

✅ **5+ Consultas con JOIN** (se implementaron 7)
✅ **2+ Subconsultas Anidadas** (se implementaron 2)
✅ **3+ Funciones Agregadas** (se implementaron 5)

### Listado de Consultas

| # | Tipo | Descripción |
|---|------|-------------|
| 1 | JOIN (5 tablas) | Listado completo de mascotas con dueño y ubicación |
| 2 | JOIN (6 tablas) | Historial de citas con diagnósticos |
| 3 | JOIN (7 tablas) | Tratamientos activos con medicamentos |
| 4 | JOIN (múltiple) | Estado de vacunación por mascota |
| 5 | JOIN (5 tablas) | Servicios realizados con facturación |
| 6 | SUBCONSULTA | Clientes con múltiples mascotas y estadísticas |
| 7 | SUBCONSULTA | Veterinarios con rendimiento superior al promedio |
| 8 | AGREGACIÓN | Estadísticas generales (COUNT, AVG, MIN, MAX) |
| 9 | AGREGACIÓN | Análisis de ingresos por servicio (SUM, AVG) |
| 10 | AGREGACIÓN | Top 5 mascotas con más visitas |
| 11 | BONUS | Agenda de veterinarios (próximos 7 días) |
| 12 | BONUS | Alertas de vacunas próximas a vencer |

---

## INSTRUCCIONES DE INSTALACION

### Requisitos Previos
- **Java JDK 11+** - Para compilar y ejecutar la aplicacion
- **PostgreSQL 12+** - Base de datos
- **PostgreSQL JDBC Driver** - Incluido en `application/lib/postgresql-42.7.9.jar`

### Paso 1: Crear la Base de Datos
```sql
-- Ejecutar en pgAdmin 4 o psql

-- 1. Abrir el archivo: documentacion/postgres/veterinaria_db_creation_postgres.sql
-- 2. Ejecutar el script completo
-- 3. Verificar que se crearon las 19 tablas
```

### Paso 2: Cargar Datos de Prueba
```sql
-- 1. Abrir el archivo: documentacion/postgres/veterinaria_seed_data_postgres.sql
-- 2. Ejecutar el script completo
-- 3. Verificar el resumen de datos insertados
```

### Paso 3: Configurar la Conexion

Editar el archivo `application/config.properties`:
```properties
db.url=jdbc:postgresql://localhost:5432/veterinaria_db
db.username=tu_usuario
db.password=tu_password
```

### Paso 4: Compilar la Aplicacion

**Windows:**
```batch
cd application
compilar_gui.bat
```

**Linux/Mac:**
```bash
cd application
./compilar_gui.sh
```

### Paso 5: Ejecutar la Aplicacion

**Version GUI (Recomendada):**
```batch
# Windows
ejecutar_gui.bat

# Linux/Mac
./ejecutar_gui.sh
```

**Version Consola:**
```batch
# Windows
ejecutar.bat

# Linux/Mac
./ejecutar.sh
```

### Paso 6: Ejecutar Consultas de Prueba (Opcional)
```sql
-- 1. Abrir el archivo: documentacion/postgres/veterinaria_queries_postgres.sql
-- 2. Ejecutar consulta por consulta
-- 3. Analizar los resultados
```

---

## DATOS DE PRUEBA INCLUIDOS

```
Provincias:              4
Ciudades:                8
Clientes:                8
Telefonos:              10
Especies:                5
Razas:                  14
Mascotas:               12
Especialidades:          6
Veterinarios:            5
Citas:                  11
Historiales Medicos:     5
Tratamientos:            4
Medicamentos:            7
Recetas:                 7
Vacunas:                 6
Vacunas Aplicadas:      10
Servicios:              10
Empleados:               5
Servicios Realizados:    9
```

---

## CARACTERISTICAS DESTACADAS

### Integridad Referencial
- Todas las relaciones implementadas con FOREIGN KEYs
- Reglas ON DELETE CASCADE donde corresponde
- Reglas ON DELETE RESTRICT para proteger datos criticos

### Validaciones de Negocio
- CHECK constraints para estados y dominios
- UNIQUE constraints para evitar duplicados
- Validaciones de fechas y rangos numericos

### Optimizacion
- Indices en columnas de busqueda frecuente
- Indices compuestos para consultas complejas
- Indices filtrados para mejorar performance

### Seguridad de Datos
- Claves primarias autoincrementales (SERIAL en PostgreSQL)
- Campos de auditoria (fecha_registro, fecha_creacion)
- Campos de estado para soft-delete

### Aplicacion Java
- Interfaz grafica moderna con Java Swing
- Arquitectura MVC (Model-View-Controller)
- Patron DAO para acceso a datos
- Version consola alternativa disponible
- Tablas interactivas para visualizacion de datos
- Logo institucional en pantalla principal

---

## MODELO ENTIDAD-RELACION

### Relaciones Principales

```
CLIENTE 1 ──────< N MASCOTA
                    │
                    ├──< CITA ──< HISTORIAL_MEDICO ──< TRATAMIENTO ──< MEDICAMENTO_RECETADO
                    │      │
                    │      └──> VETERINARIO
                    │
                    ├──< VACUNA_APLICADA ──> VACUNA
                    │
                    └──< SERVICIO_REALIZADO ──> SERVICIO
                                                  │
                                                  └──> EMPLEADO
```

### Cardinalidades

- Cliente → Mascota: **1:N** (Un cliente puede tener multiples mascotas)
- Mascota → Cita: **1:N** (Una mascota puede tener multiples citas)
- Cita → Historial: **1:1** (Una cita genera maximo un historial)
- Tratamiento → Medicamento: **N:M** (Relacion muchos a muchos)
- Mascota → Vacuna: **N:M** (Una mascota recibe varias vacunas)

---

## CASOS DE USO CUBIERTOS

### Gestion de Clientes
- Registro de clientes con ubicacion completa
- Multiples telefonos de contacto
- Historial de mascotas por cliente

### Gestion de Mascotas
- Registro detallado (especie, raza, microchip, etc.)
- Seguimiento de edad y peso
- Control de estado (activo/fallecido/adoptado)

### Agenda Medica
- Programacion de citas por veterinario
- Prevencion de conflictos de horarios
- Estados de cita (pendiente/completada/cancelada)

### Historial Medico
- Registro de consultas con signos vitales
- Diagnosticos y observaciones
- Trazabilidad veterinario-mascota

### Tratamientos
- Prescripcion de medicamentos con dosis exactas
- Control de fechas de inicio/fin
- Seguimiento de tratamientos activos

### Control de Vacunacion
- Registro de vacunas aplicadas
- Alertas de revacunacion
- Historial completo por mascota

### Servicios Adicionales
- Gestion de servicios esteticos y de cuidado
- Facturacion y control de pagos
- Asignacion de empleados

---

## PROXIMOS PASOS

### Mejoras Potenciales
- [ ] Exportacion de reportes a PDF/Excel
- [ ] Graficos estadisticos en la GUI
- [ ] Sistema de recordatorios automaticos de citas
- [ ] Modulo de facturacion completo
- [ ] Sistema de usuarios y permisos
- [ ] Backup automatico de base de datos
- [ ] API REST para integracion con aplicaciones web/moviles
- [ ] Notificaciones por correo/SMS a clientes

---

## SOPORTE Y DOCUMENTACION

### Archivos de Documentacion Base de Datos
- `documentacion/db_sqls/veterinaria_db_design.md` - Diseño completo y normalizacion
- `documentacion/db_sqls/veterinaria_mer.md` - Modelo Entidad-Relacion
- `documentacion/db_sqls/veterinaria_modelo_relacional.md` - Modelo Relacional detallado

### Archivos de Documentacion Aplicacion
- `application/README.md` - Informacion sobre la aplicacion Java
- `application/INDEX.md` - Indice de contenidos
- `application/INICIO_RAPIDO.md` - Guia rapida de ejecucion
- `documentacion/app/Funcionalidades_Aplicacion.md` - Funcionalidades completas
- `documentacion/app/RESUMEN_PROYECTO.md` - Resumen general del proyecto

### Scripts SQL (PostgreSQL)
- `documentacion/postgres/veterinaria_db_creation_postgres.sql` - Creacion de BD
- `documentacion/postgres/veterinaria_seed_data_postgres.sql` - Datos de prueba
- `documentacion/postgres/veterinaria_queries_postgres.sql` - Consultas avanzadas

### Codigo Fuente Java
- `application/gui/` - Paquete con las clases de interfaz grafica
- `application/dao/` - Capa de acceso a datos
- `application/model/` - Clases del modelo de datos
- `application/database/` - Gestion de conexion a BD

---

## CONCLUSIONES

Este proyecto establece una **base solida y escalable** para un sistema de gestion de clinica veterinaria completo en dos versiones:

### Base de Datos
- **Integridad de datos**: Sin redundancia ni anomalias gracias a normalizacion 3FN
- **Flexibilidad**: Facil de extender con nuevos modulos
- **Performance**: Optimizado con indices apropiados
- **Mantenibilidad**: Estructura clara y bien documentada

### Aplicacion Java
- **Interfaz Grafica**: GUI moderna con Java Swing
- **Arquitectura MVC**: Separacion clara de responsabilidades
- **Patron DAO**: Acceso estructurado a la base de datos
- **Dos Versiones**: GUI y consola para diferentes necesidades
- **Visualizacion**: Tablas interactivas para consultas y reportes

El sistema esta listo para ser utilizado en:
- Clinicas veterinarias pequeñas y medianas
- Proyectos academicos de bases de datos
- Base para desarrollo de aplicaciones web/movil
- Sistemas de reporteria y analisis

---

**Fecha de creacion**: Febrero 2025  
**Version**: 2.0  
**Tecnologia**: PostgreSQL 12+ | Java JDK 11+ | JDBC  
**Estado**: Completado y funcional

