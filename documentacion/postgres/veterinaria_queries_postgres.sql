-- =============================================
-- CONSULTAS SQL AVANZADAS
-- SISTEMA DE GESTIÓN DE CLÍNICA VETERINARIA
-- Motor: PostgreSQL 12+
-- Migrado desde SQL Server
-- =============================================
-- Requisitos:
-- - Mínimo 5 consultas con JOIN
-- - Mínimo 2 subconsultas anidadas
-- - Mínimo 3 funciones agregadas (COUNT, AVG, etc.)
-- =============================================

-- Conectar a la base de datos
\c veterinariadb;

\echo '=========================================='
\echo 'CONSULTAS CON JOIN (Mínimo 5)'
\echo '=========================================='

-- =============================================
-- CONSULTA 1: Listado completo de mascotas con información del dueño y ubicación
-- (INNER JOIN de 5 tablas)
-- =============================================
\echo 'CONSULTA 1: Mascotas con información completa del dueño'

SELECT 
    m.id_mascota,
    m.nombre AS nombre_mascota,
    e.nombre_especie AS especie,
    r.nombre_raza AS raza,
    m.fecha_nacimiento,
    EXTRACT(YEAR FROM AGE(m.fecha_nacimiento)) AS edad_años,
    m.genero,
    m.peso_actual AS peso_kg,
    c.nombre || ' ' || c.apellido AS dueño,
    c.email AS email_dueño,
    tc.numero_telefono AS telefono_principal,
    ciu.nombre_ciudad AS ciudad,
    p.nombre_provincia AS provincia
FROM mascotas m
INNER JOIN clientes c ON m.id_cliente = c.id_cliente
INNER JOIN especies e ON m.id_especie = e.id_especie
INNER JOIN razas r ON m.id_raza = r.id_raza
INNER JOIN ciudades ciu ON c.id_ciudad = ciu.id_ciudad
INNER JOIN provincias p ON ciu.id_provincia = p.id_provincia
LEFT JOIN telefonos_cliente tc ON c.id_cliente = tc.id_cliente AND tc.es_principal = TRUE
WHERE m.estado = 'activo'
ORDER BY c.apellido, c.nombre, m.nombre;

-- =============================================
-- CONSULTA 2: Historial completo de citas de cada mascota con diagnósticos
-- (INNER JOIN de 6 tablas con LEFT JOIN para incluir citas sin historial)
-- =============================================
\echo 'CONSULTA 2: Historial de citas con diagnósticos'

SELECT 
    m.nombre AS mascota,
    c.nombre || ' ' || c.apellido AS dueño,
    ci.fecha_cita,
    ci.hora_cita,
    ci.motivo_consulta,
    ci.estado_cita,
    v.nombre || ' ' || v.apellido AS veterinario,
    esp.nombre_especialidad AS especialidad,
    hm.diagnostico,
    hm.peso_registrado,
    hm.temperatura
FROM citas ci
INNER JOIN mascotas m ON ci.id_mascota = m.id_mascota
INNER JOIN clientes c ON m.id_cliente = c.id_cliente
INNER JOIN veterinarios v ON ci.id_veterinario = v.id_veterinario
INNER JOIN especialidades esp ON v.id_especialidad = esp.id_especialidad
LEFT JOIN historial_medico hm ON ci.id_cita = hm.id_cita
WHERE ci.estado_cita = 'completada'
ORDER BY ci.fecha_cita DESC, ci.hora_cita DESC;

-- =============================================
-- CONSULTA 3: Tratamientos activos con medicamentos recetados
-- (INNER JOIN de 7 tablas)
-- =============================================
\echo 'CONSULTA 3: Tratamientos activos con medicamentos'

SELECT 
    m.nombre AS mascota,
    c.nombre || ' ' || c.apellido AS dueño,
    v.nombre || ' ' || v.apellido AS veterinario,
    hm.fecha_consulta,
    hm.diagnostico,
    t.descripcion_tratamiento,
    t.fecha_inicio,
    t.fecha_fin,
    med.nombre_medicamento,
    mr.dosis,
    mr.frecuencia,
    mr.duracion_dias,
    mr.via_administracion
