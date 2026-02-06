-- =============================================
-- SCRIPT DE INSERCIÓN DE DATOS DE PRUEBA
-- SISTEMA DE GESTIÓN DE CLÍNICA VETERINARIA
-- Motor: PostgreSQL 12+
-- Migrado desde SQL Server
-- =============================================

-- Conectar a la base de datos
\c veterinariadb;

-- =============================================
-- MÓDULO 1: UBICACIONES
-- =============================================

-- Provincias de Ecuador (ejemplo)
INSERT INTO provincias (nombre_provincia, codigo_provincia, pais) VALUES
('Guayas', 'GUA', 'Ecuador'),
('Pichincha', 'PIC', 'Ecuador'),
('Azuay', 'AZU', 'Ecuador'),
('Manabí', 'MAN', 'Ecuador');

-- Ciudades
INSERT INTO ciudades (id_provincia, nombre_ciudad, codigo_postal) VALUES
(1, 'Guayaquil', '090101'),
(1, 'Durán', '090901'),
(1, 'Samborondón', '091650'),
(2, 'Quito', '170101'),
(2, 'Sangolquí', '171103'),
(3, 'Cuenca', '010101'),
(4, 'Manta', '130201'),
(4, 'Portoviejo', '130101');

-- =============================================
-- MÓDULO 2: CLIENTES
-- =============================================

INSERT INTO clientes (nombre, apellido, direccion_calle, numero_direccion, id_ciudad, email, estado) VALUES
('Carlos', 'Mendoza', 'Av. Francisco de Orellana', 'Mz 123', 1, 'carlos.mendoza@email.com', 'activo'),
('María', 'González', 'Calle 9na', '456', 1, 'maria.gonzalez@email.com', 'activo'),
('Juan', 'Pérez', 'Av. Américas', '789', 1, 'juan.perez@email.com', 'activo'),
('Ana', 'Torres', 'Calle Amazonas', '321', 4, 'ana.torres@email.com', 'activo'),
('Pedro', 'Ramírez', 'Av. 6 de Diciembre', '654', 4, 'pedro.ramirez@email.com', 'activo'),
('Laura', 'Vega', 'Calle Bolívar', '147', 6, 'laura.vega@email.com', 'activo'),
('Roberto', 'Castro', 'Av. Kennedy', '258', 1, 'roberto.castro@email.com', 'activo'),
('Sofía', 'Morales', 'Calle Luque', '369', 1, 'sofia.morales@email.com', 'activo');

-- Teléfonos de clientes
INSERT INTO telefonos_cliente (id_cliente, numero_telefono, tipo_telefono, es_principal) VALUES
(1, '0991234567', 'móvil', TRUE),
(1, '042345678', 'casa', FALSE),
(2, '0987654321', 'móvil', TRUE),
(3, '0998765432', 'móvil', TRUE),
(3, '042876543', 'trabajo', FALSE),
(4, '0995432123', 'móvil', TRUE),
(5, '0992345678', 'móvil', TRUE),
(6, '0993456789', 'móvil', TRUE),
(7, '0994567890', 'móvil', TRUE),
(8, '0995678901', 'móvil', TRUE);

-- =============================================
-- MÓDULO 3: ESPECIES Y RAZAS
-- =============================================

-- Especies
INSERT INTO especies (nombre_especie, descripcion) VALUES
('Perro', 'Canis lupus familiaris'),
('Gato', 'Felis silvestris catus'),
('Ave', 'Diferentes especies de aves domésticas'),
('Conejo', 'Oryctolagus cuniculus'),
('Hámster', 'Cricetinae');

-- Razas de perros
INSERT INTO razas (id_especie, nombre_raza, tamaño_promedio, caracteristicas) VALUES
(1, 'Labrador Retriever', 'grande', 'Amigable, activo, buen temperamento'),
(1, 'Golden Retriever', 'grande', 'Inteligente, cariñoso, confiable'),
(1, 'Pastor Alemán', 'grande', 'Leal, inteligente, guardián'),
(1, 'Bulldog Francés', 'pequeño', 'Juguetón, adaptable, afectuoso'),
(1, 'Chihuahua', 'pequeño', 'Alerta, valiente, vivaz'),
(1, 'Poodle', 'mediano', 'Inteligente, activo, elegante'),
(1, 'Mestizo', 'mediano', 'Variado, único, resistente');

