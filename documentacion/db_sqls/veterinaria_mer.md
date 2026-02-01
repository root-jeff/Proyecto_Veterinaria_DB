# MODELO ENTIDAD-RELACIÓN (MER) - CLÍNICA VETERINARIA

## Diagrama ER Completo

```mermaid
erDiagram
    CLIENTES ||--o{ MASCOTAS : "posee"
    CLIENTES ||--o{ TELEFONOS_CLIENTE : "tiene"
    CLIENTES }o--|| CIUDADES : "reside_en"
    
    CIUDADES }o--|| PROVINCIAS : "pertenece_a"
    
    MASCOTAS }o--|| ESPECIES : "es_de_tipo"
    MASCOTAS }o--|| RAZAS : "es_de_raza"
    MASCOTAS ||--o{ CITAS : "asiste_a"
    MASCOTAS ||--o{ HISTORIAL_MEDICO : "tiene"
    MASCOTAS ||--o{ VACUNAS_APLICADAS : "recibe"
    MASCOTAS ||--o{ SERVICIOS_REALIZADOS : "utiliza"
    
    ESPECIES ||--o{ RAZAS : "incluye"
    ESPECIES ||--o{ VACUNAS : "requiere"
    
    VETERINARIOS }o--|| ESPECIALIDADES : "tiene"
    VETERINARIOS ||--o{ CITAS : "atiende"
    VETERINARIOS ||--o{ HISTORIAL_MEDICO : "registra"
    VETERINARIOS ||--o{ VACUNAS_APLICADAS : "aplica"
    
    CITAS ||--o| HISTORIAL_MEDICO : "genera"
    
    HISTORIAL_MEDICO ||--o{ TRATAMIENTOS : "incluye"
    
    TRATAMIENTOS ||--o{ MEDICAMENTOS_RECETADOS : "prescribe"
    
    MEDICAMENTOS_RECETADOS }o--|| MEDICAMENTOS : "utiliza"
    
    VACUNAS_APLICADAS }o--|| VACUNAS : "utiliza"
    
    SERVICIOS_REALIZADOS }o--|| SERVICIOS : "se_basa_en"
    SERVICIOS_REALIZADOS }o--|| EMPLEADOS : "realizado_por"
    
    CLIENTES {
        int ID_Cliente PK
        string Nombre
        string Apellido
        string Direccion_Calle
        string Numero_Direccion
        int ID_Ciudad FK
        string Email
        date Fecha_Registro
        string Estado
    }
    
    TELEFONOS_CLIENTE {
        int ID_Telefono PK
        int ID_Cliente FK
        string Numero_Telefono
        string Tipo_Telefono
        boolean Es_Principal
    }
    
    PROVINCIAS {
        int ID_Provincia PK
        string Nombre_Provincia
        string Codigo_Provincia
        string Pais
    }
    
    CIUDADES {
        int ID_Ciudad PK
        int ID_Provincia FK
        string Nombre_Ciudad
        string Codigo_Postal
    }
    
    MASCOTAS {
        int ID_Mascota PK
        int ID_Cliente FK
        string Nombre
        int ID_Especie FK
        int ID_Raza FK
        date Fecha_Nacimiento
        string Color
        decimal Peso_Actual
        char Genero
        string Numero_Microchip UK
        string Foto_URL
        date Fecha_Registro
        string Estado
    }
    
    ESPECIES {
        int ID_Especie PK
        string Nombre_Especie
        string Descripcion
    }
    
    RAZAS {
        int ID_Raza PK
        int ID_Especie FK
        string Nombre_Raza
        string Tamaño_Promedio
        string Caracteristicas
    }
    
    VETERINARIOS {
        int ID_Veterinario PK
        string Nombre
        string Apellido
        int ID_Especialidad FK
        string Telefono
        string Email UK
        string Numero_Licencia UK
        date Fecha_Contratacion
        date Fecha_Nacimiento
        string Estado
    }
    
    ESPECIALIDADES {
        int ID_Especialidad PK
        string Nombre_Especialidad
        string Descripcion
    }
    
    CITAS {
        int ID_Cita PK
        int ID_Mascota FK
        int ID_Veterinario FK
        date Fecha_Cita
        time Hora_Cita
        string Motivo_Consulta
        string Estado_Cita
        string Observaciones
        timestamp Fecha_Creacion
    }
    
    HISTORIAL_MEDICO {
        int ID_Historial PK
        int ID_Cita FK
        int ID_Mascota FK
        int ID_Veterinario FK
        datetime Fecha_Consulta
        text Diagnostico
        decimal Peso_Registrado
        decimal Temperatura
        int Frecuencia_Cardiaca
        text Observaciones_Generales
    }
    
    TRATAMIENTOS {
        int ID_Tratamiento PK
        int ID_Historial FK
        text Descripcion_Tratamiento
        date Fecha_Inicio
        date Fecha_Fin
        text Instrucciones
        string Estado
    }
    
    MEDICAMENTOS {
        int ID_Medicamento PK
        string Nombre_Medicamento
        text Descripcion
        string Laboratorio
        string Presentacion
        string Tipo
        boolean Requiere_Receta
    }
    
    MEDICAMENTOS_RECETADOS {
        int ID_Receta PK
        int ID_Tratamiento FK
        int ID_Medicamento FK
        string Dosis
        string Frecuencia
        int Duracion_Dias
        string Via_Administracion
        text Observaciones
    }
    
    VACUNAS {
        int ID_Vacuna PK
        string Nombre_Vacuna
        text Descripcion
        string Enfermedad_Previene
        string Laboratorio
        int Periodo_Revacunacion_Dias
        boolean Es_Obligatoria
        int ID_Especie FK
    }
    
    VACUNAS_APLICADAS {
        int ID_Aplicacion PK
        int ID_Mascota FK
        int ID_Vacuna FK
        int ID_Veterinario FK
        date Fecha_Aplicacion
        date Fecha_Proxima_Dosis
        string Lote
        text Observaciones
        boolean Reaccion_Adversa
    }
    
    SERVICIOS {
        int ID_Servicio PK
        string Nombre_Servicio
        text Descripcion
        decimal Precio_Base
        int Duracion_Estimada_Min
        string Tipo_Servicio
    }
    
    EMPLEADOS {
        int ID_Empleado PK
        string Nombre
        string Apellido
        string Puesto
        string Telefono
        string Email
        date Fecha_Contratacion
        string Estado
    }
    
    SERVICIOS_REALIZADOS {
        int ID_Servicio_Realizado PK
        int ID_Mascota FK
        int ID_Servicio FK
        int ID_Empleado FK
        date Fecha_Servicio
        time Hora_Inicio
        time Hora_Fin
        decimal Precio_Final
        string Estado_Pago
        text Observaciones
    }
```

