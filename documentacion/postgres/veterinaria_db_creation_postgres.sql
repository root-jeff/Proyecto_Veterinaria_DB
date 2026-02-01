-- =============================================
-- SCRIPT DE CREACIÓN DE BASE DE DATOS
-- SISTEMA DE GESTIÓN DE CLÍNICA VETERINARIA
-- Motor: PostgreSQL 12+
-- Versión: 1.0
-- Normalización: 3FN
-- Migrado desde SQL Server
-- =============================================

-- Eliminar base de datos si existe
DROP DATABASE IF EXISTS veterinariadb;

-- Crear base de datos
CREATE DATABASE veterinariadb
    WITH 
    ENCODING = 'UTF8'
    LC_COLLATE = 'es_ES.UTF-8'
    LC_CTYPE = 'es_ES.UTF-8'
    TEMPLATE = template0;

-- Conectar a la base de datos
\c veterinariadb;

-- =============================================
-- MÓDULO 1: GESTIÓN DE UBICACIONES
-- =============================================

CREATE TABLE provincias (
    id_provincia SERIAL PRIMARY KEY,
    nombre_provincia VARCHAR(100) NOT NULL,
    codigo_provincia VARCHAR(10) NOT NULL UNIQUE,
    pais VARCHAR(100) NOT NULL DEFAULT 'Ecuador',
    CONSTRAINT ck_provincias_nombre CHECK (LENGTH(TRIM(nombre_provincia)) > 0)
);

CREATE TABLE ciudades (
    id_ciudad SERIAL PRIMARY KEY,
    id_provincia INTEGER NOT NULL,
    nombre_ciudad VARCHAR(100) NOT NULL,
    codigo_postal VARCHAR(20),
    CONSTRAINT fk_ciudades_provincia FOREIGN KEY (id_provincia) 
        REFERENCES provincias(id_provincia),
    CONSTRAINT uq_ciudad_provincia UNIQUE (nombre_ciudad, id_provincia)
);

-- =============================================
-- MÓDULO 2: GESTIÓN DE CLIENTES
-- =============================================

CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    direccion_calle VARCHAR(200),
    numero_direccion VARCHAR(20),
    id_ciudad INTEGER NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) NOT NULL DEFAULT 'activo',
    CONSTRAINT fk_clientes_ciudad FOREIGN KEY (id_ciudad) 
        REFERENCES ciudades(id_ciudad),
    CONSTRAINT ck_clientes_estado CHECK (estado IN ('activo', 'inactivo')),
    CONSTRAINT ck_clientes_email CHECK (email LIKE '%@%')
);

CREATE TABLE telefonos_cliente (
    id_telefono SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL,
    numero_telefono VARCHAR(20) NOT NULL,
    tipo_telefono VARCHAR(20) NOT NULL,
    es_principal BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_telefonos_cliente FOREIGN KEY (id_cliente) 
        REFERENCES clientes(id_cliente) ON DELETE CASCADE,
    CONSTRAINT ck_tipo_telefono CHECK (tipo_telefono IN ('móvil', 'casa', 'trabajo')),
    CONSTRAINT uq_cliente_telefono UNIQUE (id_cliente, numero_telefono)
);

-- =============================================
-- MÓDULO 3: GESTIÓN DE MASCOTAS
-- =============================================

CREATE TABLE especies (
    id_especie SERIAL PRIMARY KEY,
    nombre_especie VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(500)
);

CREATE TABLE razas (
    id_raza SERIAL PRIMARY KEY,
    id_especie INTEGER NOT NULL,
    nombre_raza VARCHAR(100) NOT NULL,
    tamaño_promedio VARCHAR(20),
    caracteristicas VARCHAR(1000),
    CONSTRAINT fk_razas_especie FOREIGN KEY (id_especie) 
        REFERENCES especies(id_especie),
    CONSTRAINT ck_tamaño CHECK (tamaño_promedio IN ('pequeño', 'mediano', 'grande', 'gigante')),
    CONSTRAINT uq_raza_especie UNIQUE (nombre_raza, id_especie)
);

