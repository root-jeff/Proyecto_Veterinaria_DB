# 📦 Generación de Ejecutables - Sistema Veterinaria

Este documento explica cómo crear ejecutables únicos para la aplicación del Sistema Veterinaria.

## 🎯 Opciones Disponibles

### 1. JAR Ejecutable (Recomendado)
**Archivo único:** `VeterinariaApp.jar`
- ✅ Multiplataforma (Windows, Linux, Mac)
- ✅ Fácil de generar
- ✅ Incluye todas las dependencias
- ⚠️ Requiere Java instalado en el equipo

### 2. EXE con jpackage (Windows - Instalador completo)
**Archivo generado:** `SistemaVeterinaria-1.0.exe`
- ✅ No requiere Java instalado (incluye JRE)
- ✅ Crea instalador profesional
- ✅ Accesos directos automáticos
- ⚠️ Archivo más grande (~100MB)
- ⚠️ Requiere JDK 14+ para generarlo

### 3. EXE con Launch4j (Windows - Ejecutable simple)
**Archivo generado:** `SistemaVeterinaria.exe`
- ✅ Archivo pequeño
- ✅ Doble clic para ejecutar
- ⚠️ Requiere Java instalado en el equipo
- ⚠️ Requiere Launch4j para generarlo

---

## 🚀 Cómo Generar los Ejecutables

### Paso 1: Generar JAR Ejecutable

#### En Windows:
```batch
crear_jar.bat
```

#### En Linux/Mac:
```bash
chmod +x crear_jar.sh
./crear_jar.sh
```

**Resultado:** Se creará `VeterinariaApp.jar` en el directorio actual.

**Para ejecutar:**
- Doble clic en `VeterinariaApp.jar`
- O desde consola: `java -jar VeterinariaApp.jar`

---

### Paso 2A: Generar EXE con jpackage (Instalador Completo)

**Requisitos:**
- JDK 14 o superior
- Haber generado el JAR primero

**Ejecutar:**
```batch
crear_exe.bat
```

**Resultado:**
- Se crea `installer\SistemaVeterinaria-1.0.exe`
- Este es un instalador que:
  - Instala la aplicación en Archivos de Programa
  - Crea accesos directos en el Menú Inicio y Escritorio
  - Incluye un JRE completo (no necesita Java instalado)
  - El usuario puede desinstalar desde Panel de Control

**Distribución:**
- Comparte el archivo `SistemaVeterinaria-1.0.exe` (~100-150MB)
- El usuario solo ejecuta el instalador y sigue los pasos
- No necesita tener Java instalado

---

### Paso 2B: Generar EXE con Launch4j (Ejecutable Simple)

