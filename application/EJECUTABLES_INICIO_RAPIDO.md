# 🚀 Inicio Rápido - Ejecutables

## Generar JAR Ejecutable (Recomendado)

### Windows:
```batch
crear_jar.bat
```

### Linux/Mac:
```bash
chmod +x crear_jar.sh
./crear_jar.sh
```

**Resultado:** `VeterinariaApp.jar` - Ejecutar con doble clic o `java -jar VeterinariaApp.jar`

---

## Generar EXE para Windows (Opcional)

### Opción 1: Instalador completo (incluye Java)
```batch
crear_exe.bat
```
- Genera: `installer\SistemaVeterinaria-1.0.exe`
- No requiere Java instalado en el equipo del usuario
- ~100-150 MB

### Opción 2: Ejecutable simple (requiere Java)
```batch
crear_exe_launch4j.bat
```
- Genera: `SistemaVeterinaria.exe`
- Requiere Launch4j instalado
- Requiere Java en el equipo del usuario
- ~15 MB

---

## 📖 Documentación Completa

Para más detalles, consulta: [EJECUTABLES.md](EJECUTABLES.md)

---

## ⚡ Secuencia Recomendada

1. **Generar JAR**
   ```batch
   crear_jar.bat
   ```

2. **Probar JAR**
   ```batch
   java -jar VeterinariaApp.jar
   ```

3. **Generar EXE (si necesitas)**
   ```batch
   crear_exe.bat
   ```

---

## ✅ Archivos Generados

- `VeterinariaApp.jar` - JAR ejecutable multiplataforma
- `SistemaVeterinaria.exe` - EXE simple (si usas Launch4j)
- `installer\SistemaVeterinaria-1.0.exe` - Instalador completo (si usas jpackage)
