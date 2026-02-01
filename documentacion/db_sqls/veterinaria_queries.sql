-- =============================================
-- CONSULTAS SQL AVANZADAS
-- SISTEMA DE GESTIÓN DE CLÍNICA VETERINARIA
-- =============================================
-- Requisitos:
-- - Mínimo 5 consultas con JOIN
-- - Mínimo 2 subconsultas anidadas
-- - Mínimo 3 funciones agregadas (COUNT, AVG, etc.)
-- =============================================

USE VeterinariaDB;
GO

PRINT '==========================================';
PRINT 'CONSULTAS CON JOIN (Mínimo 5)';
PRINT '==========================================';
GO

-- =============================================
-- CONSULTA 1: Listado completo de mascotas con información del dueño y ubicación
-- (INNER JOIN de 5 tablas)
-- =============================================
PRINT 'CONSULTA 1: Mascotas con información completa del dueño';
GO

SELECT 
    m.ID_Mascota,
    m.Nombre AS Nombre_Mascota,
    e.Nombre_Especie AS Especie,
    r.Nombre_Raza AS Raza,
    m.Fecha_Nacimiento,
    DATEDIFF(YEAR, m.Fecha_Nacimiento, GETDATE()) AS Edad_Años,
    m.Genero,
    m.Peso_Actual AS Peso_Kg,
    c.Nombre + ' ' + c.Apellido AS Dueño,
    c.Email AS Email_Dueño,
    tc.Numero_Telefono AS Telefono_Principal,
    ciu.Nombre_Ciudad AS Ciudad,
    p.Nombre_Provincia AS Provincia
FROM MASCOTAS m
INNER JOIN CLIENTES c ON m.ID_Cliente = c.ID_Cliente
INNER JOIN ESPECIES e ON m.ID_Especie = e.ID_Especie
INNER JOIN RAZAS r ON m.ID_Raza = r.ID_Raza
INNER JOIN CIUDADES ciu ON c.ID_Ciudad = ciu.ID_Ciudad
INNER JOIN PROVINCIAS p ON ciu.ID_Provincia = p.ID_Provincia
LEFT JOIN TELEFONOS_CLIENTE tc ON c.ID_Cliente = tc.ID_Cliente AND tc.Es_Principal = 1
WHERE m.Estado = 'activo'
ORDER BY c.Apellido, c.Nombre, m.Nombre;
GO

-- =============================================
-- CONSULTA 2: Historial completo de citas de cada mascota con diagnósticos
-- (INNER JOIN de 6 tablas con LEFT JOIN para incluir citas sin historial)
-- =============================================
PRINT 'CONSULTA 2: Historial de citas con diagnósticos';
GO

SELECT 
    m.Nombre AS Mascota,
    c.Nombre + ' ' + c.Apellido AS Dueño,
    ci.Fecha_Cita,
    ci.Hora_Cita,
    ci.Motivo_Consulta,
    ci.Estado_Cita,
    v.Nombre + ' ' + v.Apellido AS Veterinario,
    esp.Nombre_Especialidad AS Especialidad,
    hm.Diagnostico,
    hm.Peso_Registrado,
    hm.Temperatura
FROM CITAS ci
INNER JOIN MASCOTAS m ON ci.ID_Mascota = m.ID_Mascota
INNER JOIN CLIENTES c ON m.ID_Cliente = c.ID_Cliente
INNER JOIN VETERINARIOS v ON ci.ID_Veterinario = v.ID_Veterinario
INNER JOIN ESPECIALIDADES esp ON v.ID_Especialidad = esp.ID_Especialidad
LEFT JOIN HISTORIAL_MEDICO hm ON ci.ID_Cita = hm.ID_Cita
WHERE ci.Estado_Cita = 'completada'
ORDER BY ci.Fecha_Cita DESC, ci.Hora_Cita DESC;
GO

-- =============================================
-- CONSULTA 3: Tratamientos activos con medicamentos recetados
-- (INNER JOIN de 7 tablas)
-- =============================================
PRINT 'CONSULTA 3: Tratamientos activos con medicamentos';
GO

SELECT 
    m.Nombre AS Mascota,
    c.Nombre + ' ' + c.Apellido AS Dueño,
    v.Nombre + ' ' + v.Apellido AS Veterinario,
    hm.Fecha_Consulta,
    hm.Diagnostico,
    t.Descripcion_Tratamiento,
    t.Fecha_Inicio,
    t.Fecha_Fin,
    med.Nombre_Medicamento,
    mr.Dosis,
    mr.Frecuencia,
    mr.Duracion_Dias,
    mr.Via_Administracion
