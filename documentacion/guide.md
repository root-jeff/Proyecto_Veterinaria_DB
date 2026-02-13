# 🎤 GUIÓN DE EXPOSICIÓN 
## SISTEMA DE GESTIÓN DE CLÍNICA VETERINARIA

---

## 📌 INFORMACIÓN DE LA PRESENTACIÓN

- **Duración estimada**: 15-20 minutos
- **Audiencia**: Académica/Técnica
- **Materiales necesarios**: Proyector, acceso a base de datos, IDE con aplicación Java
- **Demostración práctica**: Sí (5-7 minutos)

---

## 🎯 ESTRUCTURA DE LA EXPOSICIÓN

### INTRODUCCIÓN (2 minutos)
### DISEÑO DE BASE DE DATOS (5 minutos)
### IMPLEMENTACIÓN TÉCNICA (4 minutos)
### DEMOSTRACIÓN EN VIVO (5 minutos)
### CONCLUSIONES Y PREGUNTAS (3 minutos)

---

# 📝 GUIÓN DETALLADO

## 1️⃣ INTRODUCCIÓN (2 minutos)

### 1.1 Bienvenida y Presentación del Proyecto

> **[DIAPOSITIVA: Portada del proyecto]**

**TEXTO:**
"Buenos días/tardes. Hoy voy a presentar el Sistema de Gestión de Clínica Veterinaria, un proyecto integral que abarca desde el diseño conceptual de una base de datos relacional hasta su implementación completa con una aplicación Java funcional."

### 1.2 Contexto y Problemática

**TEXTO:**
"El problema que buscamos resolver es la gestión eficiente de:
- Clientes y sus mascotas
- Citas médicas y asignación de veterinarios
- Historial médico completo
- Control de vacunación y servicios adicionales

Todo esto debe manejarse de manera organizada, sin redundancia de datos y garantizando la integridad de la información."

### 1.3 Objetivos del Proyecto

> **[DIAPOSITIVA: Objetivos]**

**PUNTOS CLAVE:**
- ✅ Diseñar una base de datos normalizada (3FN)
- ✅ Implementar el modelo relacional completo
- ✅ Crear scripts SQL funcionales
- ✅ Desarrollar una aplicación Java con arquitectura DAO
- ✅ Implementar consultas SQL avanzadas

**TEXTO:**
"Nuestro enfoque fue crear un sistema completo, desde los fundamentos teóricos hasta la aplicación práctica, siguiendo las mejores prácticas de diseño de bases de datos y programación."

---

## 2️⃣ DISEÑO DE BASE DE DATOS (5 minutos)

### 2.1 Proceso de Normalización

> **[DIAPOSITIVA: Tabla sin normalizar]**

**TEXTO:**
"Comenzamos con un análisis del problema. Inicialmente, podríamos tener toda la información en una sola tabla, lo que generaría problemas graves de redundancia."

**EJEMPLO:**
"Imaginen una tabla donde cada cita repite toda la información del cliente, la mascota, el veterinario... Si un cliente tiene 5 mascotas, su nombre, dirección y teléfono se repetirían innecesariamente."

#### Explicar el proceso de normalización:

> **[DIAPOSITIVA: Primera Forma Normal - 1FN]**

**TEXTO:**
"Aplicamos la **Primera Forma Normal** eliminando grupos repetitivos. Por ejemplo, separamos los teléfonos del cliente en una tabla independiente, ya que un cliente puede tener múltiples números."

> **[DIAPOSITIVA: Segunda Forma Normal - 2FN]**

**TEXTO:**
"En la **Segunda Forma Normal**, eliminamos dependencias parciales. Creamos tablas separadas para entidades como Clientes, Mascotas, Veterinarios, cada una con su propia clave primaria."

> **[DIAPOSITIVA: Tercera Forma Normal - 3FN]**

**TEXTO:**
"Finalmente, en la **Tercera Forma Normal**, eliminamos dependencias transitivas. Por ejemplo, la ciudad depende de la provincia, no directamente del cliente. Por eso creamos tablas separadas para PROVINCIAS y CIUDADES."