-- Razas de gatos
INSERT INTO razas (id_especie, nombre_raza, tamaño_promedio, caracteristicas) VALUES
(2, 'Persa', 'mediano', 'Tranquilo, cariñoso, de pelo largo'),
(2, 'Siamés', 'mediano', 'Vocal, social, inteligente'),
(2, 'Maine Coon', 'grande', 'Amigable, grande, adaptable'),
(2, 'Mestizo', 'mediano', 'Variado, único, resistente');

-- Razas de aves
INSERT INTO razas (id_especie, nombre_raza, tamaño_promedio, caracteristicas) VALUES
(3, 'Periquito', 'pequeño', 'Social, activo, parlanchín'),
(3, 'Canario', 'pequeño', 'Cantor, colorido, alegre'),
(3, 'Loro', 'mediano', 'Inteligente, longevo, sociable');

-- =============================================
-- MÓDULO 4: MASCOTAS
-- =============================================

INSERT INTO mascotas (id_cliente, nombre, id_especie, id_raza, fecha_nacimiento, color, peso_actual, genero, numero_microchip, estado) VALUES
(1, 'Max', 1, 1, '2020-05-15', 'Dorado', 32.5, 'M', '982000123456789', 'activo'),
(1, 'Luna', 2, 8, '2021-03-20', 'Blanco con gris', 4.2, 'F', '982000123456790', 'activo'),
(2, 'Rocky', 1, 3, '2019-08-10', 'Negro y café', 38.0, 'M', '982000123456791', 'activo'),
(3, 'Bella', 1, 2, '2021-01-25', 'Crema', 28.5, 'F', '982000123456792', 'activo'),
(3, 'Mishi', 2, 9, '2020-11-12', 'Gris', 4.8, 'F', '982000123456793', 'activo'),
(4, 'Toby', 1, 4, '2022-06-30', 'Blanco', 12.0, 'M', '982000123456794', 'activo'),
(5, 'Nala', 2, 11, '2021-07-18', 'Naranja', 3.5, 'F', NULL, 'activo'),
(6, 'Zeus', 1, 1, '2018-04-05', 'Negro', 35.0, 'M', '982000123456795', 'activo'),
(7, 'Coco', 1, 5, '2022-09-22', 'Café', 2.8, 'F', '982000123456796', 'activo'),
(8, 'Simba', 2, 10, '2020-02-14', 'Crema', 5.5, 'M', '982000123456797', 'activo'),
(1, 'Kiwi', 3, 12, '2023-01-10', 'Verde', 0.08, 'M', NULL, 'activo'),
(5, 'Firulais', 1, 7, '2019-12-05', 'Mixto', 18.5, 'M', NULL, 'activo');

-- =============================================
-- MÓDULO 5: ESPECIALIDADES Y VETERINARIOS
-- =============================================

INSERT INTO especialidades (nombre_especialidad, descripcion) VALUES
('Medicina General', 'Atención veterinaria general y preventiva'),
('Cirugía', 'Procedimientos quirúrgicos especializados'),
('Dermatología', 'Enfermedades de la piel y alergias'),
('Cardiología', 'Enfermedades del corazón y sistema circulatorio'),
('Odontología', 'Salud dental y bucal'),
('Oftalmología', 'Enfermedades de los ojos');

INSERT INTO veterinarios (nombre, apellido, id_especialidad, telefono, email, numero_licencia, fecha_contratacion, fecha_nacimiento, estado) VALUES
('Dr. Luis', 'Martínez', 1, '0981234567', 'luis.martinez@vetclinic.com', 'VET-2018-001', '2018-01-15', '1985-06-20', 'activo'),
('Dra. Carmen', 'Flores', 2, '0982345678', 'carmen.flores@vetclinic.com', 'VET-2019-002', '2019-03-10', '1988-09-12', 'activo'),
('Dr. Diego', 'Salazar', 3, '0983456789', 'diego.salazar@vetclinic.com', 'VET-2020-003', '2020-06-01', '1990-11-25', 'activo'),
('Dra. Patricia', 'Herrera', 1, '0984567890', 'patricia.herrera@vetclinic.com', 'VET-2021-004', '2021-02-20', '1992-03-08', 'activo'),
('Dr. Miguel', 'Vargas', 4, '0985678901', 'miguel.vargas@vetclinic.com', 'VET-2022-005', '2022-08-15', '1987-07-30', 'activo');

