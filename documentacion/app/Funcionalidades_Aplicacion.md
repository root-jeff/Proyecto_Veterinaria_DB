# 🐾 FUNCIONALIDADES DE LA APLICACIÓN VETERINARIA

## Información General

**Nombre**: Sistema de Gestión de Clínica Veterinaria  
**Tecnología**: Java 8+ con PostgreSQL  
**Arquitectura**: Patrón DAO (Data Access Object)  
**Ubicación**: `application/`

---

## 📋 Funcionalidades Principales

### 1. 📝 Registrar Nueva Mascota

**Descripción**: Permite registrar una nueva mascota en el sistema asociándola a un cliente existente.

**Proceso**:
- Selección del cliente dueño
- Elección de especie (Perro, Gato, Ave, etc.)
- Selección de raza según la especie
- Captura de datos: nombre, fecha de nacimiento, color, peso, género
- Registro opcional de número de microchip

**Resultado**: Mascota registrada con ID único en la base de datos.

---

### 2. 📅 Asignar Cita a Veterinario

**Descripción**: Programa una cita médica para una mascota con un veterinario específico.

**Proceso**:
- Selección de la mascota
- Elección del veterinario y su especialidad
- Definición de fecha y hora de la cita
- Descripción del motivo de consulta
- Observaciones adicionales (opcional)

**Validaciones**:
- Verificación de disponibilidad del veterinario
- Prevención de conflictos de horario
- Restricción de citas duplicadas

**Resultado**: Cita programada con estado "pendiente".

---

### 3. 📋 Consultar Historial Médico

**Descripción**: Visualiza el historial médico completo de una mascota seleccionada.

**Información Mostrada**:
- Datos generales de la mascota (especie, raza, dueño)
- Lista de todas las consultas médicas previas
- Diagnósticos y tratamientos aplicados
- Datos vitales registrados:
  - Peso
  - Temperatura
  - Frecuencia cardíaca
- Observaciones médicas generales
- Veterinario que atendió cada consulta
- Citas programadas (pasadas y futuras)

**Resultado**: Reporte completo del historial médico.

---

### 4. 📊 Consultas Avanzadas

**Descripción**: Genera reportes estadísticos y analíticos del sistema.

#### 4.1 Estadísticas de Citas por Veterinario
- Total de citas por veterinario
- Citas completadas
- Citas canceladas
- Citas pendientes
- Agrupado por especialidad

#### 4.2 Top 5 Mascotas con Más Consultas
- Ranking de mascotas más atendidas
- Información del dueño
- Total de consultas realizadas
- Fecha de última consulta

#### 4.3 Distribución de Mascotas por Especie
- Conteo de mascotas por especie
- Edad promedio por especie
- Mascota más vieja registrada
- Mascota más joven registrada

**Resultado**: Reportes tabulares con estadísticas del sistema.

---

## ➕ Funcionalidades Adicionales

### 5. 🐕 Listar Todas las Mascotas

**Descripción**: Muestra un listado completo de todas las mascotas activas registradas.

**Información**:
- ID de la mascota
- Nombre
- Especie y raza
- Género
- Peso actual
- Nombre del dueño

---

### 6. 🕐 Ver Próximas Citas

**Descripción**: Muestra las próximas 10 citas programadas en el sistema.

**Información**:
- Fecha y hora de la cita
- Nombre de la mascota
- Veterinario asignado
- Motivo de la consulta
- Estado de la cita

---

## 🔧 Características Técnicas

### Conexión a Base de Datos
- Conexión mediante JDBC a PostgreSQL
- Patrón Singleton para gestión de conexiones
- Configuración externa en `config.properties`

### Seguridad
- Uso de PreparedStatement para prevenir SQL Injection
- Validación de datos de entrada
- Manejo de excepciones SQL

### Interfaz de Usuario
- Menú interactivo en consola
- Navegación numérica intuitiva
- Mensajes de confirmación y error claros
- Formato tabular para visualización de datos

### Consultas SQL
- INNER JOIN para relacionar múltiples tablas
- LEFT JOIN para incluir registros sin relaciones
- Funciones de agregación (COUNT, AVG, MAX, MIN)
- Subconsultas con CASE WHEN

---

## 📊 Tablas de Base de Datos Utilizadas

| Tabla | Uso en la Aplicación |
|-------|---------------------|
| `mascotas` | Registro y consulta de mascotas |
| `clientes` | Selección de dueños |
| `especies` | Catálogo de especies |
| `razas` | Catálogo de razas por especie |
| `veterinarios` | Selección de veterinarios |
| `especialidades` | Información de especialidades médicas |
| `citas` | Programación y consulta de citas |
| `historial_medico` | Consulta de historial clínico |

---

## 🎯 Casos de Uso

### Caso 1: Registro de Nuevo Paciente
1. Cliente llega con mascota nueva
2. Se registra en el sistema
3. Se puede programar cita inmediatamente

### Caso 2: Cita de Seguimiento
1. Cliente solicita cita para mascota existente
2. Sistema muestra veterinarios disponibles
3. Se programa cita verificando disponibilidad

### Caso 3: Revisión de Historial
1. Veterinario necesita contexto del paciente
2. Consulta historial completo antes de atender
3. Toma decisiones informadas

### Caso 4: Análisis Gerencial
1. Administración requiere estadísticas
2. Genera reportes de citas y consultas
3. Identifica tendencias y patrones

---

## 🚀 Ejecución

**Windows**:
```bash
cd application
ejecutar.bat
```

**Linux/Mac**:
```bash
cd application
./ejecutar.sh
```

---

## 📄 Documentación Adicional

- `application/README.md` - Guía completa de instalación
- `application/INICIO_RAPIDO.md` - Guía de inicio rápido
- `application/RESUMEN_PROYECTO.md` - Detalles técnicos completos
- `application/INDEX.md` - Índice de archivos del proyecto

---

**Versión**: 1.0  
**Fecha**: Febrero 2026  
**Estado**: Funcional y completo