### 2.2 Modelo Entidad-Relación (MER)

> **[DIAPOSITIVA: Diagrama MER completo]**

**TEXTO:**
"El resultado es un Modelo Entidad-Relación con **19 tablas** organizadas en módulos lógicos:"

**RECORRER EL DIAGRAMA:**
- **Módulo de Ubicaciones**: Provincias y Ciudades
- **Módulo de Clientes**: Clientes, Teléfonos, Emails
- **Módulo de Mascotas**: Mascotas, Especies, Razas
- **Módulo de Personal**: Veterinarios, Especialidades, Horarios
- **Módulo de Citas**: Citas y Estados
- **Módulo de Servicios Médicos**: Historial Médico, Medicamentos, Vacunas
- **Módulo de Servicios Adicionales**: Estética, Hospedaje, Productos

**DESTACAR:**
"Observen las relaciones: Tenemos **28 relaciones de clave foránea** que garantizan la integridad referencial. Por ejemplo, una cita no puede existir sin una mascota, y una mascota no puede existir sin un cliente."

### 2.3 Modelo Relacional

> **[DIAPOSITIVA: Esquemas relacionales principales]**

**TEXTO:**
"Traducimos el MER al Modelo Relacional con notación formal. Cada tabla tiene sus atributos bien definidos, claves primarias y foráneas claramente identificadas."

**EJEMPLO DE UNA TABLA:**
```
MASCOTAS(
  ID_Mascota PK,
  ID_Cliente FK → CLIENTES,
  ID_Especie FK → ESPECIES,
  ID_Raza FK → RAZAS,
  Nombre,
  Fecha_Nacimiento,
  Peso,
  Color,
  Genero,
  Numero_Microchip,
  Estado_Salud,
  Fecha_Registro
)
```

**TEXTO:**
"Este modelo garantiza que no podemos registrar una mascota sin un cliente válido, ni una raza sin su especie correspondiente."

### 2.4 Estadísticas del Diseño

> **[DIAPOSITIVA: Estadísticas]**

**TEXTO:**
"Nuestro diseño final incluye:
- **19 tablas** organizadas en 7 módulos
- **28 relaciones de clave foránea** para integridad referencial
- **45+ constraints** (NOT NULL, CHECK, UNIQUE)
- **27+ índices** para optimizar consultas
- **100% normalizado en 3FN**, sin redundancia de datos"

---

## 3️⃣ IMPLEMENTACIÓN TÉCNICA (4 minutos)

### 3.1 Scripts SQL de Creación

> **[DIAPOSITIVA: Código SQL]**

**TEXTO:**
"Implementamos todo el diseño en scripts SQL ejecutables. Tenemos tres scripts principales:"

**EXPLICAR:**
1. **veterinaria_db_creation.sql**: Crea todas las tablas, constraints e índices
2. **veterinaria_seed_data.sql**: Inserta datos de prueba realistas
3. **veterinaria_queries.sql**: Contiene 12 consultas SQL avanzadas

**MOSTRAR EJEMPLO DE TABLA:**
```sql
CREATE TABLE MASCOTAS (
    ID_Mascota INT IDENTITY(1,1) PRIMARY KEY,
    ID_Cliente INT NOT NULL,
    ID_Especie INT NOT NULL,
    ID_Raza INT NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    Fecha_Nacimiento DATE NOT NULL,
    CONSTRAINT FK_Mascota_Cliente 
        FOREIGN KEY (ID_Cliente) REFERENCES CLIENTES(ID_Cliente),
    CONSTRAINT CHK_Peso_Positivo 
        CHECK (Peso_KG > 0)
);
```

**TEXTO:**
"Noten los constraints: aseguran que el peso sea positivo, que las fechas sean válidas, y que todas las relaciones sean consistentes."

### 3.2 Arquitectura de la Aplicación Java

> **[DIAPOSITIVA: Arquitectura en capas]**