-- =============================================
-- MÓDULO 6: CITAS
-- =============================================

INSERT INTO citas (id_mascota, id_veterinario, fecha_cita, hora_cita, motivo_consulta, estado_cita, observaciones) VALUES
-- Citas pasadas completadas
(1, 1, '2025-01-15', '09:00', 'Consulta de rutina y vacunación', 'completada', 'Mascota en buen estado general'),
(2, 2, '2025-01-15', '10:00', 'Control dermatológico', 'completada', 'Mejora en lesiones cutáneas'),
(3, 1, '2025-01-16', '09:30', 'Revisión post-operatoria', 'completada', 'Recuperación satisfactoria'),
(4, 3, '2025-01-17', '11:00', 'Problema de piel - rascado excesivo', 'completada', 'Diagnosticada alergia'),
(5, 4, '2025-01-18', '14:00', 'Vómitos recurrentes', 'completada', 'Se prescribió tratamiento'),
-- Citas próximas pendientes
(6, 1, '2025-02-03', '09:00', 'Primera vacunación', 'pendiente', 'Cachorro - primera consulta'),
(7, 2, '2025-02-03', '10:30', 'Control general', 'pendiente', NULL),
(8, 1, '2025-02-04', '15:00', 'Vacunación antirrábica', 'pendiente', NULL),
(9, 3, '2025-02-05', '11:00', 'Control de peso y nutrición', 'pendiente', 'Seguimiento de dieta'),
(10, 4, '2025-02-06', '16:00', 'Limpieza dental', 'pendiente', NULL),
-- Cita cancelada
(1, 2, '2025-01-20', '10:00', 'Control general', 'cancelada', 'Cliente canceló por viaje');

-- =============================================
-- MÓDULO 7: HISTORIAL MÉDICO Y TRATAMIENTOS
-- =============================================

-- Historial médico para citas completadas
INSERT INTO historial_medico (id_cita, id_mascota, id_veterinario, fecha_consulta, diagnostico, peso_registrado, temperatura, frecuencia_cardiaca, observaciones_generales) VALUES
(1, 1, 1, '2025-01-15 09:15:00', 'Estado de salud óptimo. Aplicación de vacuna séxtuple.', 32.5, 38.5, 95, 'Mascota activa y saludable. Se recomienda continuar con alimentación balanceada.'),
(2, 2, 2, '2025-01-15 10:10:00', 'Dermatitis alérgica en mejoría. Continuar tratamiento.', 4.2, 38.2, 140, 'Reducción significativa de lesiones. Propietario siguiendo indicaciones.'),
(3, 3, 1, '2025-01-16 09:45:00', 'Post-operatorio de esterilización. Sin complicaciones.', 37.8, 38.3, 88, 'Herida quirúrgica con cicatrización normal. Retirar puntos en 10 días.'),
(4, 4, 3, '2025-01-17 11:15:00', 'Dermatitis atópica. Alergia alimentaria probable.', 28.0, 38.6, 92, 'Se observa enrojecimiento en abdomen y patas. Prurito intenso.'),
(5, 5, 4, '2025-01-18 14:20:00', 'Gastroenteritis leve. Probablemente por cambio de alimentación.', 4.7, 38.8, 145, 'Mucosas rosadas. Hidratación adecuada.');