FROM tratamientos t
INNER JOIN historial_medico hm ON t.id_historial = hm.id_historial
INNER JOIN mascotas m ON hm.id_mascota = m.id_mascota
INNER JOIN clientes c ON m.id_cliente = c.id_cliente
INNER JOIN veterinarios v ON hm.id_veterinario = v.id_veterinario
LEFT JOIN medicamentos_recetados mr ON t.id_tratamiento = mr.id_tratamiento
LEFT JOIN medicamentos med ON mr.id_medicamento = med.id_medicamento
WHERE t.estado = 'activo' 
  AND (t.fecha_fin IS NULL OR t.fecha_fin >= CURRENT_DATE)
ORDER BY c.apellido, m.nombre;

-- =============================================
-- CONSULTA 4: Estado de vacunación de todas las mascotas activas
-- (JOIN múltiple con información de vacunas próximas)
-- =============================================
\echo 'CONSULTA 4: Estado de vacunación por mascota'

SELECT 
    m.nombre AS mascota,
    e.nombre_especie AS especie,
    c.nombre || ' ' || c.apellido AS dueño,
    tc.numero_telefono AS telefono,
    v.nombre_vacuna,
    va.fecha_aplicacion,
    va.fecha_proxima_dosis,
    (va.fecha_proxima_dosis - CURRENT_DATE) AS dias_para_revacunacion,
    CASE 
        WHEN va.fecha_proxima_dosis < CURRENT_DATE THEN 'VENCIDA'
        WHEN (va.fecha_proxima_dosis - CURRENT_DATE) <= 30 THEN 'PRÓXIMA A VENCER'
        ELSE 'AL DÍA'
    END AS estado_vacuna,
    vet.nombre || ' ' || vet.apellido AS veterinario_aplico
FROM vacunas_aplicadas va
INNER JOIN mascotas m ON va.id_mascota = m.id_mascota
INNER JOIN especies e ON m.id_especie = e.id_especie
INNER JOIN clientes c ON m.id_cliente = c.id_cliente
INNER JOIN vacunas v ON va.id_vacuna = v.id_vacuna
INNER JOIN veterinarios vet ON va.id_veterinario = vet.id_veterinario
LEFT JOIN telefonos_cliente tc ON c.id_cliente = tc.id_cliente AND tc.es_principal = TRUE
WHERE m.estado = 'activo'
ORDER BY 
    CASE 
        WHEN va.fecha_proxima_dosis < CURRENT_DATE THEN 1
        WHEN (va.fecha_proxima_dosis - CURRENT_DATE) <= 30 THEN 2
        ELSE 3
    END,
    va.fecha_proxima_dosis;

-- =============================================
-- CONSULTA 5: Servicios realizados con facturación
-- (JOIN de 5 tablas con cálculos)
-- =============================================
\echo 'CONSULTA 5: Servicios realizados con detalle de facturación'

SELECT 
    sr.id_servicio_realizado AS factura_no,
    sr.fecha_servicio,
    m.nombre AS mascota,
    c.nombre || ' ' || c.apellido AS cliente,
    s.nombre_servicio AS servicio,
    s.tipo_servicio,
    e.nombre || ' ' || e.apellido AS empleado_realizo,
    sr.hora_inicio,
    sr.hora_fin,
    EXTRACT(EPOCH FROM (COALESCE(sr.hora_fin, CURRENT_TIME) - sr.hora_inicio))/60 AS duracion_minutos,
    s.precio_base AS precio_lista,
    sr.precio_final AS precio_cobrado,
    sr.precio_final - s.precio_base AS diferencia,
    sr.estado_pago
FROM servicios_realizados sr
INNER JOIN mascotas m ON sr.id_mascota = m.id_mascota
INNER JOIN clientes c ON m.id_cliente = c.id_cliente
INNER JOIN servicios s ON sr.id_servicio = s.id_servicio
INNER JOIN empleados e ON sr.id_empleado = e.id_empleado
ORDER BY sr.fecha_servicio DESC;

\echo ''
\echo '=========================================='
\echo 'SUBCONSULTAS ANIDADAS (Mínimo 2)'
\echo '=========================================='

