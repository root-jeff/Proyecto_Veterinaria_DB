# DISEÑO E IMPLEMENTACIÓN DE UN SISTEMA DE GESTIÓN DE BASE DE DATOS PARA CLÍNICA VETERINARIA

**PARTE 2: MODELO RELACIONAL Y NORMALIZACIÓN**

---

<div style="page-break-after: always;"></div>

## V. MODELO RELACIONAL (MR)

### 5.1. TRANSFORMACIÓN DEL MODELO ENTIDAD-RELACIÓN AL MODELO RELACIONAL

#### 5.1.1. Metodología de Transformación

La transformación del Modelo Entidad-Relación al Modelo Relacional se realizó siguiendo un conjunto de reglas sistemáticas propuestas por Elmasri y Navathe (2015):

**Regla 1: Mapeo de Entidades Fuertes**
- Cada entidad fuerte se transforma en una tabla
- Los atributos simples se convierten en columnas
- El atributo clave se convierte en clave primaria (PK)

**Regla 2: Mapeo de Entidades Débiles**
- Se crea una tabla incluyendo la clave primaria de la entidad fuerte propietaria
- La clave primaria será la combinación de su discriminador parcial y la PK de la entidad propietaria

**Regla 3: Mapeo de Relaciones 1:1**
- Se puede implementar incluyendo la clave primaria de una entidad como clave foránea en la otra
- Se elige la entidad con participación total

**Regla 4: Mapeo de Relaciones 1:N**
- La clave primaria del lado "uno" se incluye como clave foránea en la tabla del lado "muchos"

**Regla 5: Mapeo de Relaciones N:M**
- Se crea una tabla intermedia (tabla de unión)
- Contiene las claves primarias de ambas entidades como claves foráneas
- La clave primaria compuesta está formada por ambas claves foráneas

**Regla 6: Mapeo de Atributos Multivalorados**
- Se crea una tabla separada con la clave primaria de la entidad propietaria como clave foránea

**Regla 7: Mapeo de Relaciones n-arias**
- Se crea una tabla con las claves primarias de todas las entidades participantes

### 5.2. ESQUEMAS RELACIONALES FORMALES

#### 5.2.1. Notación Utilizada

Para la especificación formal de los esquemas relacionales se utiliza la siguiente notación:

```
NOMBRE_TABLA(atributo1, atributo2, ..., atributoN)
  PK: clave_primaria
  FK: clave_foranea → TABLA_REFERENCIADA(clave_referenciada)
  UK: clave_unica
  CHECK: restriccion_de_dominio
```

Donde:
- **PK** (Primary Key): Clave primaria
- **FK** (Foreign Key): Clave foránea
- **UK** (Unique Key): Restricción de unicidad
- **CHECK**: Restricción de dominio

#### 5.2.2. Módulo 1: Gestión de Ubicaciones Geográficas

Este módulo gestiona la información geográfica necesaria para localizar clientes y organizar la cobertura territorial de la clínica.

**PROVINCIAS**
```
PROVINCIAS(ID_Provincia, Nombre_Provincia, Codigo_Provincia, Pais)
  PK: ID_Provincia
  UK: Codigo_Provincia
  CHECK: LENGTH(TRIM(Nombre_Provincia)) > 0
  CHECK: Pais NOT NULL
```

**Dependencias Funcionales:**
```
ID_Provincia → Nombre_Provincia, Codigo_Provincia, Pais
Codigo_Provincia → ID_Provincia, Nombre_Provincia, Pais
```

**CIUDADES**
```
CIUDADES(ID_Ciudad, ID_Provincia, Nombre_Ciudad, Codigo_Postal)
  PK: ID_Ciudad
  FK: ID_Provincia → PROVINCIAS(ID_Provincia)
  UK: (Nombre_Ciudad, ID_Provincia)
  CHECK: ID_Provincia IS NOT NULL
```

**Dependencias Funcionales:**
```
ID_Ciudad → ID_Provincia, Nombre_Ciudad, Codigo_Postal
(Nombre_Ciudad, ID_Provincia) → ID_Ciudad
```

**Justificación del Diseño:**

La separación de PROVINCIAS y CIUDADES elimina la dependencia transitiva que existiría si la provincia se almacenara directamente en la tabla CLIENTES. Esta estructura permite:
- Mantener consistencia en nombres de provincias
- Facilitar consultas geográficas
- Soportar múltiples ciudades con el mismo nombre en diferentes provincias
- Permitir análisis estadísticos por región

#### 5.2.3. Módulo 2: Gestión de Clientes

**CLIENTES**
```
CLIENTES(ID_Cliente, Nombre, Apellido, Direccion_Calle, Numero_Direccion,
         ID_Ciudad, Email, Fecha_Registro, Estado)
  PK: ID_Cliente
  FK: ID_Ciudad → CIUDADES(ID_Ciudad)
  UK: Email
  CHECK: Estado IN ('activo', 'inactivo')
  CHECK: Email LIKE '%@%'
  CHECK: LENGTH(TRIM(Nombre)) > 0
  CHECK: LENGTH(TRIM(Apellido)) > 0
```

**Dependencias Funcionales:**
```
ID_Cliente → Nombre, Apellido, Direccion_Calle, Numero_Direccion,
             ID_Ciudad, Email, Fecha_Registro, Estado
Email → ID_Cliente (clave candidata)
```

**TELEFONOS_CLIENTE**
```
TELEFONOS_CLIENTE(ID_Telefono, ID_Cliente, Numero_Telefono, 
                  Tipo_Telefono, Es_Principal)
  PK: ID_Telefono
  FK: ID_Cliente → CLIENTES(ID_Cliente) ON DELETE CASCADE
  UK: (ID_Cliente, Numero_Telefono)
  CHECK: Tipo_Telefono IN ('móvil', 'casa', 'trabajo')
  CHECK: Es_Principal IN (TRUE, FALSE)
```

**Dependencias Funcionales:**
```
ID_Telefono → ID_Cliente, Numero_Telefono, Tipo_Telefono, Es_Principal
(ID_Cliente, Numero_Telefono) → ID_Telefono
```

**Justificación del Diseño:**

La tabla TELEFONOS_CLIENTE se creó como entidad separada para:
- Cumplir con 1FN (eliminar grupos repetitivos de teléfonos)
- Permitir múltiples números telefónicos por cliente
- Facilitar la gestión de teléfonos sin alterar el registro del cliente
- Identificar el teléfono principal mediante el atributo Es_Principal

La acción `ON DELETE CASCADE` se justifica porque los teléfonos no tienen sentido sin el cliente asociado.

#### 5.2.4. Módulo 3: Gestión de Mascotas