**TEXTO:**
"Para la aplicación, implementamos el patrón de diseño **DAO (Data Access Object)**, que separa la lógica de negocio del acceso a datos."

**EXPLICAR LAS CAPAS:**

```
┌─────────────────────────┐
│   VeterinariaApp.java   │  ← Interfaz de usuario (menús)
│    (Capa de Presentación)│
└────────────┬────────────┘
             │
┌────────────▼────────────┐
│    Capa DAO             │
│  - MascotaDAO           │  ← Lógica de acceso a datos
│  - CitaDAO              │
│  - VeterinarioDAO       │
│  - HistorialMedicoDAO   │
└────────────┬────────────┘
             │
┌────────────▼────────────┐
│  DatabaseConnection     │  ← Conexión singleton
└────────────┬────────────┘
             │
┌────────────▼────────────┐
│   PostgreSQL Database   │  ← Base de datos
└─────────────────────────┘
```

**TEXTO:**
"Esta arquitectura nos da:
- **Separación de responsabilidades**
- **Reutilización de código**
- **Facilidad de mantenimiento**
- **Independencia de la base de datos**"

### 3.3 Componentes Principales

> **[DIAPOSITIVA: Componentes]**

**TEXTO:**
"Nuestra aplicación tiene tres capas principales:"

#### **1. Capa de Modelo (model/)**
**TEXTO:**
"Define las clases Java que representan nuestras entidades: Mascota, Cliente, Cita, Veterinario, etc. Son POJOs (Plain Old Java Objects) con getters y setters."

#### **2. Capa DAO (dao/)**
**TEXTO:**
"Contiene toda la lógica de acceso a datos. Cada DAO maneja las operaciones CRUD de su entidad. Por ejemplo, MascotaDAO tiene métodos para:
- Insertar nuevas mascotas
- Listar mascotas por cliente
- Obtener especies y razas disponibles"

#### **3. Capa de Conexión (database/)**
**TEXTO:**
"DatabaseConnection es un Singleton que gestiona la conexión a PostgreSQL. Se configura desde un archivo config.properties, lo que permite cambiar fácilmente entre bases de datos sin recompilar."

### 3.4 Funcionalidades Implementadas

> **[DIAPOSITIVA: Menú de funcionalidades]**

**TEXTO:**
"Implementamos todas las funcionalidades requeridas y algunas adicionales:"

**LISTAR:**
1. ✅ **Registrar nueva mascota**: Con validaciones de datos
2. ✅ **Asignar cita a veterinario**: Verificando disponibilidad
3. ✅ **Consultar historial médico**: Completo y detallado
4. ✅ **Consultas avanzadas**: Tres reportes estadísticos
5. ➕ **Listar mascotas**: Todas las registradas
6. ➕ **Ver próximas citas**: Calendario de citas pendientes

---

## 4️⃣ DEMOSTRACIÓN EN VIVO (5 minutos)

### 4.1 Preparación

**ANTES DE EMPEZAR:**
> "Ahora voy a demostrar el sistema en funcionamiento. Tenemos la base de datos PostgreSQL corriendo con datos de prueba."

**ABRIR:**
- Terminal con la aplicación Java lista
- Opcionalmente: Cliente de base de datos en otra ventana

### 4.2 Demostración 1: Registrar una Mascota

**EJECUTAR LA APLICACIÓN:**
```
java -cp ".;lib/*" VeterinariaApp
```

**NARRAR MIENTRAS HACES:**
1. "Seleccionamos la opción 1: Registrar nueva mascota"
2. "Primero elegimos el cliente dueño de una lista"
3. "Seleccionamos la especie, por ejemplo: Perro"
4. "El sistema muestra solo las razas de Perro"
5. "Ingresamos los datos: nombre, fecha de nacimiento, color, peso, género"
6. "Opcionalmente el número de microchip"
7. "El sistema valida los datos y confirma el registro"

**TEXTO:**
> "Observen cómo el sistema valida que el peso sea positivo y que la fecha sea coherente. Estas validaciones están tanto en la aplicación como en la base de datos."