CREATE TABLE mascotas (
    id_mascota SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    id_especie INTEGER NOT NULL,
    id_raza INTEGER NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    color VARCHAR(50),
    peso_actual NUMERIC(6,2),
    genero CHAR(1) NOT NULL,
    numero_microchip VARCHAR(50) UNIQUE,
    foto_url VARCHAR(500),
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) NOT NULL DEFAULT 'activo',
    CONSTRAINT fk_mascotas_cliente FOREIGN KEY (id_cliente) 
        REFERENCES clientes(id_cliente),
    CONSTRAINT fk_mascotas_especie FOREIGN KEY (id_especie) 
        REFERENCES especies(id_especie),
    CONSTRAINT fk_mascotas_raza FOREIGN KEY (id_raza) 
        REFERENCES razas(id_raza),
    CONSTRAINT ck_mascota_genero CHECK (genero IN ('M', 'F', 'I')),
    CONSTRAINT ck_mascota_estado CHECK (estado IN ('activo', 'fallecido', 'adoptado')),
    CONSTRAINT ck_mascota_peso CHECK (peso_actual IS NULL OR peso_actual > 0),
    CONSTRAINT ck_mascota_fecha_nacimiento CHECK (fecha_nacimiento < CURRENT_DATE)
);

-- =============================================
-- MÓDULO 4: GESTIÓN DE VETERINARIOS
-- =============================================

CREATE TABLE especialidades (
    id_especialidad SERIAL PRIMARY KEY,
    nombre_especialidad VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(500)
);

CREATE TABLE veterinarios (
    id_veterinario SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    id_especialidad INTEGER NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    numero_licencia VARCHAR(50) NOT NULL UNIQUE,
    fecha_contratacion DATE NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'activo',
    CONSTRAINT fk_veterinarios_especialidad FOREIGN KEY (id_especialidad) 
        REFERENCES especialidades(id_especialidad),
    CONSTRAINT ck_veterinario_estado CHECK (estado IN ('activo', 'inactivo', 'vacaciones')),
    CONSTRAINT ck_veterinario_email CHECK (email LIKE '%@%')
);

-- =============================================
-- MÓDULO 5: GESTIÓN DE CITAS
-- =============================================

CREATE TABLE citas (
    id_cita SERIAL PRIMARY KEY,
    id_mascota INTEGER NOT NULL,
    id_veterinario INTEGER NOT NULL,
    fecha_cita DATE NOT NULL,
    hora_cita TIME NOT NULL,
    motivo_consulta VARCHAR(500) NOT NULL,
    estado_cita VARCHAR(20) NOT NULL DEFAULT 'pendiente',
    observaciones VARCHAR(1000),
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_citas_mascota FOREIGN KEY (id_mascota) 
        REFERENCES mascotas(id_mascota),
    CONSTRAINT fk_citas_veterinario FOREIGN KEY (id_veterinario) 
        REFERENCES veterinarios(id_veterinario),
    CONSTRAINT ck_cita_estado CHECK (estado_cita IN ('pendiente', 'en_proceso', 'completada', 'cancelada', 'no_asistio')),
    CONSTRAINT uq_veterinario_hora UNIQUE (id_veterinario, fecha_cita, hora_cita)
);

-- =============================================
-- MÓDULO 6: HISTORIAL MÉDICO Y TRATAMIENTOS
-- =============================================

CREATE TABLE historial_medico (
    id_historial SERIAL PRIMARY KEY,
    id_cita INTEGER NOT NULL UNIQUE,
    id_mascota INTEGER NOT NULL,
    id_veterinario INTEGER NOT NULL,
    fecha_consulta TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    diagnostico TEXT NOT NULL,
    peso_registrado NUMERIC(6,2),
    temperatura NUMERIC(4,2),
    frecuencia_cardiaca INTEGER,
    observaciones_generales TEXT,
    CONSTRAINT fk_historial_cita FOREIGN KEY (id_cita) 
        REFERENCES citas(id_cita),
    CONSTRAINT fk_historial_mascota FOREIGN KEY (id_mascota) 
        REFERENCES mascotas(id_mascota),
    CONSTRAINT fk_historial_veterinario FOREIGN KEY (id_veterinario) 
        REFERENCES veterinarios(id_veterinario),
    CONSTRAINT ck_historial_peso CHECK (peso_registrado IS NULL OR peso_registrado > 0),
    CONSTRAINT ck_historial_temperatura CHECK (temperatura IS NULL OR temperatura BETWEEN 30 AND 45),
    CONSTRAINT ck_historial_frecuencia CHECK (frecuencia_cardiaca IS NULL OR frecuencia_cardiaca > 0)
);

CREATE TABLE tratamientos (
    id_tratamiento SERIAL PRIMARY KEY,
    id_historial INTEGER NOT NULL,
    descripcion_tratamiento TEXT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    instrucciones TEXT,
    estado VARCHAR(20) NOT NULL DEFAULT 'activo',
    CONSTRAINT fk_tratamientos_historial FOREIGN KEY (id_historial) 
        REFERENCES historial_medico(id_historial) ON DELETE CASCADE,
    CONSTRAINT ck_tratamiento_estado CHECK (estado IN ('activo', 'completado', 'suspendido')),
    CONSTRAINT ck_tratamiento_fechas CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);

