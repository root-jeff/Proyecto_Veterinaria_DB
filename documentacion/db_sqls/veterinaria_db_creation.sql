-- =============================================
-- SCRIPT DE CREACIÓN DE BASE DE DATOS
-- SISTEMA DE GESTIÓN DE CLÍNICA VETERINARIA
-- Motor: Microsoft SQL Server 2019+
-- Versión: 1.0
-- Normalización: 3FN
-- =============================================

USE master;
GO

-- Eliminar base de datos si existe
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'VeterinariaDB')
BEGIN
    ALTER DATABASE VeterinariaDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE VeterinariaDB;
END
GO

-- Crear base de datos
CREATE DATABASE VeterinariaDB;
GO

USE VeterinariaDB;
GO

-- =============================================
-- MÓDULO 1: GESTIÓN DE UBICACIONES
-- =============================================

CREATE TABLE PROVINCIAS (
    ID_Provincia INT IDENTITY(1,1) PRIMARY KEY,
    Nombre_Provincia NVARCHAR(100) NOT NULL,
    Codigo_Provincia NVARCHAR(10) NOT NULL UNIQUE,
    Pais NVARCHAR(100) NOT NULL DEFAULT 'Ecuador',
    CONSTRAINT CK_Provincias_Nombre CHECK (LEN(RTRIM(Nombre_Provincia)) > 0)
);
GO

CREATE TABLE CIUDADES (
    ID_Ciudad INT IDENTITY(1,1) PRIMARY KEY,
    ID_Provincia INT NOT NULL,
    Nombre_Ciudad NVARCHAR(100) NOT NULL,
    Codigo_Postal NVARCHAR(20),
    CONSTRAINT FK_Ciudades_Provincia FOREIGN KEY (ID_Provincia) 
        REFERENCES PROVINCIAS(ID_Provincia),
    CONSTRAINT UQ_Ciudad_Provincia UNIQUE (Nombre_Ciudad, ID_Provincia)
);
GO

-- =============================================
-- MÓDULO 2: GESTIÓN DE CLIENTES
-- =============================================

CREATE TABLE CLIENTES (
    ID_Cliente INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    Direccion_Calle NVARCHAR(200),
    Numero_Direccion NVARCHAR(20),
    ID_Ciudad INT NOT NULL,
    Email NVARCHAR(150) NOT NULL UNIQUE,
    Fecha_Registro DATETIME NOT NULL DEFAULT GETDATE(),
    Estado NVARCHAR(20) NOT NULL DEFAULT 'activo',
    CONSTRAINT FK_Clientes_Ciudad FOREIGN KEY (ID_Ciudad) 
        REFERENCES CIUDADES(ID_Ciudad),
    CONSTRAINT CK_Clientes_Estado CHECK (Estado IN ('activo', 'inactivo')),
    CONSTRAINT CK_Clientes_Email CHECK (Email LIKE '%@%')
);
GO

CREATE TABLE TELEFONOS_CLIENTE (
    ID_Telefono INT IDENTITY(1,1) PRIMARY KEY,
    ID_Cliente INT NOT NULL,
    Numero_Telefono NVARCHAR(20) NOT NULL,
    Tipo_Telefono NVARCHAR(20) NOT NULL,
    Es_Principal BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_Telefonos_Cliente FOREIGN KEY (ID_Cliente) 
        REFERENCES CLIENTES(ID_Cliente) ON DELETE CASCADE,
    CONSTRAINT CK_Tipo_Telefono CHECK (Tipo_Telefono IN ('móvil', 'casa', 'trabajo')),
    CONSTRAINT UQ_Cliente_Telefono UNIQUE (ID_Cliente, Numero_Telefono)
);
GO

-- =============================================
-- MÓDULO 3: GESTIÓN DE MASCOTAS
-- =============================================

CREATE TABLE ESPECIES (
    ID_Especie INT IDENTITY(1,1) PRIMARY KEY,
    Nombre_Especie NVARCHAR(50) NOT NULL UNIQUE,
    Descripcion NVARCHAR(500)
);
GO