-- Tratamientos
INSERT INTO tratamientos (id_historial, descripcion_tratamiento, fecha_inicio, fecha_fin, instrucciones, estado) VALUES
(2, 'Tratamiento dermatológico con antihistamínicos', '2025-01-15', '2025-02-15', 'Aplicar shampoo medicado 2 veces por semana. Administrar antihistamínico diario.', 'activo'),
(3, 'Cuidados post-quirúrgicos', '2025-01-16', '2025-01-26', 'Mantener área limpia y seca. Evitar que se lama la herida. Usar collar isabelino.', 'activo'),
(4, 'Dieta hipoalergénica y tratamiento sintomático', '2025-01-17', '2025-02-17', 'Cambiar a alimento hipoalergénico. Evitar premios con pollo o res.', 'activo'),
(5, 'Tratamiento para gastroenteritis', '2025-01-18', '2025-01-25', 'Ayuno de 12 horas, luego dieta blanda. Administrar probióticos.', 'activo');

-- =============================================
-- MÓDULO 8: MEDICAMENTOS
-- =============================================

INSERT INTO medicamentos (nombre_medicamento, descripcion, laboratorio, presentacion, tipo, requiere_receta) VALUES
('Amoxicilina', 'Antibiótico de amplio espectro', 'VetPharma', '250mg tabletas', 'antibiótico', TRUE),
('Meloxicam', 'Antiinflamatorio no esteroideo', 'AnimalHealth', '1mg/ml suspensión', 'antiinflamatorio', TRUE),
('Cetirizina', 'Antihistamínico para alergias', 'PetMed', '10mg tabletas', 'antiinflamatorio', FALSE),
('Metronidazol', 'Antibiótico y antiparasitario', 'VetCare', '250mg tabletas', 'antibiótico', TRUE),
('Probióticos Caninos', 'Suplemento de flora intestinal', 'NutriPet', 'Polvo sobres', 'suplemento', FALSE),
('Ivermectina', 'Antiparasitario', 'ParasitControl', '1% solución', 'antiparasitario', TRUE),
('Omeprazol', 'Protector gástrico', 'GastroVet', '20mg cápsulas', 'otro', TRUE);

-- Medicamentos recetados
INSERT INTO medicamentos_recetados (id_tratamiento, id_medicamento, dosis, frecuencia, duracion_dias, via_administracion, observaciones) VALUES
(1, 3, '10mg', 'Una vez al día', 30, 'oral', 'Administrar con alimento'),
(2, 2, '0.5ml', 'Una vez al día', 7, 'oral', 'Dar después de comida'),
(3, 1, '250mg', 'Dos veces al día', 10, 'oral', 'Completar todo el tratamiento'),
(4, 3, '10mg', 'Dos veces al día', 30, 'oral', 'Continuar hasta nueva evaluación'),
(4, 2, '0.5ml', 'Una vez al día', 15, 'oral', 'Si persiste picazón'),
(4, 4, '250mg', 'Dos veces al día', 7, 'oral', 'Dar con alimento'),
(4, 5, '1 sobre', 'Una vez al día', 14, 'oral', 'Mezclar con comida');

-- =============================================
-- MÓDULO 9: VACUNAS
-- =============================================

INSERT INTO vacunas (nombre_vacuna, descripcion, enfermedad_previene, laboratorio, periodo_revacunacion_dias, es_obligatoria, id_especie) VALUES
('Séxtuple Canina', 'Protección contra 6 enfermedades', 'Moquillo, Parvovirus, Hepatitis, Leptospirosis, Parainfluenza, Coronavirus', 'BioVet', 365, TRUE, 1),
('Antirrábica', 'Prevención de rabia', 'Rabia', 'RabiesControl', 365, TRUE, 1),
('Triple Felina', 'Protección contra 3 enfermedades', 'Panleucopenia, Rinotraqueitis, Calicivirus', 'FelineVax', 365, TRUE, 2),
('Antirrábica Felina', 'Prevención de rabia en gatos', 'Rabia', 'RabiesControl', 365, TRUE, 2),
('Leucemia Felina', 'Prevención de leucemia', 'Leucemia Felina (FeLV)', 'FelineVax', 365, FALSE, 2),
('Tos de las Perreras', 'Prevención de bordetella', 'Bordetella bronchiseptica', 'CanineHealth', 180, FALSE, 1);