**ESPECIES**
```
ESPECIES(ID_Especie, Nombre_Especie, Descripcion)
  PK: ID_Especie
  UK: Nombre_Especie
  CHECK: LENGTH(TRIM(Nombre_Especie)) > 0
```

**RAZAS**
```
RAZAS(ID_Raza, ID_Especie, Nombre_Raza, Tamaño_Promedio, Caracteristicas)
  PK: ID_Raza
  FK: ID_Especie → ESPECIES(ID_Especie)
  UK: (Nombre_Raza, ID_Especie)
  CHECK: Tamaño_Promedio IN ('pequeño', 'mediano', 'grande', 'gigante')
```

**Dependencias Funcionales:**
```
ID_Raza → ID_Especie, Nombre_Raza, Tamaño_Promedio, Caracteristicas
(Nombre_Raza, ID_Especie) → ID_Raza
```

**MASCOTAS**
```
MASCOTAS(ID_Mascota, ID_Cliente, Nombre, ID_Especie, ID_Raza, 
         Fecha_Nacimiento, Color, Peso_Actual, Genero, Numero_Microchip,
         Foto_URL, Fecha_Registro, Estado)
  PK: ID_Mascota
  FK: ID_Cliente → CLIENTES(ID_Cliente)
  FK: ID_Especie → ESPECIES(ID_Especie)
  FK: ID_Raza → RAZAS(ID_Raza)
  UK: Numero_Microchip
  CHECK: Genero IN ('M', 'F', 'I')
  CHECK: Estado IN ('activo', 'fallecido', 'adoptado')
  CHECK: Peso_Actual IS NULL OR Peso_Actual > 0
  CHECK: Fecha_Nacimiento < CURRENT_DATE
```

**Dependencias Funcionales:**
```
ID_Mascota → ID_Cliente, Nombre, ID_Especie, ID_Raza, Fecha_Nacimiento,
             Color, Peso_Actual, Genero, Numero_Microchip, Foto_URL,
             Fecha_Registro, Estado
Numero_Microchip → ID_Mascota (cuando no es NULL)
```

**Justificación del Diseño:**

La jerarquía ESPECIES → RAZAS → MASCOTAS elimina dependencias transitivas:
- Si almacenáramos la especie directamente en MASCOTAS, tendríamos redundancia
- La raza depende de la especie, no directamente de la mascota
- Esta estructura facilita agregar nuevas razas sin modificar registros de mascotas
- Permite consultas eficientes como "todas las razas de perros"

#### 5.2.5. Módulo 4: Gestión de Veterinarios

**ESPECIALIDADES**
```
ESPECIALIDADES(ID_Especialidad, Nombre_Especialidad, Descripcion)
  PK: ID_Especialidad
  UK: Nombre_Especialidad
  CHECK: LENGTH(TRIM(Nombre_Especialidad)) > 0
```

**VETERINARIOS**
```
VETERINARIOS(ID_Veterinario, Nombre, Apellido, ID_Especialidad, Telefono,
             Email, Numero_Licencia, Fecha_Contratacion, Fecha_Nacimiento,
             Estado)
  PK: ID_Veterinario
  FK: ID_Especialidad → ESPECIALIDADES(ID_Especialidad)
  UK: Email
  UK: Numero_Licencia
  CHECK: Estado IN ('activo', 'inactivo', 'vacaciones')
  CHECK: Email LIKE '%@%'
  CHECK: Fecha_Nacimiento < CURRENT_DATE
  CHECK: Fecha_Contratacion >= Fecha_Nacimiento
```

**Dependencias Funcionales:**
```
ID_Veterinario → Nombre, Apellido, ID_Especialidad, Telefono, Email,
                 Numero_Licencia, Fecha_Contratacion, Fecha_Nacimiento, Estado
Email → ID_Veterinario
Numero_Licencia → ID_Veterinario
```

#### 5.2.6. Módulo 5: Gestión de Citas

**CITAS**
```
CITAS(ID_Cita, ID_Mascota, ID_Veterinario, Fecha_Cita, Hora_Cita,
      Motivo_Consulta, Estado_Cita, Observaciones, Fecha_Creacion)
  PK: ID_Cita
  FK: ID_Mascota → MASCOTAS(ID_Mascota)
  FK: ID_Veterinario → VETERINARIOS(ID_Veterinario)
  UK: (ID_Veterinario, Fecha_Cita, Hora_Cita)
  CHECK: Estado_Cita IN ('pendiente', 'en_proceso', 'completada', 
                         'cancelada', 'no_asistio')
  CHECK: LENGTH(TRIM(Motivo_Consulta)) > 0
```

**Dependencias Funcionales:**
```
ID_Cita → ID_Mascota, ID_Veterinario, Fecha_Cita, Hora_Cita,
          Motivo_Consulta, Estado_Cita, Observaciones, Fecha_Creacion
(ID_Veterinario, Fecha_Cita, Hora_Cita) → ID_Cita
```

**Justificación del Diseño:**

La restricción única `(ID_Veterinario, Fecha_Cita, Hora_Cita)` implementa la regla de negocio: "un veterinario no puede tener dos citas al mismo tiempo". Esta es una clave candidata que garantiza la integridad del calendario de citas.

#### 5.2.7. Módulo 6: Historial Médico y Tratamientos

**HISTORIAL_MEDICO**
```
HISTORIAL_MEDICO(ID_Historial, ID_Cita, ID_Mascota, ID_Veterinario,
                 Fecha_Consulta, Diagnostico, Peso_Registrado, Temperatura,
                 Frecuencia_Cardiaca, Observaciones_Generales)
  PK: ID_Historial
  FK: ID_Cita → CITAS(ID_Cita)
  FK: ID_Mascota → MASCOTAS(ID_Mascota)
  FK: ID_Veterinario → VETERINARIOS(ID_Veterinario)
  UK: ID_Cita
  CHECK: Peso_Registrado IS NULL OR Peso_Registrado > 0
  CHECK: Temperatura IS NULL OR Temperatura BETWEEN 30 AND 45
  CHECK: Frecuencia_Cardiaca IS NULL OR Frecuencia_Cardiaca > 0
```

**Dependencias Funcionales:**
```
ID_Historial → ID_Cita, ID_Mascota, ID_Veterinario, Fecha_Consulta,
               Diagnostico, Peso_Registrado, Temperatura,
               Frecuencia_Cardiaca, Observaciones_Generales
ID_Cita → ID_Historial (relación 1:1)
```

**TRATAMIENTOS**
```
TRATAMIENTOS(ID_Tratamiento, ID_Historial, Descripcion_Tratamiento,
             Fecha_Inicio, Fecha_Fin, Instrucciones, Estado)
  PK: ID_Tratamiento
  FK: ID_Historial → HISTORIAL_MEDICO(ID_Historial) ON DELETE CASCADE
  CHECK: Estado IN ('activo', 'completado', 'suspendido')
  CHECK: Fecha_Fin IS NULL OR Fecha_Fin >= Fecha_Inicio
  CHECK: LENGTH(TRIM(Descripcion_Tratamiento)) > 0
```