## RELACIONES PRINCIPALES

### 1. CLIENTE - MASCOTA (1:N)
- Un cliente puede tener múltiples mascotas
- Una mascota pertenece a un solo cliente
- **Tipo**: Identificativa (la mascota no existe sin cliente)

### 2. MASCOTA - CITA (1:N)
- Una mascota puede tener múltiples citas
- Una cita es para una sola mascota
- **Tipo**: Regular

### 3. VETERINARIO - CITA (1:N)
- Un veterinario puede atender múltiples citas
- Una cita es atendida por un solo veterinario
- **Tipo**: Regular

### 4. CITA - HISTORIAL_MEDICO (1:1)
- Una cita puede generar un registro de historial médico
- Un historial médico corresponde a una cita específica
- **Tipo**: Opcional (no todas las citas generan historial)

### 5. HISTORIAL_MEDICO - TRATAMIENTO (1:N)
- Un historial médico puede incluir múltiples tratamientos
- Un tratamiento pertenece a un historial específico
- **Tipo**: Identificativa

### 6. TRATAMIENTO - MEDICAMENTO (N:M)
- Un tratamiento puede incluir múltiples medicamentos
- Un medicamento puede ser usado en múltiples tratamientos
- **Tabla intermedia**: MEDICAMENTOS_RECETADOS