-- Vacunas aplicadas
INSERT INTO vacunas_aplicadas (id_mascota, id_vacuna, id_veterinario, fecha_aplicacion, fecha_proxima_dosis, lote, observaciones, reaccion_adversa) VALUES
(1, 1, 1, '2025-01-15', '2026-01-15', 'SX-2024-001', 'Aplicación sin complicaciones', FALSE),
(1, 2, 1, '2024-06-20', '2025-06-20', 'RAB-2024-045', 'Primera dosis anual', FALSE),
(2, 3, 2, '2024-05-10', '2025-05-10', 'TF-2024-023', 'Refuerzo anual', FALSE),
(2, 4, 2, '2024-05-10', '2025-05-10', 'RAB-2024-023', 'Aplicada junto con triple felina', FALSE),
(3, 1, 1, '2024-09-15', '2025-09-15', 'SX-2024-089', 'Vacunación de rutina', FALSE),
(3, 2, 1, '2024-09-15', '2025-09-15', 'RAB-2024-089', 'Sin reacciones', FALSE),
(4, 1, 3, '2024-12-20', '2025-12-20', 'SX-2024-150', 'Primer refuerzo', FALSE),
(5, 3, 4, '2024-03-15', '2025-03-15', 'TF-2024-012', 'Vacunación completa', FALSE),
(8, 1, 1, '2023-08-10', '2024-08-10', 'SX-2023-120', 'Requiere refuerzo próximamente', FALSE),
(8, 2, 1, '2024-01-05', '2025-01-05', 'RAB-2024-003', 'Al día con vacunación', FALSE);

-- =============================================
-- MÓDULO 10: SERVICIOS Y EMPLEADOS
-- =============================================

INSERT INTO servicios (nombre_servicio, descripcion, precio_base, duracion_estimada_min, tipo_servicio) VALUES
('Baño para perro pequeño', 'Baño completo con shampoo medicado', 15.00, 45, 'estética'),
('Baño para perro mediano', 'Baño completo con shampoo y acondicionador', 20.00, 60, 'estética'),
('Baño para perro grande', 'Baño completo con productos premium', 30.00, 90, 'estética'),
('Baño para gato', 'Baño especializado para felinos', 25.00, 60, 'estética'),
('Corte de pelo estilo mascota', 'Corte y peinado según raza', 25.00, 90, 'estética'),
('Corte de uñas', 'Corte y limado de uñas', 5.00, 15, 'estética'),
('Limpieza dental', 'Limpieza dental profesional', 80.00, 120, 'salud'),
('Desparasitación', 'Desparasitación interna y externa', 15.00, 20, 'salud'),
('Hospedaje diario', 'Cuidado y hospedaje por día', 20.00, 1440, 'hospedaje'),
('Adiestramiento básico (sesión)', 'Sesión de entrenamiento básico', 35.00, 60, 'adiestramiento');

INSERT INTO empleados (nombre, apellido, puesto, telefono, email, fecha_contratacion, estado) VALUES
('Andrea', 'López', 'groomer', '0971234567', 'andrea.lopez@vetclinic.com', '2020-03-15', 'activo'),
('Carlos', 'Mendez', 'groomer', '0972345678', 'carlos.mendez@vetclinic.com', '2021-06-20', 'activo'),
('María', 'Silva', 'recepcionista', '0973456789', 'maria.silva@vetclinic.com', '2019-01-10', 'activo'),
('Jorge', 'Ramos', 'asistente', '0974567890', 'jorge.ramos@vetclinic.com', '2022-02-28', 'activo'),
('Diana', 'Cruz', 'cuidador', '0975678901', 'diana.cruz@vetclinic.com', '2023-05-15', 'activo');