### 4.3 Demostración 2: Asignar una Cita

**NARRAR:**
1. "Seleccionamos la opción 2: Asignar cita"
2. "Elegimos la mascota que acabamos de registrar"
3. "Vemos la lista de veterinarios con sus especialidades"
4. "Seleccionamos uno e ingresamos la fecha y hora"
5. "El sistema verifica que el veterinario no tenga otra cita a esa hora"
6. "Se programa la cita con estado 'pendiente'"

**TEXTO:**
> "Esta verificación de disponibilidad es crucial en una clínica real. El sistema previene conflictos de horario automáticamente."

### 4.4 Demostración 3: Consultar Historial Médico

**NARRAR:**
1. "Opción 3: Consultar historial"
2. "Seleccionamos una mascota con historial existente"
3. "El sistema muestra:"
   - Datos generales de la mascota
   - Todas las consultas médicas previas
   - Diagnósticos y tratamientos
   - Datos vitales (peso, temperatura, frecuencia cardíaca)
   - Lista de citas (pasadas y futuras)"

**TEXTO:**
> "Este historial completo es esencial para que cualquier veterinario pueda atender al animal conociendo todo su historial previo."

### 4.5 Demostración 4: Consultas Avanzadas

**NARRAR:**
1. "Opción 4: Consultas avanzadas"
2. "Mostramos estadísticas de citas por veterinario"
3. "Top 5 de mascotas más atendidas"
4. "Distribución de mascotas por especie con edad promedio"

**TEXTO:**
> "Estas consultas utilizan JOINs múltiples, agregaciones y funciones analíticas. Son útiles para reportes gerenciales y análisis del negocio."

### 4.6 Opcional: Mostrar la Base de Datos

**SI HAY TIEMPO:**
> "Veamos rápidamente la base de datos por detrás:"

**ABRIR CLIENTE SQL Y MOSTRAR:**
```sql
-- Ver las tablas
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public';

-- Ver la mascota recién registrada
SELECT m.Nombre, e.Nombre_Especie, r.Nombre_Raza, c.Nombre
FROM MASCOTAS m
JOIN ESPECIES e ON m.ID_Especie = e.ID_Especie
JOIN RAZAS r ON m.ID_Raza = r.ID_Raza
JOIN CLIENTES c ON m.ID_Cliente = c.ID_Cliente
WHERE m.ID_Mascota = (SELECT MAX(ID_Mascota) FROM MASCOTAS);
```

**TEXTO:**
> "Aquí vemos cómo los datos quedan perfectamente relacionados en la base de datos, sin redundancia."

---

## 5️⃣ CONCLUSIONES (3 minutos)

### 5.1 Logros del Proyecto

> **[DIAPOSITIVA: Resumen de logros]**

**TEXTO:**
"Para concluir, hemos logrado:"

**ENUMERAR:**
1. ✅ **Diseño robusto**: Base de datos completamente normalizada (3FN)
2. ✅ **Implementación completa**: Scripts SQL funcionales con datos de prueba
3. ✅ **Aplicación práctica**: Software Java con arquitectura escalable
4. ✅ **Buenas prácticas**:
   - Patrón DAO para separación de capas
   - Validaciones en múltiples niveles
   - Manejo de excepciones
   - Código documentado y limpio
5. ✅ **Consultas avanzadas**: Reportes útiles para el negocio

### 5.2 Aprendizajes Clave

**TEXTO:**
"Los aprendizajes más importantes de este proyecto fueron:"

**COMPARTIR:**
- "La importancia de una buena fase de diseño antes de implementar"
- "Cómo la normalización previene problemas futuros"
- "La utilidad de los patrones de diseño para código mantenible"
- "El valor de las restricciones a nivel de base de datos"

### 5.3 Posibles Mejoras Futuras

> **[DIAPOSITIVA: Mejoras futuras]**

**TEXTO:**
"Como todo proyecto, hay espacio para mejoras:"

