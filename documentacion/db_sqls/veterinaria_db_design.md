# DISEÑO DE BASE DE DATOS - CLÍNICA VETERINARIA

## FASE 1: DISEÑO INICIAL (0FN - Sin Normalizar)

### Tabla: REGISTRO_CLINICA (Todo en una sola tabla - Situación inicial caótica)

```
REGISTRO_CLINICA
----------------
ID_Registro
Fecha_Registro
Cliente_Nombre
Cliente_Apellido
Cliente_Direccion_Calle
Cliente_Direccion_Ciudad
Cliente_Direccion_Provincia
Cliente_Direccion_CP
Cliente_Telefono1
Cliente_Telefono2
Cliente_Email
Cliente_Fecha_Registro
Mascota_Nombre
Mascota_Especie
Mascota_Raza
Mascota_Fecha_Nacimiento
Mascota_Color
Mascota_Peso
Mascota_Genero
Mascota_Microchip
Cita_Fecha
Cita_Hora
Cita_Motivo
Cita_Estado
Veterinario_Nombre
Veterinario_Apellido
Veterinario_Especialidad
Veterinario_Telefono
Veterinario_Email
Veterinario_Licencia
Diagnostico
Tratamiento_Descripcion
Medicamento_Nombre
Medicamento_Dosis
Medicamento_Frecuencia
Vacuna_Nombre
Vacuna_Fecha_Aplicacion
Vacuna_Proxima_Dosis
Servicio_Tipo (baño, peluquería, etc.)
Servicio_Precio
Servicio_Fecha
Total_Pagar
Estado_Pago
```

### PROBLEMAS EVIDENTES de esta estructura:

1. **Redundancia masiva**: Si un cliente tiene 3 mascotas, se repite toda su información 3 veces
2. **Anomalías de actualización**: Si cambia el teléfono del cliente, hay que actualizar múltiples registros
3. **Anomalías de inserción**: No puedo registrar un veterinario si no tiene una cita
4. **Anomalías de eliminación**: Si elimino la última cita de un cliente, pierdo toda su información
5. **Datos multivaluados**: Un cliente puede tener varios teléfonos, una mascota puede recibir varias vacunas
6. **Mezcla de contextos**: Datos de citas, tratamientos, vacunas y servicios mezclados

---

## FASE 2: PROCESO DE NORMALIZACIÓN

### 🔸 PRIMERA FORMA NORMAL (1FN)

**Regla**: Eliminar grupos repetitivos y asegurar que cada campo contenga valores atómicos.

**Tablas resultantes:**

#### CLIENTES_1FN
```
ID_Cliente (PK)
Nombre
Apellido
Direccion_Calle
Direccion_Ciudad
Direccion_Provincia
Direccion_CP
Email
Fecha_Registro
```

#### TELEFONOS_CLIENTE_1FN
```
ID_Telefono (PK)
ID_Cliente (FK)
Numero_Telefono
Tipo_Telefono (móvil, casa, trabajo)
```

#### MASCOTAS_1FN
```
ID_Mascota (PK)
ID_Cliente (FK)
Nombre
Especie
Raza
Fecha_Nacimiento
Color
Peso
Genero
Numero_Microchip
Fecha_Registro
Estado (activo, fallecido, adoptado)
```

#### VETERINARIOS_1FN
```
ID_Veterinario (PK)
Nombre
Apellido
Especialidad
Telefono
Email
Numero_Licencia
Fecha_Contratacion
Estado (activo, inactivo)
```

#### CITAS_1FN
```
ID_Cita (PK)
ID_Mascota (FK)
ID_Veterinario (FK)
Fecha_Cita
Hora_Cita
Motivo_Consulta
Estado_Cita (pendiente, completada, cancelada)
Observaciones
```

#### HISTORIAL_MEDICO_1FN
```
ID_Historial (PK)
ID_Cita (FK)
ID_Mascota (FK)
ID_Veterinario (FK)
Fecha_Consulta
Diagnostico
Tratamiento_Descripcion
Medicamento_Nombre
Medicamento_Dosis
Medicamento_Frecuencia
Observaciones
```

#### VACUNAS_APLICADAS_1FN
```
ID_Vacuna_Aplicada (PK)
ID_Mascota (FK)
Vacuna_Nombre
Fecha_Aplicacion
Fecha_Proxima_Dosis
Lote_Vacuna
ID_Veterinario (FK)
```

#### SERVICIOS_APLICADOS_1FN
```
ID_Servicio_Aplicado (PK)
ID_Mascota (FK)
Tipo_Servicio (baño, peluquería, estética, otro)
Descripcion_Servicio
Fecha_Servicio
Precio
Estado_Pago (pendiente, pagado)
```