INSERT INTO servicios_realizados (id_mascota, id_servicio, id_empleado, fecha_servicio, hora_inicio, hora_fin, precio_final, estado_pago, observaciones) VALUES
(1, 2, 1, '2025-01-10', '10:00', '11:00', 20.00, 'pagado', 'Mascota muy cooperativa'),
(2, 4, 2, '2025-01-12', '14:00', '15:00', 25.00, 'pagado', 'Gato nervioso, se usó sedación leve'),
(3, 3, 1, '2025-01-14', '09:00', '10:30', 30.00, 'pagado', 'Pelo enredado, se realizó desenredado'),
(4, 2, 1, '2025-01-18', '11:00', '12:00', 20.00, 'pendiente', 'Servicio realizado, pago pendiente'),
(6, 1, 2, '2025-01-20', '15:00', '15:45', 15.00, 'pagado', 'Primera vez del cachorro en el baño'),
(7, 4, 2, '2025-01-22', '10:00', '11:00', 25.00, 'pagado', 'Sin complicaciones'),
(1, 6, 4, '2025-01-25', '13:00', '13:15', 5.00, 'pagado', 'Corte de uñas de rutina'),
(9, 1, 1, '2025-01-28', '16:00', '16:45', 15.00, 'pendiente', 'Cachorro juguetón'),
(10, 4, 2, '2025-01-30', '11:30', '12:30', 25.00, 'pagado', 'Gato tranquilo');

-- =============================================
-- VERIFICACIÓN DE DATOS
-- =============================================

DO $$
DECLARE
    v_count INTEGER;
BEGIN
    RAISE NOTICE '==========================================';
    RAISE NOTICE 'RESUMEN DE DATOS INSERTADOS';
    RAISE NOTICE '==========================================';
    
    SELECT COUNT(*) INTO v_count FROM provincias;
    RAISE NOTICE 'Provincias: %', v_count;
    
    SELECT COUNT(*) INTO v_count FROM ciudades;
    RAISE NOTICE 'Ciudades: %', v_count;
    
    SELECT COUNT(*) INTO v_count FROM clientes;
    RAISE NOTICE 'Clientes: %', v_count;
    
    SELECT COUNT(*) INTO v_count FROM telefonos_cliente;
    RAISE NOTICE 'Teléfonos: %', v_count;
    
    SELECT COUNT(*) INTO v_count FROM especies;
    RAISE NOTICE 'Especies: %', v_count;
    
    SELECT COUNT(*) INTO v_count FROM razas;
    RAISE NOTICE 'Razas: %', v_count;
    
    SELECT COUNT(*) INTO v_count FROM mascotas;
    RAISE NOTICE 'Mascotas: %', v_count;
    
    SELECT COUNT(*) INTO v_count FROM especialidades;
    RAISE NOTICE 'Especialidades: %', v_count;
    
    SELECT COUNT(*) INTO v_count FROM veterinarios;
    RAISE NOTICE 'Veterinarios: %', v_count;
    
    SELECT COUNT(*) INTO v_count FROM citas;
    RAISE NOTICE 'Citas: %', v_count;
    
    SELECT COUNT(*) INTO v_count FROM historial_medico;
    RAISE NOTICE 'Historiales Médicos: %', v_count;
    
    SELECT COUNT(*) INTO v_count FROM tratamientos;
    RAISE NOTICE 'Tratamientos: %', v_count;
    
    SELECT COUNT(*) INTO v_count FROM medicamentos;
    RAISE NOTICE 'Medicamentos: %', v_count;
    
    SELECT COUNT(*) INTO v_count FROM medicamentos_recetados;
    RAISE NOTICE 'Recetas: %', v_count;
    
    SELECT COUNT(*) INTO v_count FROM vacunas;
    RAISE NOTICE 'Vacunas: %', v_count;
    
    SELECT COUNT(*) INTO v_count FROM vacunas_aplicadas;
    RAISE NOTICE 'Vacunas Aplicadas: %', v_count;
    
    SELECT COUNT(*) INTO v_count FROM servicios;
    RAISE NOTICE 'Servicios: %', v_count;
    
    SELECT COUNT(*) INTO v_count FROM empleados;
    RAISE NOTICE 'Empleados: %', v_count;
    
    SELECT COUNT(*) INTO v_count FROM servicios_realizados;
    RAISE NOTICE 'Servicios Realizados: %', v_count;
    
    RAISE NOTICE '==========================================';
    RAISE NOTICE 'Datos de prueba insertados exitosamente!';
END $$;