-- =============================================
-- CONSULTA 6: Clientes con más de una mascota y promedio de edad de sus mascotas
-- (Subconsulta en FROM y subconsulta correlacionada en SELECT)
-- =============================================
\echo 'CONSULTA 6: Clientes con múltiples mascotas y estadísticas'

SELECT 
    c.id_cliente,
    c.nombre || ' ' || c.apellido AS cliente,
    c.email,
    ciu.nombre_ciudad AS ciudad,
    (SELECT COUNT(*) 
     FROM mascotas m 
     WHERE m.id_cliente = c.id_cliente 
       AND m.estado = 'activo') AS total_mascotas,
    (SELECT AVG(EXTRACT(YEAR FROM AGE(m.fecha_nacimiento)))
     FROM mascotas m 
     WHERE m.id_cliente = c.id_cliente 
       AND m.estado = 'activo') AS edad_promedio_mascotas,
    (SELECT COUNT(DISTINCT ci.id_cita)
     FROM citas ci
     INNER JOIN mascotas m ON ci.id_mascota = m.id_mascota
     WHERE m.id_cliente = c.id_cliente
       AND ci.estado_cita = 'completada') AS total_citas_completadas
FROM clientes c
INNER JOIN ciudades ciu ON c.id_ciudad = ciu.id_ciudad
WHERE c.id_cliente IN (
    SELECT m.id_cliente 
    FROM mascotas m 
    WHERE m.estado = 'activo'
    GROUP BY m.id_cliente 
    HAVING COUNT(*) > 1
)
ORDER BY total_mascotas DESC, cliente;

-- =============================================
-- CONSULTA 7: Veterinarios con más citas que el promedio
-- (Subconsulta anidada con agregación)
-- =============================================
\echo 'CONSULTA 7: Veterinarios con rendimiento superior al promedio'

SELECT 
    v.id_veterinario,
    v.nombre || ' ' || v.apellido AS veterinario,
    e.nombre_especialidad,
    v.email,
    (SELECT COUNT(*) 
     FROM citas ci 
     WHERE ci.id_veterinario = v.id_veterinario 
       AND ci.estado_cita = 'completada') AS citas_completadas,
    (SELECT COUNT(*) 
     FROM citas ci 
     WHERE ci.id_veterinario = v.id_veterinario 
       AND ci.estado_cita = 'pendiente') AS citas_pendientes,
    (SELECT COUNT(*) 
     FROM historial_medico hm 
     WHERE hm.id_veterinario = v.id_veterinario) AS historiales_creados
FROM veterinarios v
INNER JOIN especialidades e ON v.id_especialidad = e.id_especialidad
WHERE v.estado = 'activo'
  AND (SELECT COUNT(*) 
       FROM citas ci 
       WHERE ci.id_veterinario = v.id_veterinario) > 
      (SELECT AVG(total_citas) 
       FROM (SELECT COUNT(*) AS total_citas 
             FROM citas 
             GROUP BY id_veterinario) AS subconsulta_promedio)
ORDER BY citas_completadas DESC;

\echo ''
\echo '=========================================='
\echo 'FUNCIONES AGREGADAS (Mínimo 3)'
\echo '=========================================='

-- =============================================
-- CONSULTA 8: Estadísticas generales de la clínica
-- (COUNT, AVG, SUM, MIN, MAX)
-- =============================================
\echo 'CONSULTA 8: Estadísticas generales de la clínica'

SELECT 
    'CLIENTES' AS categoría,
    COUNT(*)::TEXT AS total,
    NULL AS promedio,
    NULL AS mínimo,
    NULL AS máximo
FROM clientes
WHERE estado = 'activo'

UNION ALL

SELECT 
    'MASCOTAS ACTIVAS',
    COUNT(*)::TEXT,
    ROUND(AVG(EXTRACT(YEAR FROM AGE(fecha_nacimiento))), 2)::TEXT,
    MIN(EXTRACT(YEAR FROM AGE(fecha_nacimiento)))::TEXT,
    MAX(EXTRACT(YEAR FROM AGE(fecha_nacimiento)))::TEXT
FROM mascotas
WHERE estado = 'activo'