**Dependencias Funcionales:**
```
ID_Tratamiento → ID_Historial, Descripcion_Tratamiento, Fecha_Inicio,
                 Fecha_Fin, Instrucciones, Estado
```

#### 5.2.8. Módulo 7: Medicamentos

**MEDICAMENTOS**
```
MEDICAMENTOS(ID_Medicamento, Nombre_Medicamento, Descripcion, Laboratorio,
             Presentacion, Tipo, Requiere_Receta)
  PK: ID_Medicamento
  UK: (Nombre_Medicamento, Laboratorio, Presentacion)
  CHECK: Tipo IN ('antibiótico', 'analgésico', 'antiinflamatorio',
                  'antiparasitario', 'vitamina', 'suplemento', 'otro')
  CHECK: LENGTH(TRIM(Nombre_Medicamento)) > 0
```

**MEDICAMENTOS_RECETADOS**
```
MEDICAMENTOS_RECETADOS(ID_Receta, ID_Tratamiento, ID_Medicamento, Dosis,
                       Frecuencia, Duracion_Dias, Via_Administracion,
                       Observaciones)
  PK: ID_Receta
  FK: ID_Tratamiento → TRATAMIENTOS(ID_Tratamiento) ON DELETE CASCADE
  FK: ID_Medicamento → MEDICAMENTOS(ID_Medicamento)
  CHECK: Via_Administracion IN ('oral', 'inyectable', 'tópica',
                                'oftálmica', 'ótica')
  CHECK: Duracion_Dias > 0
  CHECK: LENGTH(TRIM(Dosis)) > 0
  CHECK: LENGTH(TRIM(Frecuencia)) > 0
```

**Justificación del Diseño:**

MEDICAMENTOS_RECETADOS es una tabla intermedia que resuelve la relación N:M entre TRATAMIENTOS y MEDICAMENTOS, añadiendo atributos propios de la prescripción (dosis, frecuencia, duración) que no pertenecen ni al tratamiento ni al medicamento por separado.

#### 5.2.9. Módulo 8: Vacunas

**VACUNAS**
```
VACUNAS(ID_Vacuna, Nombre_Vacuna, Descripcion, Enfermedad_Previene,
        Laboratorio, Periodo_Revacunacion_Dias, Es_Obligatoria, ID_Especie)
  PK: ID_Vacuna
  FK: ID_Especie → ESPECIES(ID_Especie)
  CHECK: Periodo_Revacunacion_Dias > 0
  CHECK: LENGTH(TRIM(Nombre_Vacuna)) > 0
```

**VACUNAS_APLICADAS**
```
VACUNAS_APLICADAS(ID_Aplicacion, ID_Mascota, ID_Vacuna, ID_Veterinario,
                  Fecha_Aplicacion, Fecha_Proxima_Dosis, Lote,
                  Observaciones, Reaccion_Adversa)
  PK: ID_Aplicacion
  FK: ID_Mascota → MASCOTAS(ID_Mascota)
  FK: ID_Vacuna → VACUNAS(ID_Vacuna)
  FK: ID_Veterinario → VETERINARIOS(ID_Veterinario)
  UK: (ID_Mascota, ID_Vacuna, Fecha_Aplicacion)
  CHECK: Fecha_Proxima_Dosis IS NULL OR Fecha_Proxima_Dosis > Fecha_Aplicacion
```

#### 5.2.10. Módulo 9: Servicios

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
EMPLEADOS(ID_Empleado, Nombre, Apellido, Puesto, Telefono, Email,
          Fecha_Contratacion, Estado)
  PK: ID_Empleado
  UK: Email
  CHECK: Puesto IN ('groomer', 'recepcionista', 'asistente',
                    'cuidador', 'adiestrador')
  CHECK: Estado IN ('activo', 'inactivo')
  CHECK: Email LIKE '%@%'
```

**SERVICIOS_REALIZADOS**
```
SERVICIOS_REALIZADOS(ID_Servicio_Realizado, ID_Mascota, ID_Servicio,
                     ID_Empleado, Fecha_Servicio, Hora_Inicio, Hora_Fin,
                     Precio_Final, Estado_Pago, Observaciones)
  PK: ID_Servicio_Realizado
  FK: ID_Mascota → MASCOTAS(ID_Mascota)
  FK: ID_Servicio → SERVICIOS(ID_Servicio)
  FK: ID_Empleado → EMPLEADOS(ID_Empleado)
  CHECK: Estado_Pago IN ('pendiente', 'pagado', 'cancelado')
  CHECK: Precio_Final >= 0
  CHECK: Hora_Fin IS NULL OR Hora_Fin > Hora_Inicio