CREATE TABLE RAZAS (
    ID_Raza INT IDENTITY(1,1) PRIMARY KEY,
    ID_Especie INT NOT NULL,
    Nombre_Raza NVARCHAR(100) NOT NULL,
    Tamaño_Promedio NVARCHAR(20),
    Caracteristicas NVARCHAR(1000),
    CONSTRAINT FK_Razas_Especie FOREIGN KEY (ID_Especie) 
        REFERENCES ESPECIES(ID_Especie),
    CONSTRAINT CK_Tamaño CHECK (Tamaño_Promedio IN ('pequeño', 'mediano', 'grande', 'gigante')),
    CONSTRAINT UQ_Raza_Especie UNIQUE (Nombre_Raza, ID_Especie)
);
GO

CREATE TABLE MASCOTAS (
    ID_Mascota INT IDENTITY(1,1) PRIMARY KEY,
    ID_Cliente INT NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    ID_Especie INT NOT NULL,
    ID_Raza INT NOT NULL,
    Fecha_Nacimiento DATE NOT NULL,
    Color NVARCHAR(50),
    Peso_Actual DECIMAL(6,2),
    Genero CHAR(1) NOT NULL,
    Numero_Microchip NVARCHAR(50) UNIQUE,
    Foto_URL NVARCHAR(500),
    Fecha_Registro DATETIME NOT NULL DEFAULT GETDATE(),
    Estado NVARCHAR(20) NOT NULL DEFAULT 'activo',
    CONSTRAINT FK_Mascotas_Cliente FOREIGN KEY (ID_Cliente) 
        REFERENCES CLIENTES(ID_Cliente),
    CONSTRAINT FK_Mascotas_Especie FOREIGN KEY (ID_Especie) 
        REFERENCES ESPECIES(ID_Especie),
    CONSTRAINT FK_Mascotas_Raza FOREIGN KEY (ID_Raza) 
        REFERENCES RAZAS(ID_Raza),
    CONSTRAINT CK_Mascota_Genero CHECK (Genero IN ('M', 'F', 'I')),
    CONSTRAINT CK_Mascota_Estado CHECK (Estado IN ('activo', 'fallecido', 'adoptado')),
    CONSTRAINT CK_Mascota_Peso CHECK (Peso_Actual IS NULL OR Peso_Actual > 0),
    CONSTRAINT CK_Mascota_Fecha_Nacimiento CHECK (Fecha_Nacimiento < GETDATE())
);
GO

-- =============================================
-- MÓDULO 4: GESTIÓN DE VETERINARIOS
-- =============================================

CREATE TABLE ESPECIALIDADES (
    ID_Especialidad INT IDENTITY(1,1) PRIMARY KEY,
    Nombre_Especialidad NVARCHAR(100) NOT NULL UNIQUE,
    Descripcion NVARCHAR(500)
);
GO

CREATE TABLE VETERINARIOS (
    ID_Veterinario INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    ID_Especialidad INT NOT NULL,
    Telefono NVARCHAR(20) NOT NULL,
    Email NVARCHAR(150) NOT NULL UNIQUE,
    Numero_Licencia NVARCHAR(50) NOT NULL UNIQUE,
    Fecha_Contratacion DATE NOT NULL,
    Fecha_Nacimiento DATE NOT NULL,
    Estado NVARCHAR(20) NOT NULL DEFAULT 'activo',
    CONSTRAINT FK_Veterinarios_Especialidad FOREIGN KEY (ID_Especialidad) 
        REFERENCES ESPECIALIDADES(ID_Especialidad),
    CONSTRAINT CK_Veterinario_Estado CHECK (Estado IN ('activo', 'inactivo', 'vacaciones')),
    CONSTRAINT CK_Veterinario_Email CHECK (Email LIKE '%@%')
);
GO

-- =============================================
-- MÓDULO 5: GESTIÓN DE CITAS
-- =============================================