UNION ALL

SELECT 
    'PESO PROMEDIO MASCOTAS (kg)',
    COUNT(*)::TEXT,
    ROUND(AVG(peso_actual), 2)::TEXT,
    MIN(peso_actual)::TEXT,
    MAX(peso_actual)::TEXT
FROM mascotas
WHERE estado = 'activo' AND peso_actual IS NOT NULL

UNION ALL

SELECT 
    'CITAS ESTE MES',
    COUNT(*)::TEXT,
    NULL,
    NULL,
    NULL
FROM citas
WHERE EXTRACT(MONTH FROM fecha_cita) = EXTRACT(MONTH FROM CURRENT_DATE)
  AND EXTRACT(YEAR FROM fecha_cita) = EXTRACT(YEAR FROM CURRENT_DATE)

UNION ALL

SELECT 
    'CITAS COMPLETADAS',
    COUNT(*)::TEXT,
    NULL,
    NULL,
    NULL
FROM citas
WHERE estado_cita = 'completada'

UNION ALL

SELECT 
    'TRATAMIENTOS ACTIVOS',
    COUNT(*)::TEXT,
    ROUND(AVG(duracion_dias), 2)::TEXT,
    MIN(duracion_dias)::TEXT,
    MAX(duracion_dias)::TEXT
FROM (
    SELECT (COALESCE(fecha_fin, CURRENT_DATE) - fecha_inicio) AS duracion_dias
    FROM tratamientos
    WHERE estado = 'activo'
) AS tratamientos;

-- =============================================
-- CONSULTA 9: Ingresos por servicios con agregaciones
-- (SUM, AVG, COUNT por tipo de servicio)
-- =============================================
\echo 'CONSULTA 9: Análisis de ingresos por tipo de servicio'

SELECT 
    s.tipo_servicio,
    COUNT(sr.id_servicio_realizado) AS cantidad_servicios,
    SUM(sr.precio_final) AS ingresos_totales,
    ROUND(AVG(sr.precio_final), 2) AS precio_promedio,
    MIN(sr.precio_final) AS precio_mínimo,
    MAX(sr.precio_final) AS precio_máximo,
    SUM(CASE WHEN sr.estado_pago = 'pagado' THEN sr.precio_final ELSE 0 END) AS ingresos_cobrados,
    SUM(CASE WHEN sr.estado_pago = 'pendiente' THEN sr.precio_final ELSE 0 END) AS ingresos_pendientes,
    COUNT(CASE WHEN sr.estado_pago = 'pagado' THEN 1 END) AS servicios_pagados,
    COUNT(CASE WHEN sr.estado_pago = 'pendiente' THEN 1 END) AS servicios_pendientes
FROM servicios s
INNER JOIN servicios_realizados sr ON s.id_servicio = sr.id_servicio
GROUP BY s.tipo_servicio
ORDER BY ingresos_totales DESC;

-- =============================================
-- CONSULTA 10: Top 5 mascotas con más visitas y gasto total
-- (COUNT, SUM con GROUP BY y ORDER BY)
-- =============================================
\echo 'CONSULTA 10: Top 5 mascotas con más visitas'

SELECT 
    m.nombre AS mascota,
    e.nombre_especie AS especie,
    r.nombre_raza AS raza,
    c.nombre || ' ' || c.apellido AS dueño,
    COUNT(DISTINCT ci.id_cita) AS total_citas,
    COUNT(DISTINCT hm.id_historial) AS total_consultas,
    COUNT(DISTINCT va.id_aplicacion) AS total_vacunas,
    COUNT(DISTINCT sr.id_servicio_realizado) AS total_servicios,
    COALESCE(SUM(sr.precio_final), 0) AS gasto_total_servicios