-- =============================================
-- MÓDULO 7: MEDICAMENTOS
-- =============================================

CREATE TABLE medicamentos (
    id_medicamento SERIAL PRIMARY KEY,
    nombre_medicamento VARCHAR(200) NOT NULL,
    descripcion VARCHAR(1000),
    laboratorio VARCHAR(200),
    presentacion VARCHAR(100),
    tipo VARCHAR(50) NOT NULL,
    requiere_receta BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT ck_medicamento_tipo CHECK (tipo IN ('antibiótico', 'analgésico', 'antiinflamatorio', 'antiparasitario', 'vitamina', 'suplemento', 'otro')),
    CONSTRAINT uq_medicamento UNIQUE (nombre_medicamento, laboratorio, presentacion)
);

CREATE TABLE medicamentos_recetados (
    id_receta SERIAL PRIMARY KEY,
    id_tratamiento INTEGER NOT NULL,
    id_medicamento INTEGER NOT NULL,
    dosis VARCHAR(100) NOT NULL,
    frecuencia VARCHAR(200) NOT NULL,
    duracion_dias INTEGER NOT NULL,
    via_administracion VARCHAR(50) NOT NULL,
    observaciones VARCHAR(1000),
    CONSTRAINT fk_receta_tratamiento FOREIGN KEY (id_tratamiento) 
        REFERENCES tratamientos(id_tratamiento) ON DELETE CASCADE,
    CONSTRAINT fk_receta_medicamento FOREIGN KEY (id_medicamento) 
        REFERENCES medicamentos(id_medicamento),
    CONSTRAINT ck_receta_via CHECK (via_administracion IN ('oral', 'inyectable', 'tópica', 'oftálmica', 'ótica')),
    CONSTRAINT ck_receta_duracion CHECK (duracion_dias > 0)
);

-- =============================================
-- MÓDULO 8: VACUNAS
-- =============================================

CREATE TABLE vacunas (
    id_vacuna SERIAL PRIMARY KEY,
    nombre_vacuna VARCHAR(200) NOT NULL,
    descripcion VARCHAR(1000),
    enfermedad_previene VARCHAR(500),
    laboratorio VARCHAR(200),
    periodo_revacunacion_dias INTEGER NOT NULL,
    es_obligatoria BOOLEAN NOT NULL DEFAULT FALSE,
    id_especie INTEGER,
    CONSTRAINT fk_vacunas_especie FOREIGN KEY (id_especie) 
        REFERENCES especies(id_especie),
    CONSTRAINT ck_vacuna_periodo CHECK (periodo_revacunacion_dias > 0)
);

CREATE TABLE vacunas_aplicadas (
    id_aplicacion SERIAL PRIMARY KEY,
    id_mascota INTEGER NOT NULL,
    id_vacuna INTEGER NOT NULL,
    id_veterinario INTEGER NOT NULL,
    fecha_aplicacion DATE NOT NULL,
    fecha_proxima_dosis DATE,
    lote VARCHAR(100),
    observaciones VARCHAR(1000),
    reaccion_adversa BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_vacuna_aplicada_mascota FOREIGN KEY (id_mascota) 
        REFERENCES mascotas(id_mascota),
    CONSTRAINT fk_vacuna_aplicada_vacuna FOREIGN KEY (id_vacuna) 
        REFERENCES vacunas(id_vacuna),
    CONSTRAINT fk_vacuna_aplicada_veterinario FOREIGN KEY (id_veterinario) 
        REFERENCES veterinarios(id_veterinario),
    CONSTRAINT ck_vacuna_fecha_proxima CHECK (fecha_proxima_dosis IS NULL OR fecha_proxima_dosis > fecha_aplicacion),
    CONSTRAINT uq_vacuna_aplicacion UNIQUE (id_mascota, id_vacuna, fecha_aplicacion)
);

-- =============================================
-- MÓDULO 9: SERVICIOS
-- =============================================

CREATE TABLE servicios (
    id_servicio SERIAL PRIMARY KEY,
    nombre_servicio VARCHAR(200) NOT NULL UNIQUE,
    descripcion VARCHAR(1000),
    precio_base NUMERIC(10,2) NOT NULL,
    duracion_estimada_min INTEGER NOT NULL,
    tipo_servicio VARCHAR(50) NOT NULL,
    CONSTRAINT ck_servicio_precio CHECK (precio_base >= 0),
    CONSTRAINT ck_servicio_duracion CHECK (duracion_estimada_min > 0),
    CONSTRAINT ck_servicio_tipo CHECK (tipo_servicio IN ('estética', 'salud', 'hospedaje', 'adiestramiento'))
);