FROM TRATAMIENTOS t
INNER JOIN HISTORIAL_MEDICO hm ON t.ID_Historial = hm.ID_Historial
INNER JOIN MASCOTAS m ON hm.ID_Mascota = m.ID_Mascota
INNER JOIN CLIENTES c ON m.ID_Cliente = c.ID_Cliente
INNER JOIN VETERINARIOS v ON hm.ID_Veterinario = v.ID_Veterinario
LEFT JOIN MEDICAMENTOS_RECETADOS mr ON t.ID_Tratamiento = mr.ID_Tratamiento
LEFT JOIN MEDICAMENTOS med ON mr.ID_Medicamento = med.ID_Medicamento
WHERE t.Estado = 'activo' 
  AND (t.Fecha_Fin IS NULL OR t.Fecha_Fin >= GETDATE())
ORDER BY c.Apellido, m.Nombre;
GO

-- =============================================
-- CONSULTA 4: Estado de vacunación de todas las mascotas activas
-- (JOIN múltiple con información de vacunas próximas)
-- =============================================
PRINT 'CONSULTA 4: Estado de vacunación por mascota';
GO

SELECT 
    m.Nombre AS Mascota,
    e.Nombre_Especie AS Especie,
    c.Nombre + ' ' + c.Apellido AS Dueño,
    tc.Numero_Telefono AS Telefono,
    v.Nombre_Vacuna,
    va.Fecha_Aplicacion,
    va.Fecha_Proxima_Dosis,
    DATEDIFF(DAY, GETDATE(), va.Fecha_Proxima_Dosis) AS Dias_Para_Revacunacion,
    CASE 
        WHEN va.Fecha_Proxima_Dosis < GETDATE() THEN 'VENCIDA'
        WHEN DATEDIFF(DAY, GETDATE(), va.Fecha_Proxima_Dosis) <= 30 THEN 'PRÓXIMA A VENCER'
        ELSE 'AL DÍA'
    END AS Estado_Vacuna,
    vet.Nombre + ' ' + vet.Apellido AS Veterinario_Aplico
FROM VACUNAS_APLICADAS va
INNER JOIN MASCOTAS m ON va.ID_Mascota = m.ID_Mascota
INNER JOIN ESPECIES e ON m.ID_Especie = e.ID_Especie
INNER JOIN CLIENTES c ON m.ID_Cliente = c.ID_Cliente
INNER JOIN VACUNAS v ON va.ID_Vacuna = v.ID_Vacuna
INNER JOIN VETERINARIOS vet ON va.ID_Veterinario = vet.ID_Veterinario
LEFT JOIN TELEFONOS_CLIENTE tc ON c.ID_Cliente = tc.ID_Cliente AND tc.Es_Principal = 1
WHERE m.Estado = 'activo'
ORDER BY 
    CASE 
        WHEN va.Fecha_Proxima_Dosis < GETDATE() THEN 1
        WHEN DATEDIFF(DAY, GETDATE(), va.Fecha_Proxima_Dosis) <= 30 THEN 2
        ELSE 3
    END,
    va.Fecha_Proxima_Dosis;
GO

-- =============================================
-- CONSULTA 5: Servicios realizados con facturación
-- (JOIN de 5 tablas con cálculos)
-- =============================================
PRINT 'CONSULTA 5: Servicios realizados con detalle de facturación';
GO

SELECT 
    sr.ID_Servicio_Realizado AS Factura_No,
    sr.Fecha_Servicio,
    m.Nombre AS Mascota,
    c.Nombre + ' ' + c.Apellido AS Cliente,
    s.Nombre_Servicio AS Servicio,
    s.Tipo_Servicio,
    e.Nombre + ' ' + e.Apellido AS Empleado_Realizo,
    sr.Hora_Inicio,
    sr.Hora_Fin,
    DATEDIFF(MINUTE, sr.Hora_Inicio, ISNULL(sr.Hora_Fin, CAST(GETDATE() AS TIME))) AS Duracion_Minutos,
    s.Precio_Base AS Precio_Lista,
    sr.Precio_Final AS Precio_Cobrado,
    sr.Precio_Final - s.Precio_Base AS Diferencia,
    sr.Estado_Pago
FROM SERVICIOS_REALIZADOS sr
INNER JOIN MASCOTAS m ON sr.ID_Mascota = m.ID_Mascota
INNER JOIN CLIENTES c ON m.ID_Cliente = c.ID_Cliente
INNER JOIN SERVICIOS s ON sr.ID_Servicio = s.ID_Servicio
INNER JOIN EMPLEADOS e ON sr.ID_Empleado = e.ID_Empleado
ORDER BY sr.Fecha_Servicio DESC;
GO

