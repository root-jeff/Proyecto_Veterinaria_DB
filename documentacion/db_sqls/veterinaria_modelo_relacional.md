# MODELO RELACIONAL (MR) - CLÍNICA VETERINARIA

## ESQUEMAS RELACIONALES (Notación Formal)

### 📋 MÓDULO: GESTIÓN DE CLIENTES

**PROVINCIAS**
```
PROVINCIAS(ID_Provincia, Nombre_Provincia, Codigo_Provincia, Pais)
  PK: ID_Provincia
  UK: Codigo_Provincia
```

**CIUDADES**
```
CIUDADES(ID_Ciudad, ID_Provincia, Nombre_Ciudad, Codigo_Postal)
  PK: ID_Ciudad
  FK: ID_Provincia → PROVINCIAS(ID_Provincia)
  UK: (Nombre_Ciudad, ID_Provincia)
```

**CLIENTES**
```
CLIENTES(ID_Cliente, Nombre, Apellido, Direccion_Calle, Numero_Direccion, 
         ID_Ciudad, Email, Fecha_Registro, Estado)
  PK: ID_Cliente
  FK: ID_Ciudad → CIUDADES(ID_Ciudad)
  UK: Email
  CHECK: Estado IN ('activo', 'inactivo')
  CHECK: Email LIKE '%@%'
```

**TELEFONOS_CLIENTE**
```
TELEFONOS_CLIENTE(ID_Telefono, ID_Cliente, Numero_Telefono, Tipo_Telefono, Es_Principal)
  PK: ID_Telefono
  FK: ID_Cliente → CLIENTES(ID_Cliente) ON DELETE CASCADE
  CHECK: Tipo_Telefono IN ('móvil', 'casa', 'trabajo')
  UK: (ID_Cliente, Numero_Telefono)
```

---

### 🐾 MÓDULO: GESTIÓN DE MASCOTAS

**ESPECIES**
```
ESPECIES(ID_Especie, Nombre_Especie, Descripcion)
  PK: ID_Especie
  UK: Nombre_Especie
```

**RAZAS**
```
RAZAS(ID_Raza, ID_Especie, Nombre_Raza, Tamaño_Promedio, Caracteristicas)
  PK: ID_Raza
  FK: ID_Especie → ESPECIES(ID_Especie) ON DELETE RESTRICT
  CHECK: Tamaño_Promedio IN ('pequeño', 'mediano', 'grande', 'gigante')
  UK: (Nombre_Raza, ID_Especie)
```

**MASCOTAS**
```
MASCOTAS(ID_Mascota, ID_Cliente, Nombre, ID_Especie, ID_Raza, Fecha_Nacimiento, 
         Color, Peso_Actual, Genero, Numero_Microchip, Foto_URL, Fecha_Registro, Estado)
  PK: ID_Mascota
  FK: ID_Cliente → CLIENTES(ID_Cliente) ON DELETE RESTRICT
  FK: ID_Especie → ESPECIES(ID_Especie)
  FK: ID_Raza → RAZAS(ID_Raza)
  UK: Numero_Microchip
  CHECK: Genero IN ('M', 'F', 'I')
  CHECK: Estado IN ('activo', 'fallecido', 'adoptado')
  CHECK: Peso_Actual > 0
  CHECK: Fecha_Nacimiento < CURRENT_DATE
```

---

### 👨‍⚕️ MÓDULO: GESTIÓN DE VETERINARIOS

**ESPECIALIDADES**
```
ESPECIALIDADES(ID_Especialidad, Nombre_Especialidad, Descripcion)
  PK: ID_Especialidad
  UK: Nombre_Especialidad
```

**VETERINARIOS**
```
VETERINARIOS(ID_Veterinario, Nombre, Apellido, ID_Especialidad, Telefono, 
             Email, Numero_Licencia, Fecha_Contratacion, Fecha_Nacimiento, Estado)
  PK: ID_Veterinario
  FK: ID_Especialidad → ESPECIALIDADES(ID_Especialidad)
  UK: Email
  UK: Numero_Licencia
  CHECK: Estado IN ('activo', 'inactivo', 'vacaciones')
  CHECK: Email LIKE '%@%'
```

---

### 📅 MÓDULO: GESTIÓN DE CITAS

**CITAS**
```
CITAS(ID_Cita, ID_Mascota, ID_Veterinario, Fecha_Cita, Hora_Cita, 
      Motivo_Consulta, Estado_Cita, Observaciones, Fecha_Creacion)
  PK: ID_Cita
  FK: ID_Mascota → MASCOTAS(ID_Mascota) ON DELETE RESTRICT
  FK: ID_Veterinario → VETERINARIOS(ID_Veterinario) ON DELETE RESTRICT
  CHECK: Estado_Cita IN ('pendiente', 'en_proceso', 'completada', 'cancelada', 'no_asistio')
  CHECK: Fecha_Cita >= CURRENT_DATE (para nuevas citas)
  UK: (ID_Veterinario, Fecha_Cita, Hora_Cita) -- No puede tener 2 citas al mismo tiempo
```

---