FROM mascotas m
INNER JOIN especies e ON m.id_especie = e.id_especie
INNER JOIN razas r ON m.id_raza = r.id_raza
INNER JOIN clientes c ON m.id_cliente = c.id_cliente
LEFT JOIN citas ci ON m.id_mascota = ci.id_mascota
LEFT JOIN historial_medico hm ON m.id_mascota = hm.id_mascota
LEFT JOIN vacunas_aplicadas va ON m.id_mascota = va.id_mascota
LEFT JOIN servicios_realizados sr ON m.id_mascota = sr.id_mascota
WHERE m.estado = 'activo'
GROUP BY m.id_mascota, m.nombre, e.nombre_especie, r.nombre_raza, c.nombre, c.apellido
ORDER BY total_citas DESC, total_consultas DESC
LIMIT 5;

-- =============================================
-- CONSULTAS ADICIONALES ÚTILES
-- =============================================
\echo ''
\echo '=========================================='
\echo 'CONSULTAS ADICIONALES (BONUS)'
\echo '=========================================='

-- =============================================
-- CONSULTA 11: Agenda del veterinario para hoy y próximos 7 días
-- =============================================
\echo 'CONSULTA 11: Agenda de veterinarios (próximos 7 días)'

SELECT 
    ci.fecha_cita,
    ci.hora_cita,
    v.nombre || ' ' || v.apellido AS veterinario,
    m.nombre AS mascota,
    e.nombre_especie AS especie,
    c.nombre || ' ' || c.apellido AS dueño,
    tc.numero_telefono AS telefono_cliente,
    ci.motivo_consulta,
    ci.estado_cita
FROM citas ci
INNER JOIN veterinarios v ON ci.id_veterinario = v.id_veterinario
INNER JOIN mascotas m ON ci.id_mascota = m.id_mascota
INNER JOIN especies e ON m.id_especie = e.id_especie
INNER JOIN clientes c ON m.id_cliente = c.id_cliente
LEFT JOIN telefonos_cliente tc ON c.id_cliente = tc.id_cliente AND tc.es_principal = TRUE
WHERE ci.fecha_cita BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '7 days'
  AND ci.estado_cita IN ('pendiente', 'en_proceso')
ORDER BY ci.fecha_cita, ci.hora_cita;

-- =============================================
-- CONSULTA 12: Vacunas que vencen en los próximos 30 días (alertas)
-- =============================================
\echo 'CONSULTA 12: Alertas de vacunas próximas a vencer'

SELECT 
    m.nombre AS mascota,
    e.nombre_especie AS especie,
    c.nombre || ' ' || c.apellido AS dueño,
    c.email AS email_dueño,
    tc.numero_telefono AS telefono,
    v.nombre_vacuna,
    va.fecha_aplicacion AS ultima_aplicacion,
    va.fecha_proxima_dosis,
    (va.fecha_proxima_dosis - CURRENT_DATE) AS dias_restantes,
    CASE 
        WHEN va.fecha_proxima_dosis < CURRENT_DATE THEN '⚠️ VENCIDA'
        WHEN (va.fecha_proxima_dosis - CURRENT_DATE) <= 7 THEN '🔴 URGENTE'
        WHEN (va.fecha_proxima_dosis - CURRENT_DATE) <= 30 THEN '🟡 PRÓXIMA'
        ELSE '🟢 AL DÍA'
    END AS prioridad
FROM vacunas_aplicadas va
INNER JOIN mascotas m ON va.id_mascota = m.id_mascota
INNER JOIN especies e ON m.id_especie = e.id_especie
INNER JOIN clientes c ON m.id_cliente = c.id_cliente
INNER JOIN vacunas v ON va.id_vacuna = v.id_vacuna
LEFT JOIN telefonos_cliente tc ON c.id_cliente = tc.id_cliente AND tc.es_principal = TRUE
WHERE m.estado = 'activo'
  AND va.fecha_proxima_dosis IS NOT NULL
  AND va.fecha_proxima_dosis <= CURRENT_DATE + INTERVAL '30 days'
ORDER BY va.fecha_proxima_dosis;

\echo ''
\echo '=========================================='
\echo 'RESUMEN DE CONSULTAS EJECUTADAS'
\echo '=========================================='
\echo 'Total de consultas con JOIN: 7'
\echo 'Total de subconsultas anidadas: 2'
\echo 'Total de consultas con agregación: 5'
\echo 'Consultas adicionales (bonus): 2'
\echo '=========================================='
\echo 'Todas las consultas ejecutadas exitosamente!'