```

### 5.3. RESUMEN DEL MODELO RELACIONAL

#### Tabla 5: Estadísticas del Modelo Relacional

| Métrica | Cantidad | Observaciones |
|---------|----------|---------------|
| **Total de Tablas** | 19 | Distribuidas en 9 módulos funcionales |
| **Tablas de Catálogo** | 6 | Provincias, Ciudades, Especies, Razas, Especialidades, Medicamentos, Vacunas, Servicios |
| **Tablas Maestras** | 4 | Clientes, Mascotas, Veterinarios, Empleados |
| **Tablas Transaccionales** | 6 | Citas, Historial Médico, Tratamientos, Vacunas Aplicadas, Servicios Realizados |
| **Tablas de Detalle** | 3 | Teléfonos Cliente, Medicamentos Recetados |
| **Claves Primarias** | 19 | Una por tabla, todas surrogates (INTEGER) |
| **Claves Foráneas** | 28 | Implementan las relaciones entre tablas |
| **Claves Únicas** | 14 | Garantizan unicidad de atributos de negocio |
| **Restricciones CHECK** | 31 | Validan dominios y reglas de negocio |

#### Tabla 6: Acciones Referenciales Implementadas

| Tabla Hijo | Tabla Padre | Acción ON DELETE | Justificación |
|------------|-------------|------------------|---------------|
| TELEFONOS_CLIENTE | CLIENTES | CASCADE | Los teléfonos no tienen sentido sin el cliente |
| TRATAMIENTOS | HISTORIAL_MEDICO | CASCADE | Los tratamientos son parte del historial |
| MEDICAMENTOS_RECETADOS | TRATAMIENTOS | CASCADE | Las recetas pertenecen al tratamiento |
| MASCOTAS | CLIENTES | RESTRICT | No eliminar cliente con mascotas activas |
| CITAS | MASCOTAS | RESTRICT | Preservar historial de citas |
| HISTORIAL_MEDICO | CITAS | RESTRICT | Preservar trazabilidad médica |

---

<div style="page-break-after: always;"></div>

## VI. PROCESO DE NORMALIZACIÓN

### 6.1. FUNDAMENTOS TEÓRICOS DE LA NORMALIZACIÓN

La normalización es un proceso matemático riguroso para diseñar esquemas relacionales que minimizan redundancia y previenen anomalías de datos (Kent, 1983). Se basa en el concepto de dependencias funcionales y busca descomponer relaciones en estructuras más simples.

#### 6.1.1. Dependencias Funcionales

**Definición Formal:**

Sea R un esquema de relación con conjuntos de atributos X, Y ⊆ R. Decimos que X determina funcionalmente a Y (X → Y) si y solo si para cualesquiera dos tuplas t₁ y t₂ en cualquier instancia válida de R:

```
Si t₁[X] = t₂[X], entonces t₁[Y] = t₂[Y]
```

**Tipos de Dependencias Funcionales:**

1. **Dependencia Trivial:** Y ⊆ X (ejemplo: {ID, Nombre} → Nombre)
2. **Dependencia Completa:** Y depende de todo X, no de un subconjunto propio
3. **Dependencia Parcial:** Y depende de un subconjunto propio de X
4. **Dependencia Transitiva:** X → Y ∧ Y → Z ⇒ X → Z (pero Y no es clave)

#### 6.1.2. Propiedades de las Dependencias Funcionales

**Reglas de Inferencia (Axiomas de Armstrong):**

1. **Reflexividad:** Si Y ⊆ X, entonces X → Y
2. **Aumentatividad:** Si X → Y, entonces XZ → YZ
3. **Transitividad:** Si X → Y ∧ Y → Z, entonces X → Z

**Reglas Derivadas:**

4. **Unión:** Si X → Y ∧ X → Z, entonces X → YZ
5. **Descomposición:** Si X → YZ, entonces X → Y ∧ X → Z
6. **Pseudotransitividad:** Si X → Y ∧ WY → Z, entonces WX → Z

#### 6.1.3. Objetivos de la Normalización

1. **Eliminar redundancia:** Cada dato se almacena en un único lugar
2. **Prevenir anomalías de inserción:** No se requieren datos inexistentes para insertar
3. **Prevenir anomalías de actualización:** Los cambios se realizan en un solo lugar
4. **Prevenir anomalías de eliminación:** No se pierde información al eliminar datos
5. **Simplificar consultas:** Estructura clara y lógica
6. **Optimizar espacio:** Reducir almacenamiento innecesario

### 6.2. FORMA NO NORMALIZADA (0FN)

#### 6.2.1. Situación Inicial

En el escenario inicial, toda la información de la clínica veterinaria se almacenaba en una única tabla monolítica llamada REGISTRO_CLINICA.

**Tabla 7: Estructura 0FN - REGISTRO_CLINICA**

```
REGISTRO_CLINICA
----------------
ID_Registro (PK)
Fecha_Registro
Cliente_Nombre
Cliente_Apellido
Cliente_Direccion_Calle
Cliente_Direccion_Numero
Cliente_Direccion_Ciudad
Cliente_Direccion_Provincia
Cliente_Direccion_CP
Cliente_Telefono1
Cliente_Telefono2
Cliente_Telefono3
Cliente_Email
Cliente_Fecha_Registro
Mascota_Nombre
Mascota_Especie
Mascota_Raza
Mascota_Raza_Tamaño
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
Veterinario_Especialidad_Descripcion
Veterinario_Telefono
Veterinario_Email
Veterinario_Licencia
Diagnostico
Tratamiento_Descripcion
Tratamiento_Fecha_Inicio
Tratamiento_Fecha_Fin
Medicamento_Nombre1
Medicamento_Dosis1
Medicamento_Frecuencia1
Medicamento_Nombre2
Medicamento_Dosis2
Medicamento_Frecuencia2
Medicamento_Nombre3
Medicamento_Dosis3
Medicamento_Frecuencia3
Vacuna_Nombre
Vacuna_Fecha_Aplicacion
Vacuna_Proxima_Dosis
Servicio_Tipo
Servicio_Descripcion
Servicio_Precio
Servicio_Fecha
Empleado_Nombre_Servicio
Total_Pagar
Estado_Pago
```

#### 6.2.2. Problemática Identificada en 0FN

**Problema 1: Redundancia Masiva**

Ejemplo de registros duplicados:

```
ID | Cliente_Nombre | Cliente_Email | Mascota_Nombre | ...
---|----------------|---------------|----------------|-----
1  | Juan Pérez     | juan@email.com| Max           | ...
2  | Juan Pérez     | juan@email.com| Luna          | ...
3  | Juan Pérez     | juan@email.com| Rocky         | ...
```

Los datos del cliente se repiten 3 veces porque tiene 3 mascotas.

**Problema 2: Grupos Repetitivos**

Los campos `Cliente_Telefono1`, `Cliente_Telefono2`, `Cliente_Telefono3` forman un grupo repetitivo. Esto genera:
- Límite arbitrario de 3 teléfonos
- Desperdicio de espacio si el cliente tiene menos teléfonos
- Complejidad en consultas

**Problema 3: Anomalías de Inserción**

No se puede registrar un veterinario si no tiene una cita programada, porque todos los datos están en una sola tabla.

**Problema 4: Anomalías de Actualización**

Si el email de Juan Pérez cambia, hay que actualizar 3 registros. Si se olvida uno, se crea inconsistencia.

**Problema 5: Anomalías de Eliminación**

Si se elimina la última cita de un cliente, se pierde toda su información personal.

**Problema 6: Valores Atómicos Violados**

El campo `Cliente_Direccion_Completa` podría contener "Av. 9 de Octubre #123, Guayaquil, Guayas", violando atomicidad.

**Problema 7: Dependencias Mezcladas**

Existen múltiples dependencias funcionales:
```
Cliente_Email → Cliente_Nombre, Cliente_Apellido
Mascota_Microchip → Mascota_Nombre, Mascota_Especie
Veterinario_Licencia → Veterinario_Nombre, Veterinario_Especialidad
```

Todas mezcladas en una tabla única.

### 6.3. PRIMERA FORMA NORMAL (1FN)

#### 6.3.1. Definición Formal de 1FN

Una relación R está en Primera Forma Normal si y solo si:

1. Todos los dominios de atributos contienen únicamente valores atómicos (indivisibles)
2. El valor de cada atributo contiene un solo valor del dominio
3. No existen grupos repetitivos de atributos

#### 6.3.2. Proceso de Transformación a 1FN

**Paso 1: Identificar grupos repetitivos**

Grupos identificados:
- Teléfonos del cliente (Telefono1, Telefono2, Telefono3)
- Medicamentos (Medicamento1, Medicamento2, Medicamento3)

**Paso 2: Eliminar grupos repetitivos**

Se crean tablas separadas para cada grupo repetitivo.

**Paso 3: Asegurar atomicidad**

Descomponer atributos compuestos:
- Dirección_Completa → Direccion_Calle, Numero_Direccion, Ciudad, Provincia, CP

**Paso 4: Identificar entidades principales**

Se identifican 8 entidades principales:

#### 6.3.3. Esquemas Resultantes en 1FN

**CLIENTES_1FN**
```
CLIENTES_1FN(ID_Cliente, Nombre, Apellido, Direccion_Calle,
             Numero_Direccion, Ciudad, Provincia, Codigo_Postal,
             Email, Fecha_Registro, Estado)
  PK: ID_Cliente
