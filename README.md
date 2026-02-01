# 📊 PROYECTO: SISTEMA DE GESTIÓN DE CLÍNICA VETERINARIA
## Resumen Ejecutivo

---

## 🎯 OBJETIVO DEL PROYECTO

Diseñar e implementar una base de datos relacional normalizada (3FN) para una clínica veterinaria, que permita gestionar de manera eficiente:
- Clientes y sus mascotas
- Citas médicas y veterinarios
- Historial médico y tratamientos
- Vacunación y control sanitario
- Servicios adicionales (estética, hospedaje, etc.)

---

## 📁 ENTREGABLES DEL PROYECTO

### ✅ FASE 1: DISEÑO DE BASE DE DATOS

| # | Documento | Descripción | Estado |
|---|-----------|-------------|--------|
| 1 | `veterinaria_db_design.md` | Proceso completo de normalización (0FN → 3FN) | ✅ Completado |
| 2 | `veterinaria_mer.md` | Modelo Entidad-Relación con diagramas | ✅ Completado |
| 3 | `veterinaria_modelo_relacional.md` | Modelo Relacional con notación formal | ✅ Completado |
| 4 | `veterinaria_db_creation.sql` | Script de creación de BD en SQL Server | ✅ Completado |
| 5 | `veterinaria_seed_data.sql` | Datos de prueba para todas las tablas | ✅ Completado |
| 6 | `veterinaria_queries.sql` | 12 consultas SQL avanzadas | ✅ Completado |

---

## 🗂️ ESTRUCTURA DE LA BASE DE DATOS

### Estadísticas Generales

```
Total de Tablas:           19
Total de Relaciones (FK):  28
Total de Constraints:      45+
Total de Índices:          27+
Normalización:             3FN (Tercera Forma Normal)
Motor de BD:               Microsoft SQL Server 2019+
```

### Módulos del Sistema

#### 1️⃣ **MÓDULO DE UBICACIONES** (2 tablas)
- `PROVINCIAS` - Provincias del país
- `CIUDADES` - Ciudades por provincia

#### 2️⃣ **MÓDULO DE CLIENTES** (2 tablas)
- `CLIENTES` - Información de los dueños
- `TELEFONOS_CLIENTE` - Teléfonos de contacto (múltiples)

#### 3️⃣ **MÓDULO DE MASCOTAS** (3 tablas)
- `ESPECIES` - Catálogo de especies (perro, gato, ave, etc.)
- `RAZAS` - Razas por especie
- `MASCOTAS` - Registro de mascotas

#### 4️⃣ **MÓDULO DE VETERINARIOS** (2 tablas)
- `ESPECIALIDADES` - Especialidades médicas
- `VETERINARIOS` - Personal veterinario

#### 5️⃣ **MÓDULO DE CITAS** (1 tabla)
- `CITAS` - Agenda de citas médicas

#### 6️⃣ **MÓDULO DE HISTORIAL MÉDICO** (2 tablas)
- `HISTORIAL_MEDICO` - Registros de consultas
- `TRATAMIENTOS` - Tratamientos prescritos

#### 7️⃣ **MÓDULO DE MEDICAMENTOS** (2 tablas)
- `MEDICAMENTOS` - Catálogo de medicamentos
- `MEDICAMENTOS_RECETADOS` - Recetas médicas

#### 8️⃣ **MÓDULO DE VACUNAS** (2 tablas)
- `VACUNAS` - Catálogo de vacunas
- `VACUNAS_APLICADAS` - Registro de vacunación

#### 9️⃣ **MÓDULO DE SERVICIOS** (3 tablas)
- `SERVICIOS` - Catálogo de servicios (baño, peluquería, etc.)
- `EMPLEADOS` - Personal no veterinario
- `SERVICIOS_REALIZADOS` - Servicios prestados

---

## 🔄 PROCESO DE NORMALIZACIÓN

### Evolución del Diseño

| Forma Normal | # Tablas | Mejoras Logradas |
|--------------|----------|------------------|
| **0FN** (Inicial) | 1 | Tabla caótica con todo mezclado |
| **1FN** | 8 | ✓ Valores atómicos<br>✓ Sin grupos repetitivos |
| **2FN** | 13 | ✓ Sin dependencias parciales<br>✓ Catálogos separados |
| **3FN** | 19 | ✓ Sin dependencias transitivas<br>✓ Máxima normalización |

### Ejemplos de Normalización Aplicada

**Problema Original (0FN):**
```
REGISTRO_CLINICA
├── Cliente_Nombre, Cliente_Apellido, Cliente_Telefono1, Cliente_Telefono2
├── Mascota_Nombre, Mascota_Raza, Mascota_Peso
├── Vacuna_Nombre, Vacuna_Fecha, Vacuna_Proxima
└── (Todo en una sola tabla = Redundancia masiva)
```

**Solución (3FN):**
```
CLIENTES → MASCOTAS → VACUNAS_APLICADAS → VACUNAS
          ↓
          TELEFONOS_CLIENTE
```

---

## 📊 CONSULTAS SQL IMPLEMENTADAS

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

## 🚀 INSTRUCCIONES DE INSTALACIÓN

### Paso 1: Crear la Base de Datos
```sql
-- Ejecutar en SQL Server Management Studio (SSMS)
-- o en Azure Data Studio

-- 1. Abrir el archivo: veterinaria_db_creation.sql
-- 2. Ejecutar el script completo (F5)
-- 3. Verificar que se crearon las 19 tablas
```

### Paso 2: Cargar Datos de Prueba
```sql
-- 1. Abrir el archivo: veterinaria_seed_data.sql
-- 2. Ejecutar el script completo (F5)
-- 3. Verificar el resumen de datos insertados
```