CREATE TABLE CITAS (
    ID_Cita INT IDENTITY(1,1) PRIMARY KEY,
    ID_Mascota INT NOT NULL,
    ID_Veterinario INT NOT NULL,
    Fecha_Cita DATE NOT NULL,
    Hora_Cita TIME NOT NULL,
    Motivo_Consulta NVARCHAR(500) NOT NULL,
    Estado_Cita NVARCHAR(20) NOT NULL DEFAULT 'pendiente',
    Observaciones NVARCHAR(1000),
    Fecha_Creacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Citas_Mascota FOREIGN KEY (ID_Mascota) 
        REFERENCES MASCOTAS(ID_Mascota),
    CONSTRAINT FK_Citas_Veterinario FOREIGN KEY (ID_Veterinario) 
        REFERENCES VETERINARIOS(ID_Veterinario),
    CONSTRAINT CK_Cita_Estado CHECK (Estado_Cita IN ('pendiente', 'en_proceso', 'completada', 'cancelada', 'no_asistio')),
    CONSTRAINT UQ_Veterinario_Hora UNIQUE (ID_Veterinario, Fecha_Cita, Hora_Cita)
);
GO

-- =============================================
-- MÓDULO 6: HISTORIAL MÉDICO Y TRATAMIENTOS
-- =============================================

CREATE TABLE HISTORIAL_MEDICO (
    ID_Historial INT IDENTITY(1,1) PRIMARY KEY,
    ID_Cita INT NOT NULL UNIQUE,
    ID_Mascota INT NOT NULL,
    ID_Veterinario INT NOT NULL,
    Fecha_Consulta DATETIME NOT NULL DEFAULT GETDATE(),
    Diagnostico NVARCHAR(MAX) NOT NULL,
    Peso_Registrado DECIMAL(6,2),
    Temperatura DECIMAL(4,2),
    Frecuencia_Cardiaca INT,
    Observaciones_Generales NVARCHAR(MAX),
    CONSTRAINT FK_Historial_Cita FOREIGN KEY (ID_Cita) 
        REFERENCES CITAS(ID_Cita),
    CONSTRAINT FK_Historial_Mascota FOREIGN KEY (ID_Mascota) 
        REFERENCES MASCOTAS(ID_Mascota),
    CONSTRAINT FK_Historial_Veterinario FOREIGN KEY (ID_Veterinario) 
        REFERENCES VETERINARIOS(ID_Veterinario),
    CONSTRAINT CK_Historial_Peso CHECK (Peso_Registrado IS NULL OR Peso_Registrado > 0),
    CONSTRAINT CK_Historial_Temperatura CHECK (Temperatura IS NULL OR Temperatura BETWEEN 30 AND 45),
    CONSTRAINT CK_Historial_Frecuencia CHECK (Frecuencia_Cardiaca IS NULL OR Frecuencia_Cardiaca > 0)
);
GO

CREATE TABLE TRATAMIENTOS (
    ID_Tratamiento INT IDENTITY(1,1) PRIMARY KEY,
    ID_Historial INT NOT NULL,
    Descripcion_Tratamiento NVARCHAR(MAX) NOT NULL,
    Fecha_Inicio DATE NOT NULL,
    Fecha_Fin DATE,
    Instrucciones NVARCHAR(MAX),
    Estado NVARCHAR(20) NOT NULL DEFAULT 'activo',
    CONSTRAINT FK_Tratamientos_Historial FOREIGN KEY (ID_Historial) 
        REFERENCES HISTORIAL_MEDICO(ID_Historial) ON DELETE CASCADE,
    CONSTRAINT CK_Tratamiento_Estado CHECK (Estado IN ('activo', 'completado', 'suspendido')),
    CONSTRAINT CK_Tratamiento_Fechas CHECK (Fecha_Fin IS NULL OR Fecha_Fin >= Fecha_Inicio)
);
GO

-- =============================================
-- MÓDULO 7: MEDICAMENTOS
-- =============================================

CREATE TABLE MEDICAMENTOS (
    ID_Medicamento INT IDENTITY(1,1) PRIMARY KEY,
    Nombre_Medicamento NVARCHAR(200) NOT NULL,
    Descripcion NVARCHAR(1000),
    Laboratorio NVARCHAR(200),
    Presentacion NVARCHAR(100),
    Tipo NVARCHAR(50) NOT NULL,
    Requiere_Receta BIT NOT NULL DEFAULT 1,
    CONSTRAINT CK_Medicamento_Tipo CHECK (Tipo IN ('antibiótico', 'analgésico', 'antiinflamatorio', 'antiparasitario', 'vitamina', 'suplemento', 'otro')),
    CONSTRAINT UQ_Medicamento UNIQUE (Nombre_Medicamento, Laboratorio, Presentacion)
);
GO