```

**Dependencias Funcionales:**
```
ID_Cliente → Nombre, Apellido, Direccion_Calle, Numero_Direccion,
             Ciudad, Provincia, Codigo_Postal, Email, Fecha_Registro, Estado
Email → ID_Cliente
```

**TELEFONOS_CLIENTE_1FN**
```
TELEFONOS_CLIENTE_1FN(ID_Telefono, ID_Cliente, Numero_Telefono,
                      Tipo_Telefono, Es_Principal)
  PK: ID_Telefono
  FK: ID_Cliente → CLIENTES_1FN(ID_Cliente)
```

**Dependencias Funcionales:**
```
ID_Telefono → ID_Cliente, Numero_Telefono, Tipo_Telefono, Es_Principal
(ID_Cliente, Numero_Telefono) → ID_Telefono
```

**MASCOTAS_1FN**
```
MASCOTAS_1FN(ID_Mascota, ID_Cliente, Nombre, Especie, Raza,
             Raza_Tamaño, Fecha_Nacimiento, Color, Peso, Genero,
             Numero_Microchip, Fecha_Registro, Estado)
  PK: ID_Mascota
  FK: ID_Cliente → CLIENTES_1FN(ID_Cliente)
```

**VETERINARIOS_1FN**
```
VETERINARIOS_1FN(ID_Veterinario, Nombre, Apellido, Especialidad,
                 Especialidad_Descripcion, Telefono, Email,
                 Numero_Licencia, Fecha_Contratacion, Estado)
  PK: ID_Veterinario
```

**CITAS_1FN**
```
CITAS_1FN(ID_Cita, ID_Mascota, ID_Veterinario, Fecha_Cita, Hora_Cita,
          Motivo_Consulta, Estado_Cita, Observaciones)
  PK: ID_Cita
  FK: ID_Mascota → MASCOTAS_1FN(ID_Mascota)
  FK: ID_Veterinario → VETERINARIOS_1FN(ID_Veterinario)
```

**HISTORIAL_MEDICO_1FN**
```
HISTORIAL_MEDICO_1FN(ID_Historial, ID_Cita, ID_Mascota, ID_Veterinario,
                     Fecha_Consulta, Diagnostico, Tratamiento_Descripcion,
                     Tratamiento_Fecha_Inicio, Tratamiento_Fecha_Fin,
                     Peso_Registrado, Temperatura, Observaciones)
  PK: ID_Historial
  FK: ID_Cita → CITAS_1FN(ID_Cita)
```

**VACUNAS_APLICADAS_1FN**
```
VACUNAS_APLICADAS_1FN(ID_Aplicacion, ID_Mascota, Vacuna_Nombre,
                      Vacuna_Descripcion, Vacuna_Enfermedad_Previene,
                      Fecha_Aplicacion, Fecha_Proxima_Dosis, Lote,
                      ID_Veterinario)
  PK: ID_Aplicacion
  FK: ID_Mascota → MASCOTAS_1FN(ID_Mascota)
  FK: ID_Veterinario → VETERINARIOS_1FN(ID_Veterinario)
```

**SERVICIOS_REALIZADOS_1FN**
```
SERVICIOS_REALIZADOS_1FN(ID_Servicio_Realizado, ID_Mascota, Tipo_Servicio,
                         Nombre_Servicio, Descripcion_Servicio,
                         Precio_Base_Servicio, Fecha_Servicio, Precio_Final,
                         Estado_Pago, Empleado_Nombre, Empleado_Puesto)
  PK: ID_Servicio_Realizado
  FK: ID_Mascota → MASCOTAS_1FN(ID_Mascota)
```

#### 6.3.4. Logros de 1FN

**Mejoras Obtenidas:**

1. ✅ **Atomicidad garantizada:** Todos los atributos contienen valores atómicos
2. ✅ **Grupos repetitivos eliminados:** Los teléfonos están en tabla separada
3. ✅ **Estructura más clara:** 8 tablas en lugar de 1 monolítica
4. ✅ **Reducción parcial de redundancia:** Datos del cliente no se repiten por cada mascota

**Problemas Persistentes:**

1. ❌ **Dependencias parciales:** En MASCOTAS_1FN, el tamaño de la raza depende de la raza, no de la mascota
2. ❌ **Dependencias transitivas:** En CLIENTES_1FN, la provincia depende de la ciudad
3. ❌ **Datos de catálogo mezclados:** La información de vacunas está mezclada con su aplicación

**Conclusión de 1FN:**

La base de datos está en 1FN pero aún presenta anomalías que se resolverán en 2FN y 3FN.

---

<div style="page-break-after: always;"></div>

### 6.4. SEGUNDA FORMA NORMAL (2FN)

#### 6.4.1. Definición Formal de 2FN

Una relación R está en Segunda Forma Normal si y solo si:

1. Está en Primera Forma Normal (1FN)
2. Todos los atributos no primos dependen funcionalmente de forma **completa** de la clave primaria (no existen dependencias parciales)

**Nota:** Una dependencia parcial ocurre cuando un atributo no primo depende solo de una parte de una clave primaria compuesta.

#### 6.4.2. Análisis de Dependencias Parciales

**Análisis de MASCOTAS_1FN:**

```
MASCOTAS_1FN(ID_Mascota, ID_Cliente, Nombre, Especie, Raza,
             Raza_Tamaño, Fecha_Nacimiento, Color, Peso, ...)
```

Dependencias funcionales identificadas:
```
ID_Mascota → Nombre, Especie, Raza, Fecha_Nacimiento, Color, Peso, ...
Raza → Raza_Tamaño, Especie
Especie → {conjunto de razas posibles}
```

**Problema:** `Raza_Tamaño` depende de `Raza`, no directamente de `ID_Mascota`. Esto genera:
- Redundancia: Si 100 mascotas son "Labrador", se repite "grande" 100 veces
- Anomalía de actualización: Si cambia el tamaño promedio del Labrador, hay que actualizar 100 registros

**Análisis de VETERINARIOS_1FN:**

```
VETERINARIOS_1FN(ID_Veterinario, Nombre, Apellido, Especialidad,
                 Especialidad_Descripcion, ...)