CREATE TABLE empleados (
    id_empleado SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    puesto VARCHAR(50) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    fecha_contratacion DATE NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'activo',
    CONSTRAINT ck_empleado_puesto CHECK (puesto IN ('groomer', 'recepcionista', 'asistente', 'cuidador', 'adiestrador')),
    CONSTRAINT ck_empleado_estado CHECK (estado IN ('activo', 'inactivo'))
);

CREATE TABLE servicios_realizados (
    id_servicio_realizado SERIAL PRIMARY KEY,
    id_mascota INTEGER NOT NULL,
    id_servicio INTEGER NOT NULL,
    id_empleado INTEGER NOT NULL,
    fecha_servicio DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME,
    precio_final NUMERIC(10,2) NOT NULL,
    estado_pago VARCHAR(20) NOT NULL DEFAULT 'pendiente',
    observaciones VARCHAR(1000),
    CONSTRAINT fk_servicio_realizado_mascota FOREIGN KEY (id_mascota) 
        REFERENCES mascotas(id_mascota),
    CONSTRAINT fk_servicio_realizado_servicio FOREIGN KEY (id_servicio) 
        REFERENCES servicios(id_servicio),
    CONSTRAINT fk_servicio_realizado_empleado FOREIGN KEY (id_empleado) 
        REFERENCES empleados(id_empleado),
    CONSTRAINT ck_servicio_estado_pago CHECK (estado_pago IN ('pendiente', 'pagado', 'cancelado')),
    CONSTRAINT ck_servicio_precio CHECK (precio_final >= 0),
    CONSTRAINT ck_servicio_horas CHECK (hora_fin IS NULL OR hora_fin > hora_inicio)
);

-- =============================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- =============================================

-- Búsquedas frecuentes por cliente
CREATE INDEX idx_mascotas_cliente ON mascotas(id_cliente);

-- Búsqueda por microchip
CREATE INDEX idx_mascotas_microchip ON mascotas(numero_microchip) WHERE numero_microchip IS NOT NULL;

-- Citas por fecha y veterinario
CREATE INDEX idx_citas_fecha ON citas(fecha_cita, hora_cita);
CREATE INDEX idx_citas_veterinario_fecha ON citas(id_veterinario, fecha_cita);

-- Historial por mascota
CREATE INDEX idx_historial_mascota ON historial_medico(id_mascota);

-- Vacunas próximas a vencer
CREATE INDEX idx_vacunas_proxima_dosis ON vacunas_aplicadas(fecha_proxima_dosis) WHERE fecha_proxima_dosis IS NOT NULL;

-- Búsquedas por nombre (autocompletado)
CREATE INDEX idx_clientes_apellido ON clientes(apellido, nombre);
CREATE INDEX idx_veterinarios_apellido ON veterinarios(apellido, nombre);
CREATE INDEX idx_mascotas_nombre ON mascotas(nombre);

-- =============================================
-- COMENTARIOS EN TABLAS
-- =============================================

COMMENT ON DATABASE veterinariadb IS 'Sistema de Gestión de Clínica Veterinaria';
COMMENT ON TABLE provincias IS 'Provincias donde opera la clínica';
COMMENT ON TABLE ciudades IS 'Ciudades por provincia';
COMMENT ON TABLE clientes IS 'Información de clientes propietarios de mascotas';
COMMENT ON TABLE mascotas IS 'Registro de mascotas de los clientes';
COMMENT ON TABLE veterinarios IS 'Veterinarios que trabajan en la clínica';
COMMENT ON TABLE citas IS 'Citas programadas para atención veterinaria';
COMMENT ON TABLE historial_medico IS 'Historial médico de las mascotas';
COMMENT ON TABLE tratamientos IS 'Tratamientos prescritos';
COMMENT ON TABLE medicamentos IS 'Catálogo de medicamentos';
COMMENT ON TABLE vacunas IS 'Catálogo de vacunas disponibles';
COMMENT ON TABLE servicios IS 'Servicios adicionales ofrecidos';

-- Mensaje de confirmación
DO $$
BEGIN
    RAISE NOTICE 'Base de datos creada exitosamente!';
    RAISE NOTICE 'Total de tablas: 19';
    RAISE NOTICE 'Total de índices adicionales: 8';
    RAISE NOTICE 'Motor: PostgreSQL';
END $$;