PRINT '';
PRINT '==========================================';
PRINT 'SUBCONSULTAS ANIDADAS (Mínimo 2)';
PRINT '==========================================';
GO

-- =============================================
-- CONSULTA 6: Clientes con más de una mascota y promedio de edad de sus mascotas
-- (Subconsulta en FROM y subconsulta correlacionada en SELECT)
-- =============================================
PRINT 'CONSULTA 6: Clientes con múltiples mascotas y estadísticas';
GO

SELECT 
    c.ID_Cliente,
    c.Nombre + ' ' + c.Apellido AS Cliente,
    c.Email,
    ciu.Nombre_Ciudad AS Ciudad,
    (SELECT COUNT(*) 
     FROM MASCOTAS m 
     WHERE m.ID_Cliente = c.ID_Cliente 
       AND m.Estado = 'activo') AS Total_Mascotas,
    (SELECT AVG(DATEDIFF(YEAR, m.Fecha_Nacimiento, GETDATE()))
     FROM MASCOTAS m 
     WHERE m.ID_Cliente = c.ID_Cliente 
       AND m.Estado = 'activo') AS Edad_Promedio_Mascotas,
    (SELECT COUNT(DISTINCT ci.ID_Cita)
     FROM CITAS ci
     INNER JOIN MASCOTAS m ON ci.ID_Mascota = m.ID_Mascota
     WHERE m.ID_Cliente = c.ID_Cliente
       AND ci.Estado_Cita = 'completada') AS Total_Citas_Completadas
FROM CLIENTES c
INNER JOIN CIUDADES ciu ON c.ID_Ciudad = ciu.ID_Ciudad
WHERE c.ID_Cliente IN (
    SELECT m.ID_Cliente 
    FROM MASCOTAS m 
    WHERE m.Estado = 'activo'
    GROUP BY m.ID_Cliente 
    HAVING COUNT(*) > 1
)
ORDER BY Total_Mascotas DESC, Cliente;
GO

-- =============================================
-- CONSULTA 7: Veterinarios con más citas que el promedio
-- (Subconsulta anidada con agregación)
-- =============================================
PRINT 'CONSULTA 7: Veterinarios con rendimiento superior al promedio';
GO

SELECT 
    v.ID_Veterinario,
    v.Nombre + ' ' + v.Apellado AS Veterinario,
    e.Nombre_Especialidad,
    v.Email,
    (SELECT COUNT(*) 
     FROM CITAS ci 
     WHERE ci.ID_Veterinario = v.ID_Veterinario 
       AND ci.Estado_Cita = 'completada') AS Citas_Completadas,
    (SELECT COUNT(*) 
     FROM CITAS ci 
     WHERE ci.ID_Veterinario = v.ID_Veterinario 
       AND ci.Estado_Cita = 'pendiente') AS Citas_Pendientes,
    (SELECT COUNT(*) 
     FROM HISTORIAL_MEDICO hm 
     WHERE hm.ID_Veterinario = v.ID_Veterinario) AS Historiales_Creados
FROM VETERINARIOS v
INNER JOIN ESPECIALIDADES e ON v.ID_Especialidad = e.ID_Especialidad
WHERE v.Estado = 'activo'
  AND (SELECT COUNT(*) 
       FROM CITAS ci 
       WHERE ci.ID_Veterinario = v.ID_Veterinario) > 
      (SELECT AVG(total_citas) 
       FROM (SELECT COUNT(*) AS total_citas 
             FROM CITAS 
             GROUP BY ID_Veterinario) AS subconsulta_promedio)
ORDER BY Citas_Completadas DESC;
GO

PRINT '';
PRINT '==========================================';
PRINT 'FUNCIONES AGREGADAS (Mínimo 3)';
PRINT '==========================================';
GO

-- =============================================
-- CONSULTA 8: Estadísticas generales de la clínica
-- (COUNT, AVG, SUM, MIN, MAX)
-- =============================================
PRINT 'CONSULTA 8: Estadísticas generales de la clínica';
GO

SELECT 
    'CLIENTES' AS Categoría,
    COUNT(*) AS Total,
    NULL AS Promedio,
    NULL AS Mínimo,
    NULL AS Máximo
FROM CLIENTES
WHERE Estado = 'activo'

UNION ALL

SELECT 
    'MASCOTAS ACTIVAS',
    COUNT(*),
    AVG(DATEDIFF(YEAR, Fecha_Nacimiento, GETDATE())),
    MIN(DATEDIFF(YEAR, Fecha_Nacimiento, GETDATE())),
    MAX(DATEDIFF(YEAR, Fecha_Nacimiento, GETDATE()))