**SUGERIR:**
- 🔹 Interfaz gráfica (GUI) con JavaFX o Swing
- 🔹 Sistema de reportes en PDF
- 🔹 Módulo de facturación integrado
- 🔹 Dashboard web con estadísticas en tiempo real
- 🔹 Notificaciones automáticas por email/SMS
- 🔹 Sistema de respaldo automatizado
- 🔹 API REST para integración con otros sistemas

### 5.4 Aplicabilidad Real

**TEXTO:**
"Este sistema es completamente funcional y podría adaptarse a una clínica veterinaria real con ajustes menores. La estructura modular permite añadir nuevas funcionalidades sin afectar el código existente."

### 5.5 Cierre y Preguntas

**TEXTO:**
"Esto concluye mi presentación. Muchas gracias por su atención."

> **[PAUSA]**

"¿Tienen alguna pregunta?"

---

## 🎯 PREGUNTAS FRECUENTES (Preparación)

### ❓ "¿Por qué eligieron Java y PostgreSQL?"

**RESPUESTA:**
"Java por su robustez, portabilidad y amplio uso en sistemas empresariales. PostgreSQL por ser open-source, confiable, y tener excelente soporte para constraints e integridad referencial. Además, ambas tecnologías son ampliamente demandadas en el mercado laboral."

### ❓ "¿Cómo manejan la concurrencia en las citas?"

**RESPUESTA:**
"La aplicación verifica disponibilidad antes de insertar. A nivel de base de datos, tenemos constraints que previenen duplicados. Para un sistema de producción, implementaríamos transacciones con niveles de aislamiento adecuados y posiblemente locks optimistas."

### ❓ "¿Qué pasa si eliminan un cliente que tiene mascotas?"

**RESPUESTA:**
"Las claves foráneas tienen reglas de integridad referencial. En nuestro caso, usamos ON DELETE RESTRICT en la mayoría de relaciones críticas, por lo que la base de datos rechazaría la eliminación. Para casos específicos, podríamos usar ON DELETE CASCADE o implementar borrado lógico con un campo 'activo'."

### ❓ "¿Cómo gestionan la seguridad?"

**RESPUESTA:**
"En esta versión académica, las credenciales están en config.properties. Para producción, implementaríamos:
- Cifrado de conexiones (SSL/TLS)
- Variables de entorno para credenciales
- Autenticación de usuarios con roles
- Prepared statements (que ya usamos) para prevenir SQL injection
- Logs de auditoría"

### ❓ "¿El diseño escala a múltiples clínicas?"

**RESPUESTA:**
"Absolutamente. Bastaría con agregar una tabla CLINICAS y relacionarla con VETERINARIOS y SERVICIOS. El diseño modular hace que sea una extensión natural sin reestructurar lo existente."

### ❓ "¿Por qué no usaron un ORM como Hibernate?"

**RESPUESTA:**
"Para fines didácticos, preferimos implementar JDBC puro para entender completamente cómo funciona el acceso a datos. Los ORMs son excelentes para proyectos grandes, pero aquí queríamos dominar los fundamentos. El patrón DAO facilita migrar a un ORM en el futuro si fuera necesario."

### ❓ "¿Cómo probaron el sistema?"

**RESPUESTA:**
"Realizamos pruebas manuales exhaustivas con los datos de semilla. Verificamos:
- Inserción correcta de datos
- Funcionamiento de constraints
- Validación de disponibilidad de veterinarios
- Integridad referencial
- Consultas complejas con múltiples JOINs

Para un entorno de producción, implementaríamos pruebas unitarias con JUnit y pruebas de integración."

---

## 📊 TIPS PARA LA PRESENTACIÓN

### ✅ ANTES DE PRESENTAR

1. **Ensaya** el guión al menos 2-3 veces
2. **Verifica** que la base de datos tenga datos de prueba
3. **Prueba** todas las funcionalidades que vas a demostrar
4. **Prepara** las diapositivas con anticipación
5. **Ten listo** el código fuente por si preguntan por detalles
6. **Anota** tiempos parciales para no excederte