### 7. MASCOTA - VACUNA (N:M)
- Una mascota puede recibir múltiples vacunas
- Una vacuna puede ser aplicada a múltiples mascotas
- **Tabla intermedia**: VACUNAS_APLICADAS

### 8. MASCOTA - SERVICIO (N:M)
- Una mascota puede recibir múltiples servicios
- Un servicio puede ser aplicado a múltiples mascotas
- **Tabla intermedia**: SERVICIOS_REALIZADOS

### 9. ESPECIE - RAZA (1:N)
- Una especie tiene múltiples razas
- Una raza pertenece a una sola especie
- **Tipo**: Identificativa

### 10. CIUDAD - PROVINCIA (N:1)
- Una provincia tiene múltiples ciudades
- Una ciudad pertenece a una sola provincia
- **Tipo**: Identificativa

## CARDINALIDADES DETALLADAS

```
CLIENTE (1,1) ----< (1,N) MASCOTA
CLIENTE (1,1) ----< (0,N) TELEFONO_CLIENTE
CLIENTE (1,1) >---- (1,1) CIUDAD

CIUDAD (N,1) >---- (1,1) PROVINCIA

MASCOTA (1,1) >---- (1,1) ESPECIE
MASCOTA (1,1) >---- (1,1) RAZA
MASCOTA (1,1) ----< (0,N) CITA
MASCOTA (1,1) ----< (0,N) HISTORIAL_MEDICO
MASCOTA (1,1) ----< (0,N) VACUNA_APLICADA
MASCOTA (1,1) ----< (0,N) SERVICIO_REALIZADO

ESPECIE (1,1) ----< (1,N) RAZA
ESPECIE (1,1) ----< (0,N) VACUNA

VETERINARIO (1,1) >---- (1,1) ESPECIALIDAD
VETERINARIO (1,1) ----< (0,N) CITA
VETERINARIO (1,1) ----< (0,N) HISTORIAL_MEDICO
VETERINARIO (1,1) ----< (0,N) VACUNA_APLICADA

CITA (1,1) ----< (0,1) HISTORIAL_MEDICO

HISTORIAL_MEDICO (1,1) ----< (0,N) TRATAMIENTO

TRATAMIENTO (1,1) ----< (0,N) MEDICAMENTO_RECETADO

MEDICAMENTO_RECETADO (N,1) >---- (1,1) MEDICAMENTO

VACUNA_APLICADA (N,1) >---- (1,1) VACUNA

SERVICIO_REALIZADO (N,1) >---- (1,1) SERVICIO
SERVICIO_REALIZADO (N,1) >---- (1,1) EMPLEADO
```

## RESTRICCIONES DE INTEGRIDAD

### Claves Primarias (PK)
- Todas las entidades tienen una clave primaria surrogate (ID autoincremental)
- Garantizan unicidad de cada registro

### Claves Foráneas (FK)
- Implementan las relaciones entre entidades
- Mantienen integridad referencial

### Claves Únicas (UK)
- `MASCOTAS.Numero_Microchip` - Un microchip es único por mascota
- `VETERINARIOS.Email` - Evita duplicación de veterinarios
- `VETERINARIOS.Numero_Licencia` - La licencia es única

### Restricciones de Dominio
- `MASCOTAS.Genero` ∈ {'M', 'F', 'I'}
- `CITAS.Estado_Cita` ∈ {'pendiente', 'en_proceso', 'completada', 'cancelada', 'no_asistio'}
- `SERVICIOS_REALIZADOS.Estado_Pago` ∈ {'pendiente', 'pagado', 'cancelado'}
- `Fecha_Nacimiento < CURRENT_DATE`

### Restricciones de Negocio
- La fecha de próxima dosis de vacuna debe ser posterior a la fecha de aplicación
- El peso registrado debe ser mayor a 0
- La temperatura debe estar en un rango razonable (30-45°C para la mayoría)
- La fecha de fin de tratamiento debe ser posterior o igual a la fecha de inicio