```

Dependencias funcionales:
```
ID_Veterinario → Nombre, Apellido, Especialidad, Especialidad_Descripcion, ...
Especialidad → Especialidad_Descripcion
```

**Problema:** `Especialidad_Descripcion` depende de `Especialidad`, no de `ID_Veterinario`.

**Análisis de VACUNAS_APLICADAS_1FN:**

```
VACUNAS_APLICADAS_1FN(ID_Aplicacion, ID_Mascota, Vacuna_Nombre,
                      Vacuna_Descripcion, Vacuna_Enfermedad_Previene, ...)
```

Dependencias:
```
ID_Aplicacion → ID_Mascota, Vacuna_Nombre, Fecha_Aplicacion, ...
Vacuna_Nombre → Vacuna_Descripcion, Vacuna_Enfermedad_Previene
```

**Problema:** La información de la vacuna depende del nombre de la vacuna, no de la aplicación específica.

#### 6.4.3. Proceso de Transformación a 2FN

**Estrategia:** Descomponer tablas con dependencias parciales en:
1. Una tabla con la clave primaria y atributos que dependen completamente de ella
2. Tablas de catálogo con atributos que dependen de otras claves candidatas

**Transformación 1: Separar ESPECIES y RAZAS**

```
ESPECIES_2FN(ID_Especie, Nombre_Especie, Descripcion)
  PK: ID_Especie

RAZAS_2FN(ID_Raza, ID_Especie, Nombre_Raza, Tamaño_Promedio, Caracteristicas)
  PK: ID_Raza
  FK: ID_Especie → ESPECIES_2FN(ID_Especie)

MASCOTAS_2FN(ID_Mascota, ID_Cliente, Nombre, ID_Especie, ID_Raza,
             Fecha_Nacimiento, Color, Peso, Genero, Numero_Microchip, ...)
  PK: ID_Mascota
  FK: ID_Cliente → CLIENTES_2FN(ID_Cliente)
  FK: ID_Especie → ESPECIES_2FN(ID_Especie)
  FK: ID_Raza → RAZAS_2FN(ID_Raza)
```

**Justificación:**
- Ahora `Tamaño_Promedio` depende de `ID_Raza`, su clave primaria
- No hay redundancia: el tamaño del Labrador se almacena una sola vez
- Facilita añadir nuevas razas sin modificar tablas de mascotas

**Transformación 2: Separar ESPECIALIDADES**

```
ESPECIALIDADES_2FN(ID_Especialidad, Nombre_Especialidad, Descripcion)
  PK: ID_Especialidad

VETERINARIOS_2FN(ID_Veterinario, Nombre, Apellido, ID_Especialidad,
                 Telefono, Email, Numero_Licencia, ...)
  PK: ID_Veterinario
  FK: ID_Especialidad → ESPECIALIDADES_2FN(ID_Especialidad)
```

**Transformación 3: Separar MEDICAMENTOS y crear tabla intermedia**

```
MEDICAMENTOS_2FN(ID_Medicamento, Nombre_Medicamento, Descripcion,
                 Laboratorio, Presentacion, Tipo, Requiere_Receta)
  PK: ID_Medicamento

TRATAMIENTOS_2FN(ID_Tratamiento, ID_Historial, Descripcion_Tratamiento,
                 Fecha_Inicio, Fecha_Fin, Instrucciones, Estado)
  PK: ID_Tratamiento
  FK: ID_Historial → HISTORIAL_MEDICO_2FN(ID_Historial)

MEDICAMENTOS_RECETADOS_2FN(ID_Receta, ID_Tratamiento, ID_Medicamento,
                           Dosis, Frecuencia, Duracion_Dias, Via_Administracion)
  PK: ID_Receta
  FK: ID_Tratamiento → TRATAMIENTOS_2FN(ID_Tratamiento)
  FK: ID_Medicamento → MEDICAMENTOS_2FN(ID_Medicamento)
```

**Transformación 4: Separar VACUNAS**

```
VACUNAS_2FN(ID_Vacuna, Nombre_Vacuna, Descripcion, Enfermedad_Previene,
            Laboratorio, Periodo_Revacunacion_Dias, Es_Obligatoria, ID_Especie)
  PK: ID_Vacuna
  FK: ID_Especie → ESPECIES_2FN(ID_Especie)

VACUNAS_APLICADAS_2FN(ID_Aplicacion, ID_Mascota, ID_Vacuna, ID_Veterinario,
                      Fecha_Aplicacion, Fecha_Proxima_Dosis, Lote,
                      Observaciones, Reaccion_Adversa)
  PK: ID_Aplicacion
  FK: ID_Mascota → MASCOTAS_2FN(ID_Mascota)
  FK: ID_Vacuna → VACUNAS_2FN(ID_Vacuna)
  FK: ID_Veterinario → VETERINARIOS_2FN(ID_Veterinario)
```

**Transformación 5: Separar SERVICIOS y EMPLEADOS**

```
SERVICIOS_2FN(ID_Servicio, Nombre_Servicio, Descripcion, Precio_Base,
              Duracion_Estimada_Min, Tipo_Servicio)
  PK: ID_Servicio

EMPLEADOS_2FN(ID_Empleado, Nombre, Apellido, Puesto, Telefono, Email,
              Fecha_Contratacion, Estado)
  PK: ID_Empleado

SERVICIOS_REALIZADOS_2FN(ID_Servicio_Realizado, ID_Mascota, ID_Servicio,
                         ID_Empleado, Fecha_Servicio, Hora_Inicio, Hora_Fin,
                         Precio_Final, Estado_Pago, Observaciones)
  PK: ID_Servicio_Realizado
  FK: ID_Mascota → MASCOTAS_2FN(ID_Mascota)
  FK: ID_Servicio → SERVICIOS_2FN(ID_Servicio)
  FK: ID_Empleado → EMPLEADOS_2FN(ID_Empleado)