CREATE TABLE MEDICAMENTOS_RECETADOS (
    ID_Receta INT IDENTITY(1,1) PRIMARY KEY,
    ID_Tratamiento INT NOT NULL,
    ID_Medicamento INT NOT NULL,
    Dosis NVARCHAR(100) NOT NULL,
    Frecuencia NVARCHAR(200) NOT NULL,
    Duracion_Dias INT NOT NULL,
    Via_Administracion NVARCHAR(50) NOT NULL,
    Observaciones NVARCHAR(1000),
    CONSTRAINT FK_Receta_Tratamiento FOREIGN KEY (ID_Tratamiento) 
        REFERENCES TRATAMIENTOS(ID_Tratamiento) ON DELETE CASCADE,
    CONSTRAINT FK_Receta_Medicamento FOREIGN KEY (ID_Medicamento) 
        REFERENCES MEDICAMENTOS(ID_Medicamento),
    CONSTRAINT CK_Receta_Via CHECK (Via_Administracion IN ('oral', 'inyectable', 'tópica', 'oftálmica', 'ótica')),
    CONSTRAINT CK_Receta_Duracion CHECK (Duracion_Dias > 0)
);
GO

-- =============================================
-- MÓDULO 8: VACUNAS
-- =============================================

CREATE TABLE VACUNAS (
    ID_Vacuna INT IDENTITY(1,1) PRIMARY KEY,
    Nombre_Vacuna NVARCHAR(200) NOT NULL,
    Descripcion NVARCHAR(1000),
    Enfermedad_Previene NVARCHAR(500),
    Laboratorio NVARCHAR(200),
    Periodo_Revacunacion_Dias INT NOT NULL,
    Es_Obligatoria BIT NOT NULL DEFAULT 0,
    ID_Especie INT,
    CONSTRAINT FK_Vacunas_Especie FOREIGN KEY (ID_Especie) 
        REFERENCES ESPECIES(ID_Especie),
    CONSTRAINT CK_Vacuna_Periodo CHECK (Periodo_Revacunacion_Dias > 0)
);
GO

CREATE TABLE VACUNAS_APLICADAS (
    ID_Aplicacion INT IDENTITY(1,1) PRIMARY KEY,
    ID_Mascota INT NOT NULL,
    ID_Vacuna INT NOT NULL,
    ID_Veterinario INT NOT NULL,
    Fecha_Aplicacion DATE NOT NULL,
    Fecha_Proxima_Dosis DATE,
    Lote NVARCHAR(100),
    Observaciones NVARCHAR(1000),
    Reaccion_Adversa BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_Vacuna_Aplicada_Mascota FOREIGN KEY (ID_Mascota) 
        REFERENCES MASCOTAS(ID_Mascota),
    CONSTRAINT FK_Vacuna_Aplicada_Vacuna FOREIGN KEY (ID_Vacuna) 
        REFERENCES VACUNAS(ID_Vacuna),
    CONSTRAINT FK_Vacuna_Aplicada_Veterinario FOREIGN KEY (ID_Veterinario) 
        REFERENCES VETERINARIOS(ID_Veterinario),
    CONSTRAINT CK_Vacuna_Fecha_Proxima CHECK (Fecha_Proxima_Dosis IS NULL OR Fecha_Proxima_Dosis > Fecha_Aplicacion),
    CONSTRAINT UQ_Vacuna_Aplicacion UNIQUE (ID_Mascota, ID_Vacuna, Fecha_Aplicacion)
);
GO

-- =============================================
-- MÓDULO 9: SERVICIOS
-- =============================================

CREATE TABLE SERVICIOS (
    ID_Servicio INT IDENTITY(1,1) PRIMARY KEY,
    Nombre_Servicio NVARCHAR(200) NOT NULL UNIQUE,
    Descripcion NVARCHAR(1000),
    Precio_Base DECIMAL(10,2) NOT NULL,
    Duracion_Estimada_Min INT NOT NULL,
    Tipo_Servicio NVARCHAR(50) NOT NULL,
    CONSTRAINT CK_Servicio_Precio CHECK (Precio_Base >= 0),
    CONSTRAINT CK_Servicio_Duracion CHECK (Duracion_Estimada_Min > 0),
    CONSTRAINT CK_Servicio_Tipo CHECK (Tipo_Servicio IN ('estética', 'salud', 'hospedaje', 'adiestramiento'))
);
GO