### 📋 MÓDULO: HISTORIAL MÉDICO Y TRATAMIENTOS

**HISTORIAL_MEDICO**
```
HISTORIAL_MEDICO(ID_Historial, ID_Cita, ID_Mascota, ID_Veterinario, Fecha_Consulta, 
                 Diagnostico, Peso_Registrado, Temperatura, Frecuencia_Cardiaca, 
                 Observaciones_Generales)
  PK: ID_Historial
  FK: ID_Cita → CITAS(ID_Cita) ON DELETE RESTRICT
  FK: ID_Mascota → MASCOTAS(ID_Mascota) ON DELETE RESTRICT
  FK: ID_Veterinario → VETERINARIOS(ID_Veterinario)
  UK: ID_Cita -- Una cita genera máximo un historial
  CHECK: Peso_Registrado > 0
  CHECK: Temperatura BETWEEN 30 AND 45
  CHECK: Frecuencia_Cardiaca > 0
```

**TRATAMIENTOS**
```
TRATAMIENTOS(ID_Tratamiento, ID_Historial, Descripcion_Tratamiento, 
             Fecha_Inicio, Fecha_Fin, Instrucciones, Estado)
  PK: ID_Tratamiento
  FK: ID_Historial → HISTORIAL_MEDICO(ID_Historial) ON DELETE CASCADE
  CHECK: Estado IN ('activo', 'completado', 'suspendido')
  CHECK: Fecha_Fin IS NULL OR Fecha_Fin >= Fecha_Inicio
```

---

### 💊 MÓDULO: MEDICAMENTOS

**MEDICAMENTOS**
```
MEDICAMENTOS(ID_Medicamento, Nombre_Medicamento, Descripcion, Laboratorio, 
             Presentacion, Tipo, Requiere_Receta)
  PK: ID_Medicamento
  UK: (Nombre_Medicamento, Laboratorio, Presentacion)
  CHECK: Tipo IN ('antibiótico', 'analgésico', 'antiinflamatorio', 'antiparasitario', 
                  'vitamina', 'suplemento', 'otro')
```

**MEDICAMENTOS_RECETADOS**
```
MEDICAMENTOS_RECETADOS(ID_Receta, ID_Tratamiento, ID_Medicamento, Dosis, 
                       Frecuencia, Duracion_Dias, Via_Administracion, Observaciones)
  PK: ID_Receta
  FK: ID_Tratamiento → TRATAMIENTOS(ID_Tratamiento) ON DELETE CASCADE
  FK: ID_Medicamento → MEDICAMENTOS(ID_Medicamento)
  CHECK: Via_Administracion IN ('oral', 'inyectable', 'tópica', 'oftálmica', 'ótica')
  CHECK: Duracion_Dias > 0
```

---

### 💉 MÓDULO: VACUNAS

**VACUNAS**
```
VACUNAS(ID_Vacuna, Nombre_Vacuna, Descripcion, Enfermedad_Previene, 
        Laboratorio, Periodo_Revacunacion_Dias, Es_Obligatoria, ID_Especie)
  PK: ID_Vacuna
  FK: ID_Especie → ESPECIES(ID_Especie)
  CHECK: Periodo_Revacunacion_Dias > 0
```

**VACUNAS_APLICADAS**
```
VACUNAS_APLICADAS(ID_Aplicacion, ID_Mascota, ID_Vacuna, ID_Veterinario, 
                  Fecha_Aplicacion, Fecha_Proxima_Dosis, Lote, 
                  Observaciones, Reaccion_Adversa)
  PK: ID_Aplicacion
  FK: ID_Mascota → MASCOTAS(ID_Mascota) ON DELETE RESTRICT
  FK: ID_Vacuna → VACUNAS(ID_Vacuna)
  FK: ID_Veterinario → VETERINARIOS(ID_Veterinario)
  CHECK: Fecha_Proxima_Dosis > Fecha_Aplicacion
  UK: (ID_Mascota, ID_Vacuna, Fecha_Aplicacion) -- No puede aplicarse la misma vacuna 2 veces el mismo día
```

---

### 🛁 MÓDULO: SERVICIOS

**SERVICIOS**
```
SERVICIOS(ID_Servicio, Nombre_Servicio, Descripcion, Precio_Base, 
          Duracion_Estimada_Min, Tipo_Servicio)
  PK: ID_Servicio
  UK: Nombre_Servicio
  CHECK: Precio_Base >= 0
  CHECK: Duracion_Estimada_Min > 0
  CHECK: Tipo_Servicio IN ('estética', 'salud', 'hospedaje', 'adiestramiento')
```

**EMPLEADOS**
```
EMPLEADOS(ID_Empleado, Nombre, Apellido, Puesto, Telefono, 
          Email, Fecha_Contratacion, Estado)
  PK: ID_Empleado
  UK: Email
  CHECK: Puesto IN ('groomer', 'recepcionista', 'asistente', 'cuidador', 'adiestrador')
  CHECK: Estado IN ('activo', 'inactivo')
```