```

#### 6.4.4. Esquemas Completos en 2FN

**Resumen de tablas resultantes en 2FN:**

1. CLIENTES_2FN
2. TELEFONOS_CLIENTE_2FN
3. ESPECIES_2FN (nueva)
4. RAZAS_2FN (nueva)
5. MASCOTAS_2FN (modificada)
6. ESPECIALIDADES_2FN (nueva)
7. VETERINARIOS_2FN (modificada)
8. CITAS_2FN
9. HISTORIAL_MEDICO_2FN
10. TRATAMIENTOS_2FN (nueva)
11. MEDICAMENTOS_2FN (nueva)
12. MEDICAMENTOS_RECETADOS_2FN (nueva)
13. VACUNAS_2FN (nueva)
14. VACUNAS_APLICADAS_2FN (modificada)
15. SERVICIOS_2FN (nueva)
16. EMPLEADOS_2FN (nueva)
17. SERVICIOS_REALIZADOS_2FN (modificada)

**Total: 17 tablas** (aumentó de 8 a 17)

#### 6.4.5. Logros de 2FN

**Mejoras Obtenidas:**

1. ✅ **Eliminadas dependencias parciales:** Todos los atributos no primos dependen completamente de sus claves primarias
2. ✅ **Catálogos separados:** Especies, Razas, Especialidades, Medicamentos, Vacunas, Servicios
3. ✅ **Reducción significativa de redundancia:** Información de catálogos almacenada una sola vez
4. ✅ **Mayor flexibilidad:** Fácil añadir nuevos elementos de catálogo
5. ✅ **Consultas más eficientes:** Joins claros y estructurados

**Problemas Persistentes:**

1. ❌ **Dependencias transitivas:** En CLIENTES_2FN, Provincia depende de Ciudad
2. ❌ **Algunas redundancias menores:** Aún existen dependencias transitivas por resolver

**Conclusión de 2FN:**

La base de datos está en 2FN pero aún presenta dependencias transitivas que se resolverán en 3FN.

---

<div style="page-break-after: always;"></div>

### 6.5. TERCERA FORMA NORMAL (3FN)

#### 6.5.1. Definición Formal de 3FN

Una relación R está en Tercera Forma Normal si y solo si:

1. Está en Segunda Forma Normal (2FN)
2. No existen dependencias transitivas de atributos no primos respecto a la clave primaria

**Definición de Dependencia Transitiva:**

Para atributos X, Y, Z de R, existe dependencia transitiva si:
- X → Y (Y no es clave)
- Y → Z (Z no es clave)
- Por tanto, X → Z (transitivamente)

#### 6.5.2. Análisis de Dependencias Transitivas

**Análisis de CLIENTES_2FN:**

```
CLIENTES_2FN(ID_Cliente, Nombre, Apellido, Direccion_Calle,
             Numero_Direccion, Ciudad, Provincia, Codigo_Postal, Email, ...)
```

Dependencias funcionales:
```
ID_Cliente → Ciudad, Provincia, Codigo_Postal
Ciudad → Provincia
```

**Dependencia Transitiva Identificada:**
```
ID_Cliente → Ciudad → Provincia
```

Por tanto: `ID_Cliente → Provincia` (transitivamente)

**Problema:** 
- Si 1000 clientes viven en Guayaquil, "Guayas" se repite 1000 veces
- Si cambia el nombre de la provincia, hay que actualizar 1000 registros
- No se puede almacenar información de una provincia sin tener clientes en ella

**Análisis Visual:**

```
Cliente: Juan Pérez → Ciudad: Guayaquil → Provincia: Guayas
Cliente: María López → Ciudad: Guayaquil → Provincia: Guayas
Cliente: Carlos Ruiz → Ciudad: Guayaquil → Provincia: Guayas
                                           ↑
                                    Redundancia!
```

**Otras Dependencias Transitivas Menores:**

En algunas implementaciones podría considerarse:
```
ID_Mascota → ID_Raza → ID_Especie
```

Pero esta es aceptable porque necesitamos ambos IDs para facilitar consultas. Es una desnormalización controlada.

#### 6.5.3. Proceso de Transformación a 3FN

**Estrategia:** Eliminar dependencias transitivas creando tablas intermedias que contengan el atributo determinante como clave primaria.

**Transformación: Separar PROVINCIAS y CIUDADES**

**Antes (2FN):**
```
CLIENTES_2FN(ID_Cliente, Nombre, Apellido, Direccion_Calle,
             Numero_Direccion, Ciudad, Provincia, Codigo_Postal, ...)
```

**Después (3FN):**

```
PROVINCIAS_3FN(ID_Provincia, Nombre_Provincia, Codigo_Provincia, Pais)
  PK: ID_Provincia
  UK: Codigo_Provincia
  
Dependencias:
  ID_Provincia → Nombre_Provincia, Codigo_Provincia, Pais
```

```
CIUDADES_3FN(ID_Ciudad, ID_Provincia, Nombre_Ciudad, Codigo_Postal)
  PK: ID_Ciudad
  FK: ID_Provincia → PROVINCIAS_3FN(ID_Provincia)
  UK: (Nombre_Ciudad, ID_Provincia)
  
Dependencias:
  ID_Ciudad → ID_Provincia, Nombre_Ciudad, Codigo_Postal
```

```
CLIENTES_3FN(ID_Cliente, Nombre, Apellido, Direccion_Calle,
             Numero_Direccion, ID_Ciudad, Email, Fecha_Registro, Estado)
  PK: ID_Cliente
  FK: ID_Ciudad → CIUDADES_3FN(ID_Ciudad)
  UK: Email
  
Dependencias:
  ID_Cliente → Nombre, Apellido, Direccion_Calle, Numero_Direccion,
               ID_Ciudad, Email, Fecha_Registro, Estado
```

**Justificación de la Transformación:**

1. **Elimina redundancia:** El nombre de la provincia se almacena una sola vez en PROVINCIAS_3FN
2. **Previene anomalías de actualización:** Cambiar el nombre de una provincia requiere un solo UPDATE
3. **Permite independencia de datos:** Podemos tener provincias sin clientes
4. **Facilita consultas geográficas:** Join simple para obtener provincia del cliente
5. **Soporte para múltiples ciudades homónimas:** Ambato (Tungurahua) vs. Ambato (otra provincia)

**Verificación de 3FN:**

Analicemos si CLIENTES_3FN está en 3FN:

```
Dependencias funcionales en CLIENTES_3FN:
  ID_Cliente → Nombre
  ID_Cliente → Apellido
  ID_Cliente → ID_Ciudad
  Email → ID_Cliente (clave candidata)
```

¿Hay dependencias transitivas?
- `ID_Cliente → ID_Ciudad → Nombre_Ciudad`

Sin embargo, `Nombre_Ciudad` ya no está en CLIENTES_3FN, está en CIUDADES_3FN.

✅ **No hay dependencias transitivas en CLIENTES_3FN**

Analicemos CIUDADES_3FN:

```
Dependencias en CIUDADES_3FN:
  ID_Ciudad → Nombre_Ciudad
  ID_Ciudad → ID_Provincia
  ID_Ciudad → Codigo_Postal