CREATE TABLE EMPLEADOS (
    ID_Empleado INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    Puesto NVARCHAR(50) NOT NULL,
    Telefono NVARCHAR(20) NOT NULL,
    Email NVARCHAR(150) NOT NULL UNIQUE,
    Fecha_Contratacion DATE NOT NULL,
    Estado NVARCHAR(20) NOT NULL DEFAULT 'activo',
    CONSTRAINT CK_Empleado_Puesto CHECK (Puesto IN ('groomer', 'recepcionista', 'asistente', 'cuidador', 'adiestrador')),
    CONSTRAINT CK_Empleado_Estado CHECK (Estado IN ('activo', 'inactivo'))
);
GO

CREATE TABLE SERVICIOS_REALIZADOS (
    ID_Servicio_Realizado INT IDENTITY(1,1) PRIMARY KEY,
    ID_Mascota INT NOT NULL,
    ID_Servicio INT NOT NULL,
    ID_Empleado INT NOT NULL,
    Fecha_Servicio DATE NOT NULL,
    Hora_Inicio TIME NOT NULL,
    Hora_Fin TIME,
    Precio_Final DECIMAL(10,2) NOT NULL,
    Estado_Pago NVARCHAR(20) NOT NULL DEFAULT 'pendiente',
    Observaciones NVARCHAR(1000),
    CONSTRAINT FK_Servicio_Realizado_Mascota FOREIGN KEY (ID_Mascota) 
        REFERENCES MASCOTAS(ID_Mascota),
    CONSTRAINT FK_Servicio_Realizado_Servicio FOREIGN KEY (ID_Servicio) 
        REFERENCES SERVICIOS(ID_Servicio),
    CONSTRAINT FK_Servicio_Realizado_Empleado FOREIGN KEY (ID_Empleado) 
        REFERENCES EMPLEADOS(ID_Empleado),
    CONSTRAINT CK_Servicio_Estado_Pago CHECK (Estado_Pago IN ('pendiente', 'pagado', 'cancelado')),
    CONSTRAINT CK_Servicio_Precio CHECK (Precio_Final >= 0),
    CONSTRAINT CK_Servicio_Horas CHECK (Hora_Fin IS NULL OR Hora_Fin > Hora_Inicio)
);
GO

-- =============================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- =============================================

-- Búsquedas frecuentes por cliente
CREATE NONCLUSTERED INDEX idx_Mascotas_Cliente ON MASCOTAS(ID_Cliente);
GO

-- Búsqueda por microchip (ya tiene UNIQUE, pero mejora performance)
CREATE NONCLUSTERED INDEX idx_Mascotas_Microchip ON MASCOTAS(Numero_Microchip) WHERE Numero_Microchip IS NOT NULL;
GO

-- Citas por fecha y veterinario
CREATE NONCLUSTERED INDEX idx_Citas_Fecha ON CITAS(Fecha_Cita, Hora_Cita);
CREATE NONCLUSTERED INDEX idx_Citas_Veterinario_Fecha ON CITAS(ID_Veterinario, Fecha_Cita);
GO

-- Historial por mascota
CREATE NONCLUSTERED INDEX idx_Historial_Mascota ON HISTORIAL_MEDICO(ID_Mascota);
GO

-- Vacunas próximas a vencer
CREATE NONCLUSTERED INDEX idx_Vacunas_Proxima_Dosis ON VACUNAS_APLICADAS(Fecha_Proxima_Dosis) WHERE Fecha_Proxima_Dosis IS NOT NULL;
GO

-- Búsquedas por nombre (autocompletado)
CREATE NONCLUSTERED INDEX idx_Clientes_Apellido ON CLIENTES(Apellido, Nombre);
CREATE NONCLUSTERED INDEX idx_Veterinarios_Apellido ON VETERINARIOS(Apellido, Nombre);
CREATE NONCLUSTERED INDEX idx_Mascotas_Nombre ON MASCOTAS(Nombre);
GO

PRINT 'Base de datos creada exitosamente!';
PRINT 'Total de tablas: 19';
PRINT 'Total de índices adicionales: 8';
GO