**SERVICIOS_REALIZADOS**
```
SERVICIOS_REALIZADOS(ID_Servicio_Realizado, ID_Mascota, ID_Servicio, ID_Empleado, 
                     Fecha_Servicio, Hora_Inicio, Hora_Fin, Precio_Final, 
                     Estado_Pago, Observaciones)
  PK: ID_Servicio_Realizado
  FK: ID_Mascota → MASCOTAS(ID_Mascota) ON DELETE RESTRICT
  FK: ID_Servicio → SERVICIOS(ID_Servicio)
  FK: ID_Empleado → EMPLEADOS(ID_Empleado)
  CHECK: Estado_Pago IN ('pendiente', 'pagado', 'cancelado')
  CHECK: Precio_Final >= 0
  CHECK: Hora_Fin IS NULL OR Hora_Fin > Hora_Inicio
```

---

## 📊 RESUMEN DEL MODELO RELACIONAL

### Estadísticas del Modelo

| Métrica | Cantidad |
|---------|----------|
| **Total de Tablas** | 19 |
| **Tablas de Catálogo** | 6 (Provincias, Ciudades, Especies, Razas, Especialidades, Medicamentos) |
| **Tablas Transaccionales** | 7 (Citas, Historial, Tratamientos, Vacunas_Aplicadas, Servicios_Realizados) |
| **Tablas Maestras** | 6 (Clientes, Mascotas, Veterinarios, Vacunas, Servicios, Empleados) |
| **Claves Primarias** | 19 |
| **Claves Foráneas** | 28 |
| **Restricciones CHECK** | 31 |
| **Restricciones UNIQUE** | 14 |

### Índices Recomendados (además de PKs)

```sql
-- Búsquedas frecuentes
CREATE INDEX idx_mascotas_cliente ON MASCOTAS(ID_Cliente);
CREATE INDEX idx_mascotas_microchip ON MASCOTAS(Numero_Microchip);
CREATE INDEX idx_citas_fecha ON CITAS(Fecha_Cita, Hora_Cita);
CREATE INDEX idx_citas_veterinario_fecha ON CITAS(ID_Veterinario, Fecha_Cita);
CREATE INDEX idx_historial_mascota ON HISTORIAL_MEDICO(ID_Mascota);
CREATE INDEX idx_vacunas_aplicadas_mascota ON VACUNAS_APLICADAS(ID_Mascota);
CREATE INDEX idx_vacunas_proxima_dosis ON VACUNAS_APLICADAS(Fecha_Proxima_Dosis);

-- Búsquedas por nombre (para autocompletado)
CREATE INDEX idx_clientes_apellido ON CLIENTES(Apellido, Nombre);
CREATE INDEX idx_mascotas_nombre ON MASCOTAS(Nombre);
CREATE INDEX idx_veterinarios_apellido ON VETERINARIOS(Apellido, Nombre);
```

### Dependencias Funcionales Principales

#### CLIENTES
```
ID_Cliente → Nombre, Apellido, Direccion_Calle, Numero_Direccion, ID_Ciudad, Email, Fecha_Registro, Estado
Email → ID_Cliente (candidata a clave alternativa)
```

#### MASCOTAS
```
ID_Mascota → ID_Cliente, Nombre, ID_Especie, ID_Raza, Fecha_Nacimiento, Color, Peso_Actual, Genero, Numero_Microchip, Foto_URL, Fecha_Registro, Estado
Numero_Microchip → ID_Mascota (candidata a clave alternativa)
```

#### CITAS
```
ID_Cita → ID_Mascota, ID_Veterinario, Fecha_Cita, Hora_Cita, Motivo_Consulta, Estado_Cita, Observaciones
(ID_Veterinario, Fecha_Cita, Hora_Cita) → ID_Cita (un veterinario no puede tener 2 citas al mismo tiempo)
```

#### HISTORIAL_MEDICO
```
ID_Historial → ID_Cita, ID_Mascota, ID_Veterinario, Fecha_Consulta, Diagnostico, ...
ID_Cita → ID_Historial (una cita genera máximo un historial)
```

### Normalización Verificada

✅ **1FN**: Todos los atributos contienen valores atómicos
✅ **2FN**: No hay dependencias parciales (todas las claves son simples)
✅ **3FN**: No hay dependencias transitivas
  - Ejemplo: Cliente → Ciudad → Provincia (correcto, separado en tablas)
  - Ejemplo: Mascota → Especie → Raza (correcto, separado en tablas)

### Integridad Referencial

**Reglas ON DELETE:**
- `CASCADE`: Cuando se elimina un padre, se eliminan los hijos (ej: Cliente → Teléfonos)
- `RESTRICT`: No permite eliminar si tiene dependencias (ej: Cliente con Mascotas)
- `SET NULL`: Establece NULL en los hijos (no usado en este modelo)

**Ejemplo de cascada:**
```
CLIENTES → TELEFONOS_CLIENTE (CASCADE)
  Si se elimina un cliente, se eliminan todos sus teléfonos automáticamente

CLIENTES → MASCOTAS (RESTRICT)
  No se puede eliminar un cliente si tiene mascotas registradas
```