```

¿Hay dependencias transitivas?
- `ID_Ciudad → ID_Provincia → Nombre_Provincia`

Pero `Nombre_Provincia` no está en CIUDADES_3FN, está en PROVINCIAS_3FN.

✅ **No hay dependencias transitivas en CIUDADES_3FN**

#### 6.5.4. Esquemas Finales en 3FN

**Conjunto completo de 19 tablas en 3FN:**

**Módulo 1: Ubicaciones (2 tablas)**
1. PROVINCIAS
2. CIUDADES

**Módulo 2: Clientes (2 tablas)**
3. CLIENTES
4. TELEFONOS_CLIENTE

**Módulo 3: Mascotas (3 tablas)**
5. ESPECIES
6. RAZAS
7. MASCOTAS

**Módulo 4: Veterinarios (2 tablas)**
8. ESPECIALIDADES
9. VETERINARIOS

**Módulo 5: Citas (1 tabla)**
10. CITAS

**Módulo 6: Historial Médico (2 tablas)**
11. HISTORIAL_MEDICO
12. TRATAMIENTOS

**Módulo 7: Medicamentos (2 tablas)**
13. MEDICAMENTOS
14. MEDICAMENTOS_RECETADOS

**Módulo 8: Vacunas (2 tablas)**
15. VACUNAS
16. VACUNAS_APLICADAS

**Módulo 9: Servicios (3 tablas)**
17. SERVICIOS
18. EMPLEADOS
19. SERVICIOS_REALIZADOS

#### 6.5.5. Verificación Formal de 3FN

Para cada tabla, verificamos:

1. ✅ **Está en 1FN:** Todos los valores son atómicos
2. ✅ **Está en 2FN:** No hay dependencias parciales
3. ✅ **Está en 3FN:** No hay dependencias transitivas

**Tabla de Verificación:**

| Tabla | 1FN | 2FN | 3FN | Observaciones |
|-------|-----|-----|-----|---------------|
| PROVINCIAS | ✅ | ✅ | ✅ | Clave simple, sin dependencias transitivas |
| CIUDADES | ✅ | ✅ | ✅ | Clave simple, referencia a provincia |
| CLIENTES | ✅ | ✅ | ✅ | Eliminada dependencia Ciudad→Provincia |
| TELEFONOS_CLIENTE | ✅ | ✅ | ✅ | Clave simple, todos dependen de PK |
| ESPECIES | ✅ | ✅ | ✅ | Tabla de catálogo simple |
| RAZAS | ✅ | ✅ | ✅ | Referencia a especie, sin transitivas |
| MASCOTAS | ✅ | ✅ | ✅ | Referencias a catálogos separados |
| ESPECIALIDADES | ✅ | ✅ | ✅ | Tabla de catálogo simple |
| VETERINARIOS | ✅ | ✅ | ✅ | Referencia a especialidad separada |
| CITAS | ✅ | ✅ | ✅ | Relación entre mascota y veterinario |
| HISTORIAL_MEDICO | ✅ | ✅ | ✅ | Relación 1:1 con cita |
| TRATAMIENTOS | ✅ | ✅ | ✅ | Depende de historial |
| MEDICAMENTOS | ✅ | ✅ | ✅ | Catálogo independiente |
| MEDICAMENTOS_RECETADOS | ✅ | ✅ | ✅ | Tabla intermedia N:M |
| VACUNAS | ✅ | ✅ | ✅ | Catálogo con referencia a especie |
| VACUNAS_APLICADAS | ✅ | ✅ | ✅ | Tabla intermedia N:M |
| SERVICIOS | ✅ | ✅ | ✅ | Catálogo de servicios |
| EMPLEADOS | ✅ | ✅ | ✅ | Entidad independiente |
| SERVICIOS_REALIZADOS | ✅ | ✅ | ✅ | Tabla intermedia N:M |

#### 6.5.6. Logros de 3FN

**Mejoras Finales Obtenidas:**

1. ✅ **Eliminación total de redundancia controlada:** Cada dato en un único lugar
2. ✅ **Sin dependencias transitivas:** Estructura completamente normalizada
3. ✅ **Prevención de todas las anomalías:**
   - Sin anomalías de inserción
   - Sin anomalías de actualización
   - Sin anomalías de eliminación
4. ✅ **Máxima integridad referencial:** Todas las relaciones formalmente definidas
5. ✅ **Estructura modular y escalable:** Fácil añadir nuevos módulos
6. ✅ **Optimización de consultas:** Estructura clara para joins eficientes
7. ✅ **Mantenimiento simplificado:** Cambios localizados
8. ✅ **Cumplimiento de mejores prácticas:** Diseño profesional y robusto

### 6.6. RESUMEN COMPARATIVO DEL PROCESO DE NORMALIZACIÓN

#### Tabla 8: Evolución del Diseño

| Aspecto | 0FN | 1FN | 2FN | 3FN |
|---------|-----|-----|-----|-----|
| **Número de tablas** | 1 | 8 | 17 | 19 |
| **Redundancia** | Máxima | Alta | Media | Mínima |
| **Atomicidad** | ❌ | ✅ | ✅ | ✅ |
| **Grupos repetitivos** | ❌ | ✅ | ✅ | ✅ |
| **Dependencias parciales** | ❌ | ❌ | ✅ | ✅ |
| **Dependencias transitivas** | ❌ | ❌ | ❌ | ✅ |
| **Anomalías de inserción** | Muchas | Algunas | Pocas | Ninguna |
| **Anomalías de actualización** | Muchas | Algunas | Pocas | Ninguna |
| **Anomalías de eliminación** | Muchas | Algunas | Pocas | Ninguna |
| **Complejidad de consultas** | Baja | Media | Alta | Alta |
| **Mantenibilidad** | Muy baja | Baja | Media | Alta |
| **Escalabilidad** | Nula | Baja | Media | Alta |
| **Integridad** | Nula | Baja | Media | Máxima |

#### Tabla 9: Ejemplos de Eliminación de Redundancia

| Dato | 0FN (Ocurrencias) | 3FN (Ocurrencias) | Reducción |
|------|-------------------|-------------------|-----------|
| Nombre de Provincia "Guayas" | 1000 (por cada cliente) | 1 (en PROVINCIAS) | 99.9% |
| Tamaño de raza "Labrador" | 500 (por cada mascota) | 1 (en RAZAS) | 99.8% |
| Descripción de vacuna "Antirrábica" | 300 (por cada aplicación) | 1 (en VACUNAS) | 99.67% |
| Especialidad "Cirugía" | 50 (por cada veterinario) | 1 (en ESPECIALIDADES) | 98% |

**Ahorro estimado de almacenamiento: 85-90%**

---

**FIN DE LA PARTE 2**

---

*Este documento es propiedad intelectual del autor y fue elaborado con fines académicos para la asignatura de Bases de Datos Relacionales. Queda prohibida su reproducción total o parcial sin autorización expresa.*