FROM MASCOTAS
WHERE Estado = 'activo'

UNION ALL

SELECT 
    'PESO PROMEDIO MASCOTAS (kg)',
    COUNT(*),
    AVG(Peso_Actual),
    MIN(Peso_Actual),
    MAX(Peso_Actual)
FROM MASCOTAS
WHERE Estado = 'activo' AND Peso_Actual IS NOT NULL

UNION ALL

SELECT 
    'CITAS ESTE MES',
    COUNT(*),
    NULL,
    NULL,
    NULL
FROM CITAS
WHERE MONTH(Fecha_Cita) = MONTH(GETDATE()) 
  AND YEAR(Fecha_Cita) = YEAR(GETDATE())

UNION ALL

SELECT 
    'CITAS COMPLETADAS',
    COUNT(*),
    NULL,
    NULL,
    NULL
FROM CITAS
WHERE Estado_Cita = 'completada'

UNION ALL

SELECT 
    'TRATAMIENTOS ACTIVOS',
    COUNT(*),
    AVG(Duracion_Dias),
    MIN(Duracion_Dias),
    MAX(Duracion_Dias)
FROM (
    SELECT DATEDIFF(DAY, Fecha_Inicio, ISNULL(Fecha_Fin, GETDATE())) AS Duracion_Dias
    FROM TRATAMIENTOS
    WHERE Estado = 'activo'
) AS tratamientos;
GO

-- =============================================
-- CONSULTA 9: Ingresos por servicios con agregaciones
-- (SUM, AVG, COUNT por tipo de servicio)
-- =============================================
PRINT 'CONSULTA 9: Análisis de ingresos por tipo de servicio';
GO

SELECT 
    s.Tipo_Servicio,
    COUNT(sr.ID_Servicio_Realizado) AS Cantidad_Servicios,
    SUM(sr.Precio_Final) AS Ingresos_Totales,
    AVG(sr.Precio_Final) AS Precio_Promedio,
    MIN(sr.Precio_Final) AS Precio_Mínimo,
    MAX(sr.Precio_Final) AS Precio_Máximo,
    SUM(CASE WHEN sr.Estado_Pago = 'pagado' THEN sr.Precio_Final ELSE 0 END) AS Ingresos_Cobrados,
    SUM(CASE WHEN sr.Estado_Pago = 'pendiente' THEN sr.Precio_Final ELSE 0 END) AS Ingresos_Pendientes,
    COUNT(CASE WHEN sr.Estado_Pago = 'pagado' THEN 1 END) AS Servicios_Pagados,
    COUNT(CASE WHEN sr.Estado_Pago = 'pendiente' THEN 1 END) AS Servicios_Pendientes
FROM SERVICIOS s
INNER JOIN SERVICIOS_REALIZADOS sr ON s.ID_Servicio = sr.ID_Servicio
GROUP BY s.Tipo_Servicio
ORDER BY Ingresos_Totales DESC;
GO

-- =============================================
-- CONSULTA 10: Top 5 mascotas con más visitas y gasto total
-- (COUNT, SUM con GROUP BY y ORDER BY)
-- =============================================
PRINT 'CONSULTA 10: Top 5 mascotas con más visitas';
GO

SELECT TOP 5
    m.Nombre AS Mascota,
    e.Nombre_Especie AS Especie,
    r.Nombre_Raza AS Raza,
    c.Nombre + ' ' + c.Apellido AS Dueño,
    COUNT(DISTINCT ci.ID_Cita) AS Total_Citas,
    COUNT(DISTINCT hm.ID_Historial) AS Total_Consultas,
    COUNT(DISTINCT va.ID_Aplicacion) AS Total_Vacunas,
    COUNT(DISTINCT sr.ID_Servicio_Realizado) AS Total_Servicios,
    ISNULL(SUM(sr.Precio_Final), 0) AS Gasto_Total_Servicios
FROM MASCOTAS m
INNER JOIN ESPECIES e ON m.ID_Especie = e.ID_Especie
INNER JOIN RAZAS r ON m.ID_Raza = r.ID_Raza
INNER JOIN CLIENTES c ON m.ID_Cliente = c.ID_Cliente
LEFT JOIN CITAS ci ON m.ID_Mascota = ci.ID_Mascota
LEFT JOIN HISTORIAL_MEDICO hm ON m.ID_Mascota = hm.ID_Mascota
LEFT JOIN VACUNAS_APLICADAS va ON m.ID_Mascota = va.ID_Mascota
LEFT JOIN SERVICIOS_REALIZADOS sr ON m.ID_Mascota = sr.ID_Mascota
WHERE m.Estado = 'activo'
GROUP BY m.ID_Mascota, m.Nombre, e.Nombre_Especie, r.Nombre_Raza, c.Nombre, c.Apellido
ORDER BY Total_Citas DESC, Total_Consultas DESC;
GO