**Mejoras logradas:**
- ✅ Eliminados grupos repetitivos (teléfonos ahora en tabla separada)
- ✅ Todos los atributos contienen valores atómicos
- ✅ Cada fila es única

---

### 🔸 SEGUNDA FORMA NORMAL (2FN)

**Regla**: Debe estar en 1FN + Eliminar dependencias parciales (todos los atributos no clave deben depender de TODA la clave primaria)

**Análisis de dependencias:**

En **HISTORIAL_MEDICO_1FN**, los medicamentos dependen del historial, no de la cita directamente.
En **VACUNAS_APLICADAS_1FN**, la información de la vacuna (tipo, descripción) está mezclada con su aplicación.

**Tablas ajustadas:**

#### HISTORIAL_MEDICO_2FN
```
ID_Historial (PK)
ID_Cita (FK)
ID_Mascota (FK)
ID_Veterinario (FK)
Fecha_Consulta
Diagnostico
Peso_Actual
Temperatura
Observaciones_Generales
```

#### TRATAMIENTOS_2FN
```
ID_Tratamiento (PK)
ID_Historial (FK)
Descripcion_Tratamiento
Fecha_Inicio
Fecha_Fin
Instrucciones
```

#### MEDICAMENTOS_2FN (Catálogo)
```
ID_Medicamento (PK)
Nombre_Medicamento
Descripcion
Laboratorio
Presentacion
Tipo (antibiótico, analgésico, etc.)
```

#### MEDICAMENTOS_RECETADOS_2FN
```
ID_Receta (PK)
ID_Tratamiento (FK)
ID_Medicamento (FK)
Dosis
Frecuencia
Duracion_Dias
Via_Administracion
```

#### VACUNAS_2FN (Catálogo)
```
ID_Vacuna (PK)
Nombre_Vacuna
Descripcion
Enfermedad_Previene
Laboratorio
Periodo_Revacunacion_Dias
```

#### VACUNAS_APLICADAS_2FN
```
ID_Aplicacion (PK)
ID_Mascota (FK)
ID_Vacuna (FK)
ID_Veterinario (FK)
Fecha_Aplicacion
Fecha_Proxima_Dosis
Lote
Observaciones
```

#### SERVICIOS_2FN (Catálogo)
```
ID_Servicio (PK)
Nombre_Servicio
Descripcion
Precio_Base
Duracion_Estimada_Min
```

#### SERVICIOS_REALIZADOS_2FN
```
ID_Servicio_Realizado (PK)
ID_Mascota (FK)
ID_Servicio (FK)
Fecha_Servicio
Precio_Final
Estado_Pago (pendiente, pagado)
ID_Empleado (FK) -- quien realizó el servicio
Observaciones
```

**Mejoras logradas:**
- ✅ Eliminadas dependencias parciales
- ✅ Creados catálogos independientes (Medicamentos, Vacunas, Servicios)
- ✅ Separación entre "definición" y "uso" de recursos

---

### 🔸 TERCERA FORMA NORMAL (3FN)

**Regla**: Debe estar en 2FN + Eliminar dependencias transitivas (atributos no clave no deben depender de otros atributos no clave)

**Análisis de dependencias transitivas:**

En **CLIENTES_2FN**: La provincia depende de la ciudad, no directamente del cliente.
En **VETERINARIOS_2FN**: La especialidad podría ser un catálogo.
En **MASCOTAS_2FN**: La raza depende de la especie.

**Tablas finales (3FN):**

#### PROVINCIAS_3FN
```
ID_Provincia (PK)
Nombre_Provincia
Codigo_Provincia
Pais
```

#### CIUDADES_3FN
```
ID_Ciudad (PK)
ID_Provincia (FK)
Nombre_Ciudad
Codigo_Postal
```

#### CLIENTES_3FN
```
ID_Cliente (PK)
Nombre
Apellido
Direccion_Calle
Numero_Direccion
ID_Ciudad (FK)
Email
Fecha_Registro
Estado (activo, inactivo)
```

#### TELEFONOS_CLIENTE_3FN
```
ID_Telefono (PK)
ID_Cliente (FK)
Numero_Telefono
Tipo_Telefono (móvil, casa, trabajo)
Es_Principal (boolean)
```

#### ESPECIES_3FN
```
ID_Especie (PK)
Nombre_Especie (perro, gato, ave, reptil, etc.)
Descripcion
```

#### RAZAS_3FN
```
ID_Raza (PK)
ID_Especie (FK)
Nombre_Raza
Tamaño_Promedio (pequeño, mediano, grande)
Caracteristicas
```