### Paso 3: Ejecutar Consultas de Prueba
```sql
-- 1. Abrir el archivo: veterinaria_queries.sql
-- 2. Ejecutar consulta por consulta (o todas juntas)
-- 3. Analizar los resultados
```

---

## 📈 DATOS DE PRUEBA INCLUIDOS

```
Provincias:              4
Ciudades:                8
Clientes:                8
Teléfonos:              10
Especies:                5
Razas:                  14
Mascotas:               12
Especialidades:          6
Veterinarios:            5
Citas:                  11
Historiales Médicos:     5
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

## 🔑 CARACTERÍSTICAS DESTACADAS

### Integridad Referencial
- ✅ Todas las relaciones implementadas con FOREIGN KEYs
- ✅ Reglas ON DELETE CASCADE donde corresponde
- ✅ Reglas ON DELETE RESTRICT para proteger datos críticos

### Validaciones de Negocio
- ✅ CHECK constraints para estados y dominios
- ✅ UNIQUE constraints para evitar duplicados
- ✅ Validaciones de fechas y rangos numéricos

### Optimización
- ✅ Índices en columnas de búsqueda frecuente
- ✅ Índices compuestos para consultas complejas
- ✅ Índices filtrados para mejorar performance

### Seguridad de Datos
- ✅ Claves primarias autoincrementales (IDENTITY)
- ✅ Campos de auditoría (Fecha_Registro, Fecha_Creacion)
- ✅ Campos de estado para soft-delete

---

## 🎨 MODELO ENTIDAD-RELACIÓN

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

- Cliente → Mascota: **1:N** (Un cliente puede tener múltiples mascotas)
- Mascota → Cita: **1:N** (Una mascota puede tener múltiples citas)
- Cita → Historial: **1:1** (Una cita genera máximo un historial)
- Tratamiento → Medicamento: **N:M** (Relación muchos a muchos)
- Mascota → Vacuna: **N:M** (Una mascota recibe varias vacunas)

---

## 💡 CASOS DE USO CUBIERTOS

### ✅ Gestión de Clientes
- Registro de clientes con ubicación completa
- Múltiples teléfonos de contacto
- Historial de mascotas por cliente

### ✅ Gestión de Mascotas
- Registro detallado (especie, raza, microchip, etc.)
- Seguimiento de edad y peso
- Control de estado (activo/fallecido/adoptado)

### ✅ Agenda Médica
- Programación de citas por veterinario
- Prevención de conflictos de horarios
- Estados de cita (pendiente/completada/cancelada)

### ✅ Historial Médico
- Registro de consultas con signos vitales
- Diagnósticos y observaciones
- Trazabilidad veterinario-mascota

### ✅ Tratamientos
- Prescripción de medicamentos con dosis exactas
- Control de fechas de inicio/fin
- Seguimiento de tratamientos activos

### ✅ Control de Vacunación
- Registro de vacunas aplicadas
- Alertas de revacunación
- Historial completo por mascota

### ✅ Servicios Adicionales
- Gestión de servicios estéticos y de cuidado
- Facturación y control de pagos
- Asignación de empleados

---

## 🔮 PRÓXIMOS PASOS (Fases Siguientes)

### FASE 2: Arquitectura con PostgreSQL y Docker
- [ ] Migración del esquema a PostgreSQL
- [ ] Configuración de PostgREST (API REST automática)
- [ ] Docker Compose para orquestación
- [ ] Variables de entorno y configuración

### FASE 3: Backend
- [ ] API REST con endpoints CRUD
- [ ] Autenticación y autorización
- [ ] Validaciones de negocio
- [ ] Documentación con Swagger/OpenAPI

### FASE 4: Frontend
- [ ] Interfaz web (React/Vue/Angular)
- [ ] Dashboard administrativo
- [ ] Módulo de citas
- [ ] Módulo de historiales médicos
- [ ] Reportes y estadísticas

### FASE 5: Características Avanzadas
- [ ] Sistema de notificaciones (email/SMS)
- [ ] Generación de reportes PDF
- [ ] Respaldos automáticos
- [ ] Logs de auditoría
- [ ] Sistema de roles y permisos

---

## 📞 SOPORTE Y DOCUMENTACIÓN

### Archivos de Documentación
- `veterinaria_db_design.md` - Diseño completo y normalización
- `veterinaria_mer.md` - Modelo Entidad-Relación
- `veterinaria_modelo_relacional.md` - Modelo Relacional detallado

### Scripts SQL
- `veterinaria_db_creation.sql` - Creación de BD
- `veterinaria_seed_data.sql` - Datos de prueba
- `veterinaria_queries.sql` - Consultas avanzadas

---

## ✨ CONCLUSIONES

Este proyecto establece una **base sólida y escalable** para un sistema de gestión de clínica veterinaria completo. La normalización a 3FN garantiza:

✅ **Integridad de datos**: Sin redundancia ni anomalías
✅ **Flexibilidad**: Fácil de extender con nuevos módulos
✅ **Performance**: Optimizado con índices apropiados
✅ **Mantenibilidad**: Estructura clara y bien documentada

La base de datos está lista para ser integrada con:
- API REST (PostgREST, Node.js, Java, etc.)
- Aplicaciones frontend (Web, Mobile)
- Sistemas de reportería
- Herramientas de análisis

---

**Fecha de creación**: Febrero 2025  
**Versión**: 1.0  
**Tecnología**: Microsoft SQL Server 2019+  
**Estado**: ✅ Listo para desarrollo