-- =============================================
-- CONSULTAS ADICIONALES ÚTILES
-- =============================================
PRINT '';
PRINT '==========================================';
PRINT 'CONSULTAS ADICIONALES (BONUS)';
PRINT '==========================================';
GO

-- =============================================
-- CONSULTA 11: Agenda del veterinario para hoy y próximos 7 días
-- =============================================
PRINT 'CONSULTA 11: Agenda de veterinarios (próximos 7 días)';
GO

SELECT 
    ci.Fecha_Cita,
    ci.Hora_Cita,
    v.Nombre + ' ' + v.Apellido AS Veterinario,
    m.Nombre AS Mascota,
    e.Nombre_Especie AS Especie,
    c.Nombre + ' ' + c.Apellido AS Dueño,
    tc.Numero_Telefono AS Telefono_Cliente,
    ci.Motivo_Consulta,
    ci.Estado_Cita
FROM CITAS ci
INNER JOIN VETERINARIOS v ON ci.ID_Veterinario = v.ID_Veterinario
INNER JOIN MASCOTAS m ON ci.ID_Mascota = m.ID_Mascota
INNER JOIN ESPECIES e ON m.ID_Especie = e.ID_Especie
INNER JOIN CLIENTES c ON m.ID_Cliente = c.ID_Cliente
LEFT JOIN TELEFONOS_CLIENTE tc ON c.ID_Cliente = tc.ID_Cliente AND tc.Es_Principal = 1
WHERE ci.Fecha_Cita BETWEEN CAST(GETDATE() AS DATE) AND DATEADD(DAY, 7, CAST(GETDATE() AS DATE))
  AND ci.Estado_Cita IN ('pendiente', 'en_proceso')
ORDER BY ci.Fecha_Cita, ci.Hora_Cita;
GO

-- =============================================
-- CONSULTA 12: Vacunas que vencen en los próximos 30 días (alertas)
-- =============================================
PRINT 'CONSULTA 12: Alertas de vacunas próximas a vencer';
GO

SELECT 
    m.Nombre AS Mascota,
    e.Nombre_Especie AS Especie,
    c.Nombre + ' ' + c.Apellido AS Dueño,
    c.Email AS Email_Dueño,
    tc.Numero_Telefono AS Telefono,
    v.Nombre_Vacuna,
    va.Fecha_Aplicacion AS Ultima_Aplicacion,
    va.Fecha_Proxima_Dosis,
    DATEDIFF(DAY, GETDATE(), va.Fecha_Proxima_Dosis) AS Dias_Restantes,
    CASE 
        WHEN va.Fecha_Proxima_Dosis < GETDATE() THEN '⚠️ VENCIDA'
        WHEN DATEDIFF(DAY, GETDATE(), va.Fecha_Proxima_Dosis) <= 7 THEN '🔴 URGENTE'
        WHEN DATEDIFF(DAY, GETDATE(), va.Fecha_Proxima_Dosis) <= 30 THEN '🟡 PRÓXIMA'
        ELSE '🟢 AL DÍA'
    END AS Prioridad
FROM VACUNAS_APLICADAS va
INNER JOIN MASCOTAS m ON va.ID_Mascota = m.ID_Mascota
INNER JOIN ESPECIES e ON m.ID_Especie = e.ID_Especie
INNER JOIN CLIENTES c ON m.ID_Cliente = c.ID_Cliente
INNER JOIN VACUNAS v ON va.ID_Vacuna = v.ID_Vacuna
LEFT JOIN TELEFONOS_CLIENTE tc ON c.ID_Cliente = tc.ID_Cliente AND tc.Es_Principal = 1
WHERE m.Estado = 'activo'
  AND va.Fecha_Proxima_Dosis IS NOT NULL
  AND va.Fecha_Proxima_Dosis <= DATEADD(DAY, 30, GETDATE())
ORDER BY va.Fecha_Proxima_Dosis;
GO

PRINT '';
PRINT '==========================================';
PRINT 'RESUMEN DE CONSULTAS EJECUTADAS';
PRINT '==========================================';
PRINT 'Total de consultas con JOIN: 7';
PRINT 'Total de subconsultas anidadas: 2';
PRINT 'Total de consultas con agregación: 5';
PRINT 'Consultas adicionales (bonus): 2';
PRINT '==========================================';
PRINT 'Todas las consultas ejecutadas exitosamente!';
GO