#### MASCOTAS_3FN
```
ID_Mascota (PK)
ID_Cliente (FK)
Nombre
ID_Especie (FK)
ID_Raza (FK)
Fecha_Nacimiento
Color
Peso_Actual
Genero (M, F, I - indeterminado)
Numero_Microchip (UNIQUE)
Foto_URL
Fecha_Registro
Estado (activo, fallecido, adoptado)
```

#### ESPECIALIDADES_3FN
```
ID_Especialidad (PK)
Nombre_Especialidad (cirugía, dermatología, cardiología, general, etc.)
Descripcion
```

#### VETERINARIOS_3FN
```
ID_Veterinario (PK)
Nombre
Apellido
ID_Especialidad (FK)
Telefono
Email (UNIQUE)
Numero_Licencia (UNIQUE)
Fecha_Contratacion
Fecha_Nacimiento
Estado (activo, inactivo, vacaciones)
```

#### CITAS_3FN
```
ID_Cita (PK)
ID_Mascota (FK)
ID_Veterinario (FK)
Fecha_Cita
Hora_Cita
Motivo_Consulta
Estado_Cita (pendiente, en_proceso, completada, cancelada, no_asistio)
Observaciones
Fecha_Creacion
```

#### HISTORIAL_MEDICO_3FN
```
ID_Historial (PK)
ID_Cita (FK)
ID_Mascota (FK)
ID_Veterinario (FK)
Fecha_Consulta
Diagnostico
Peso_Registrado
Temperatura
Frecuencia_Cardiaca
Observaciones_Generales
```

#### TRATAMIENTOS_3FN
```
ID_Tratamiento (PK)
ID_Historial (FK)
Descripcion_Tratamiento
Fecha_Inicio
Fecha_Fin
Instrucciones
Estado (activo, completado, suspendido)
```

#### MEDICAMENTOS_3FN
```
ID_Medicamento (PK)
Nombre_Medicamento
Descripcion
Laboratorio
Presentacion
Tipo (antibiótico, analgésico, antiinflamatorio, etc.)
Requiere_Receta (boolean)
```

#### MEDICAMENTOS_RECETADOS_3FN
```
ID_Receta (PK)
ID_Tratamiento (FK)
ID_Medicamento (FK)
Dosis
Frecuencia
Duracion_Dias
Via_Administracion (oral, inyectable, tópica)
Observaciones
```

#### VACUNAS_3FN
```
ID_Vacuna (PK)
Nombre_Vacuna
Descripcion
Enfermedad_Previene
Laboratorio
Periodo_Revacunacion_Dias
Es_Obligatoria (boolean)
ID_Especie (FK) -- algunas vacunas son específicas por especie
```

#### VACUNAS_APLICADAS_3FN
```
ID_Aplicacion (PK)
ID_Mascota (FK)
ID_Vacuna (FK)
ID_Veterinario (FK)
Fecha_Aplicacion
Fecha_Proxima_Dosis
Lote
Observaciones
Reaccion_Adversa (boolean)
```

#### SERVICIOS_3FN
```
ID_Servicio (PK)
Nombre_Servicio
Descripcion
Precio_Base
Duracion_Estimada_Min
Tipo_Servicio (estética, salud, hospedaje)
```

#### EMPLEADOS_3FN
```
ID_Empleado (PK)
Nombre
Apellido
Puesto (groomer, recepcionista, asistente, etc.)
Telefono
Email
Fecha_Contratacion
Estado (activo, inactivo)
```

#### SERVICIOS_REALIZADOS_3FN
```
ID_Servicio_Realizado (PK)
ID_Mascota (FK)
ID_Servicio (FK)
ID_Empleado (FK)
Fecha_Servicio
Hora_Inicio
Hora_Fin
Precio_Final
Estado_Pago (pendiente, pagado, cancelado)
Observaciones
```

**Mejoras logradas:**
- ✅ Eliminadas todas las dependencias transitivas
- ✅ Máxima flexibilidad y reutilización
- ✅ Integridad referencial completa
- ✅ Base de datos en 3FN: lista para producción

---

## RESUMEN DE NORMALIZACIÓN

| Forma Normal | Tablas Principales | Mejoras Clave |
|--------------|-------------------|---------------|
| **0FN** | 1 tabla caótica | Todo mezclado, máxima redundancia |
| **1FN** | 8 tablas | Valores atómicos, sin grupos repetitivos |
| **2FN** | 13 tablas | Catálogos separados, sin dependencias parciales |
| **3FN** | 19 tablas | Sin dependencias transitivas, máxima normalización |