### ✅ DURANTE LA PRESENTACIÓN

1. **Habla claro** y a ritmo moderado
2. **Mira a la audiencia**, no solo a la pantalla
3. **Usa el mouse/puntero** para señalar elementos importantes
4. **Explica mientras haces** en la demo (no silencio)
5. **Si algo falla**, mantén la calma y ten un plan B
6. **Interactúa**: "¿Se ve bien en la pantalla?", "¿Alguna pregunta hasta aquí?"

### ✅ LENGUAJE CORPORAL

- Mantén contacto visual
- Gesticula para enfatizar puntos clave
- Mueve te por el espacio (no estés estático)
- Sonríe y muestra entusiasmo por tu proyecto

### ✅ MANEJO DEL TIEMPO

| Sección | Tiempo objetivo | Ajuste si te quedas corto | Ajuste si te excedes |
|---------|----------------|---------------------------|---------------------|
| Introducción | 2 min | Expande contexto | Salta objetivo tercer punto |
| Diseño BD | 5 min | Detalla MER | Resume normalización |
| Implementación | 4 min | Muestra más código | Solo arquitectura |
| Demostración | 5 min | Muestra más consultas | Solo 2 demos clave |
| Conclusiones | 3 min | Profundiza mejoras | Solo logros |

### ✅ PLAN B (Por si algo falla)

**Si la base de datos no conecta:**
- Muestra screenshots preparados de antemano
- Explica el código SQL directamente

**Si la aplicación da error:**
- Muestra el código y explica cómo funcionaría
- Usa la base de datos directamente para demostrar consultas

**Si se va el tiempo:**
- Prioriza la demostración sobre teoría
- Ten un resumen ejecutivo de 30 segundos listo

---

## 📁 ARCHIVOS DE REFERENCIA

### Durante la presentación, ten estos archivos abiertos en tabs:

1. `documentacion/db_sqls/veterinaria_db_design.md` - Normalización
2. `documentacion/db_sqls/veterinaria_mer.md` - Diagrama MER
3. `application/VeterinariaApp.java` - Código principal
4. `application/dao/MascotaDAO.java` - Ejemplo de DAO
5. `documentacion/db_sqls/veterinaria_queries.sql` - Consultas avanzadas

### Diapositivas sugeridas (orden):

1. Portada con título y tu nombre
2. Índice / Agenda
3. Contexto y problemática
4. Objetivos del proyecto
5. Tabla sin normalizar (0FN)
6. Primera Forma Normal (1FN)
7. Segunda Forma Normal (2FN)
8. Tercera Forma Normal (3FN)
9. Diagrama MER completo
10. Modelo relacional (tablas principales)
11. Estadísticas del diseño
12. Script SQL de ejemplo
13. Arquitectura de la aplicación (diagrama)
14. Componentes y capas
15. Menú de funcionalidades
16. [DEMO EN VIVO - sin diapositiva]
17. Logros del proyecto
18. Mejoras futuras
19. Cierre y gracias
20. ¿Preguntas?

---

## 🎬 FRASE DE APERTURA

> "Buenos días/tardes. El sistema que voy a presentar hoy resuelve un problema real: cómo gestionar eficientemente la información de una clínica veterinaria, desde los clientes y sus mascotas hasta el historial médico completo, de manera organizada, sin redundancia y garantizando la integridad de los datos. Este proyecto integra teoría y práctica de bases de datos relacionales con desarrollo de software."

## 🎬 FRASE DE CIERRE

> "En conclusión, hemos diseñado e implementado un sistema completo y funcional que demuestra la aplicación práctica de los conceptos de bases de datos relacionales y arquitectura de software. El sistema es escalable, mantenible y podría adaptarse a un entorno de producción real. Gracias por su atención. ¿Preguntas?"

---

## ✨ ¡ÉXITO EN TU PRESENTACIÓN!

Recuerda: **Conoces tu proyecto mejor que nadie. Confía en tu trabajo.**