**Requisitos:**
- Launch4j instalado (https://launch4j.sourceforge.net/)
- Haber generado el JAR primero

**Instalación de Launch4j:**
1. Descargar desde: https://launch4j.sourceforge.net/
2. Instalar (por defecto en `C:\Program Files\Launch4j`)

**Ejecutar:**
```batch
crear_exe_launch4j.bat
```

**Resultado:**
- Se crea `SistemaVeterinaria.exe` (~15MB)
- Es un ejecutable simple que envuelve el JAR
- Requiere que el usuario tenga Java 11+ instalado

**Distribución:**
- Comparte el archivo `SistemaVeterinaria.exe`
- El usuario solo hace doble clic
- ⚠️ Asegúrate de que tengan Java instalado

---

## 📋 Comparación de Métodos

| Característica | JAR | EXE (jpackage) | EXE (Launch4j) |
|----------------|-----|----------------|----------------|
| Tamaño archivo | ~15 MB | ~100-150 MB | ~15 MB |
| Requiere Java | ✅ Sí (11+) | ❌ No | ✅ Sí (11+) |
| Multiplataforma | ✅ Sí | ❌ Solo Windows | ❌ Solo Windows |
| Instalador | ❌ No | ✅ Sí | ❌ No |
| Facilidad generación | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| Profesionalidad | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

---

## 🎓 Recomendaciones

### Para desarrollo y pruebas:
✅ Usa el **JAR ejecutable** - rápido y fácil

### Para distribución a usuarios finales:

#### Si los usuarios NO tienen Java:
✅ Usa **EXE con jpackage** - incluye todo lo necesario

#### Si los usuarios tienen Java:
✅ Usa **JAR ejecutable** o **EXE con Launch4j** - más ligero

#### Para máxima compatibilidad:
✅ Distribuye tanto el **JAR** como el **EXE con jpackage**
- Los usuarios con Java pueden usar el JAR
- Los usuarios sin Java pueden usar el EXE

---

## 🔧 Solución de Problemas

### El JAR no se ejecuta con doble clic
**Causa:** Java no está asociado a archivos .jar
**Solución:**
```batch
java -jar VeterinariaApp.jar
```

### Error: "jpackage no encontrado"
**Causa:** JDK antiguo (menor a 14)
**Solución:**
- Actualiza a JDK 14 o superior
- O usa Launch4j en su lugar

### Error: "Launch4j no encontrado"
**Causa:** Launch4j no instalado
**Solución:**
1. Descargar desde https://launch4j.sourceforge.net/
2. Instalar en la ruta por defecto
3. O editar `crear_exe_launch4j.bat` con la ruta correcta

### El EXE dice "Java not found"
**Causa:** (Para Launch4j) Java no instalado en el equipo del usuario
**Solución:**
- Instalar Java 11+ desde https://www.java.com/
- O usar el método jpackage que incluye JRE

### Error de conexión a base de datos
**Causa:** `config.properties` no está correctamente configurado
**Solución:**
1. Editar `config.properties` con los datos correctos:
   ```properties
   db.host=localhost
   db.port=5432
   db.name=veterinaria_db
   db.user=tu_usuario
   db.password=tu_password
   ```
2. Regenerar el JAR/EXE

---

## 📝 Flujo de Trabajo Completo

### Desarrollo → Distribución

1. **Desarrollar y probar**
   ```batch
   compilar.bat
   ejecutar.bat
   ```

2. **Generar JAR para pruebas**
   ```batch
   crear_jar.bat
   ```

3. **Probar el JAR**
   ```batch
   java -jar VeterinariaApp.jar
   ```

4. **Generar EXE para distribución** (elegir uno)
   ```batch
   crear_exe.bat              REM Instalador completo
   crear_exe_launch4j.bat     REM Ejecutable simple
   ```

5. **Distribuir**
   - Compartir el archivo generado
   - Incluir instrucciones si es necesario

---

## 📦 Archivos Generados

Después de ejecutar los scripts, tendrás:

```
application/
├── VeterinariaApp.jar          ← JAR ejecutable (siempre generado primero)
├── SistemaVeterinaria.exe      ← EXE con Launch4j (opcional)
└── installer/
    └── SistemaVeterinaria-1.0.exe  ← Instalador completo (opcional)
```

---

## ✅ Checklist Pre-Distribución

Antes de distribuir tu aplicación, verifica:

- [ ] El JAR se ejecuta correctamente
- [ ] `config.properties` tiene valores por defecto razonables
- [ ] La base de datos PostgreSQL está accesible
- [ ] Has probado en una máquina limpia (sin desarrollo)
- [ ] Has incluido instrucciones para el usuario final
- [ ] Has documentado los requisitos (Java, PostgreSQL)

---

## 📚 Recursos Adicionales

- **Java JDK:** https://www.oracle.com/java/technologies/downloads/
- **Launch4j:** https://launch4j.sourceforge.net/
- **jpackage docs:** https://docs.oracle.com/en/java/javase/14/jpackage/

---

## 🆘 Soporte

Si encuentras problemas:
1. Revisa la sección "Solución de Problemas" arriba
2. Verifica que todos los requisitos estén instalados
3. Revisa los errores en consola para más detalles
