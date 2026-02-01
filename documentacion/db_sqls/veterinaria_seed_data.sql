-- =============================================
-- SCRIPT DE INSERCIÓN DE DATOS DE PRUEBA
-- SISTEMA DE GESTIÓN DE CLÍNICA VETERINARIA
-- =============================================

USE VeterinariaDB;
GO

-- =============================================
-- MÓDULO 1: UBICACIONES
-- =============================================

-- Provincias de Ecuador (ejemplo)
INSERT INTO PROVINCIAS (Nombre_Provincia, Codigo_Provincia, Pais) VALUES
('Guayas', 'GUA', 'Ecuador'),
('Pichincha', 'PIC', 'Ecuador'),
('Azuay', 'AZU', 'Ecuador'),
('Manabí', 'MAN', 'Ecuador');
GO

-- Ciudades
INSERT INTO CIUDADES (ID_Provincia, Nombre_Ciudad, Codigo_Postal) VALUES
(1, 'Guayaquil', '090101'),
(1, 'Durán', '090901'),
(1, 'Samborondón', '091650'),
(2, 'Quito', '170101'),
(2, 'Sangolquí', '171103'),
(3, 'Cuenca', '010101'),
(4, 'Manta', '130201'),
(4, 'Portoviejo', '130101');
GO

-- =============================================
-- MÓDULO 2: CLIENTES
-- =============================================

INSERT INTO CLIENTES (Nombre, Apellido, Direccion_Calle, Numero_Direccion, ID_Ciudad, Email, Estado) VALUES
('Carlos', 'Mendoza', 'Av. Francisco de Orellana', 'Mz 123', 1, 'carlos.mendoza@email.com', 'activo'),
('María', 'González', 'Calle 9na', '456', 1, 'maria.gonzalez@email.com', 'activo'),
('Juan', 'Pérez', 'Av. Américas', '789', 1, 'juan.perez@email.com', 'activo'),
('Ana', 'Torres', 'Calle Amazonas', '321', 4, 'ana.torres@email.com', 'activo'),
('Pedro', 'Ramírez', 'Av. 6 de Diciembre', '654', 4, 'pedro.ramirez@email.com', 'activo'),
('Laura', 'Vega', 'Calle Bolívar', '147', 6, 'laura.vega@email.com', 'activo'),
('Roberto', 'Castro', 'Av. Kennedy', '258', 1, 'roberto.castro@email.com', 'activo'),
('Sofía', 'Morales', 'Calle Luque', '369', 1, 'sofia.morales@email.com', 'activo');
GO

-- Teléfonos de clientes
INSERT INTO TELEFONOS_CLIENTE (ID_Cliente, Numero_Telefono, Tipo_Telefono, Es_Principal) VALUES
(1, '0991234567', 'móvil', 1),
(1, '042345678', 'casa', 0),
(2, '0987654321', 'móvil', 1),
(3, '0998765432', 'móvil', 1),
(3, '042876543', 'trabajo', 0),
(4, '0995432123', 'móvil', 1),
(5, '0992345678', 'móvil', 1),
(6, '0993456789', 'móvil', 1),
(7, '0994567890', 'móvil', 1),
(8, '0995678901', 'móvil', 1);
GO

-- =============================================
-- MÓDULO 3: ESPECIES Y RAZAS
-- =============================================

-- Especies
INSERT INTO ESPECIES (Nombre_Especie, Descripcion) VALUES
('Perro', 'Canis lupus familiaris'),
('Gato', 'Felis silvestris catus'),
('Ave', 'Diferentes especies de aves domésticas'),
('Conejo', 'Oryctolagus cuniculus'),
('Hámster', 'Cricetinae');
GO

-- Razas de perros
INSERT INTO RAZAS (ID_Especie, Nombre_Raza, Tamaño_Promedio, Caracteristicas) VALUES
(1, 'Labrador Retriever', 'grande', 'Amigable, activo, buen temperamento'),
(1, 'Golden Retriever', 'grande', 'Inteligente, cariñoso, confiable'),
(1, 'Pastor Alemán', 'grande', 'Leal, inteligente, guardián'),
(1, 'Bulldog Francés', 'pequeño', 'Juguetón, adaptable, afectuoso'),
(1, 'Chihuahua', 'pequeño', 'Alerta, valiente, vivaz'),
(1, 'Poodle', 'mediano', 'Inteligente, activo, elegante'),
(1, 'Mestizo', 'mediano', 'Variado, único, resistente');
GO

-- Razas de gatos
INSERT INTO RAZAS (ID_Especie, Nombre_Raza, Tamaño_Promedio, Caracteristicas) VALUES
(2, 'Persa', 'mediano', 'Tranquilo, cariñoso, de pelo largo'),
(2, 'Siamés', 'mediano', 'Vocal, social, inteligente'),
(2, 'Maine Coon', 'grande', 'Amigable, grande, adaptable'),
(2, 'Mestizo', 'mediano', 'Variado, único, resistente');
GO

-- Razas de aves
INSERT INTO RAZAS (ID_Especie, Nombre_Raza, Tamaño_Promedio, Caracteristicas) VALUES
(3, 'Periquito', 'pequeño', 'Social, activo, parlanchín'),
(3, 'Canario', 'pequeño', 'Cantor, colorido, alegre'),
(3, 'Loro', 'mediano', 'Inteligente, longevo, sociable');
GO

-- =============================================
-- MÓDULO 4: MASCOTAS
-- =============================================

INSERT INTO MASCOTAS (ID_Cliente, Nombre, ID_Especie, ID_Raza, Fecha_Nacimiento, Color, Peso_Actual, Genero, Numero_Microchip, Estado) VALUES
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
GO

-- =============================================
-- MÓDULO 5: ESPECIALIDADES Y VETERINARIOS
-- =============================================

INSERT INTO ESPECIALIDADES (Nombre_Especialidad, Descripcion) VALUES
('Medicina General', 'Atención veterinaria general y preventiva'),
('Cirugía', 'Procedimientos quirúrgicos especializados'),
('Dermatología', 'Enfermedades de la piel y alergias'),
('Cardiología', 'Enfermedades del corazón y sistema circulatorio'),
('Odontología', 'Salud dental y bucal'),
('Oftalmología', 'Enfermedades de los ojos');
GO

INSERT INTO VETERINARIOS (Nombre, Apellido, ID_Especialidad, Telefono, Email, Numero_Licencia, Fecha_Contratacion, Fecha_Nacimiento, Estado) VALUES
('Dr. Luis', 'Martínez', 1, '0981234567', 'luis.martinez@vetclinic.com', 'VET-2018-001', '2018-01-15', '1985-06-20', 'activo'),
('Dra. Carmen', 'Flores', 2, '0982345678', 'carmen.flores@vetclinic.com', 'VET-2019-002', '2019-03-10', '1988-09-12', 'activo'),
('Dr. Diego', 'Salazar', 3, '0983456789', 'diego.salazar@vetclinic.com', 'VET-2020-003', '2020-06-01', '1990-11-25', 'activo'),
('Dra. Patricia', 'Herrera', 1, '0984567890', 'patricia.herrera@vetclinic.com', 'VET-2021-004', '2021-02-20', '1992-03-08', 'activo'),
('Dr. Miguel', 'Vargas', 4, '0985678901', 'miguel.vargas@vetclinic.com', 'VET-2022-005', '2022-08-15', '1987-07-30', 'activo');
GO

-- =============================================
-- MÓDULO 6: CITAS
-- =============================================

INSERT INTO CITAS (ID_Mascota, ID_Veterinario, Fecha_Cita, Hora_Cita, Motivo_Consulta, Estado_Cita, Observaciones) VALUES
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
GO

-- =============================================
-- MÓDULO 7: HISTORIAL MÉDICO Y TRATAMIENTOS
-- =============================================

-- Historial médico para citas completadas
INSERT INTO HISTORIAL_MEDICO (ID_Cita, ID_Mascota, ID_Veterinario, Fecha_Consulta, Diagnostico, Peso_Registrado, Temperatura, Frecuencia_Cardiaca, Observaciones_Generales) VALUES
(1, 1, 1, '2025-01-15 09:15:00', 'Estado de salud óptimo. Aplicación de vacuna séxtuple.', 32.5, 38.5, 95, 'Mascota activa y saludable. Se recomienda continuar con alimentación balanceada.'),
(2, 2, 2, '2025-01-15 10:10:00', 'Dermatitis alérgica en mejoría. Continuar tratamiento.', 4.2, 38.2, 140, 'Reducción significativa de lesiones. Propietario siguiendo indicaciones.'),
(3, 3, 1, '2025-01-16 09:45:00', 'Post-operatorio de esterilización. Sin complicaciones.', 37.8, 38.3, 88, 'Herida quirúrgica con cicatrización normal. Retirar puntos en 10 días.'),
(4, 4, 3, '2025-01-17 11:15:00', 'Dermatitis atópica. Alergia alimentaria probable.', 28.0, 38.6, 92, 'Se observa enrojecimiento en abdomen y patas. Prurito intenso.'),
(5, 5, 4, '2025-01-18 14:20:00', 'Gastroenteritis leve. Probablemente por cambio de alimentación.', 4.7, 38.8, 145, 'Mucosas rosadas. Hidratación adecuada.');
GO

-- Tratamientos
INSERT INTO TRATAMIENTOS (ID_Historial, Descripcion_Tratamiento, Fecha_Inicio, Fecha_Fin, Instrucciones, Estado) VALUES
(2, 'Tratamiento dermatológico con antihistamínicos', '2025-01-15', '2025-02-15', 'Aplicar shampoo medicado 2 veces por semana. Administrar antihistamínico diario.', 'activo'),
(3, 'Cuidados post-quirúrgicos', '2025-01-16', '2025-01-26', 'Mantener área limpia y seca. Evitar que se lama la herida. Usar collar isabelino.', 'activo'),
(4, 'Dieta hipoalergénica y tratamiento sintomático', '2025-01-17', '2025-02-17', 'Cambiar a alimento hipoalergénico. Evitar premios con pollo o res.', 'activo'),
(5, 'Tratamiento para gastroenteritis', '2025-01-18', '2025-01-25', 'Ayuno de 12 horas, luego dieta blanda. Administrar probióticos.', 'activo');
GO

-- =============================================
-- MÓDULO 8: MEDICAMENTOS
-- =============================================

INSERT INTO MEDICAMENTOS (Nombre_Medicamento, Descripcion, Laboratorio, Presentacion, Tipo, Requiere_Receta) VALUES
('Amoxicilina', 'Antibiótico de amplio espectro', 'VetPharma', '250mg tabletas', 'antibiótico', 1),
('Meloxicam', 'Antiinflamatorio no esteroideo', 'AnimalHealth', '1mg/ml suspensión', 'antiinflamatorio', 1),
('Cetirizina', 'Antihistamínico para alergias', 'PetMed', '10mg tabletas', 'antiinflamatorio', 0),
('Metronidazol', 'Antibiótico y antiparasitario', 'VetCare', '250mg tabletas', 'antibiótico', 1),
('Probióticos Caninos', 'Suplemento de flora intestinal', 'NutriPet', 'Polvo sobres', 'suplemento', 0),
('Ivermectina', 'Antiparasitario', 'ParasitControl', '1% solución', 'antiparasitario', 1),
('Omeprazol', 'Protector gástrico', 'GastroVet', '20mg cápsulas', 'otro', 1);
GO

-- Medicamentos recetados
INSERT INTO MEDICAMENTOS_RECETADOS (ID_Tratamiento, ID_Medicamento, Dosis, Frecuencia, Duracion_Dias, Via_Administracion, Observaciones) VALUES
(1, 3, '10mg', 'Una vez al día', 30, 'oral', 'Administrar con alimento'),
(2, 2, '0.5ml', 'Una vez al día', 7, 'oral', 'Dar después de comida'),
(3, 1, '250mg', 'Dos veces al día', 10, 'oral', 'Completar todo el tratamiento'),
(4, 3, '10mg', 'Dos veces al día', 30, 'oral', 'Continuar hasta nueva evaluación'),
(4, 2, '0.5ml', 'Una vez al día', 15, 'oral', 'Si persiste picazón'),
(5, 4, '250mg', 'Dos veces al día', 7, 'oral', 'Dar con alimento'),
(5, 5, '1 sobre', 'Una vez al día', 14, 'oral', 'Mezclar con comida');
GO

-- =============================================
-- MÓDULO 9: VACUNAS
-- =============================================

INSERT INTO VACUNAS (Nombre_Vacuna, Descripcion, Enfermedad_Previene, Laboratorio, Periodo_Revacunacion_Dias, Es_Obligatoria, ID_Especie) VALUES
('Séxtuple Canina', 'Protección contra 6 enfermedades', 'Moquillo, Parvovirus, Hepatitis, Leptospirosis, Parainfluenza, Coronavirus', 'BioVet', 365, 1, 1),
('Antirrábica', 'Prevención de rabia', 'Rabia', 'RabiesControl', 365, 1, 1),
('Triple Felina', 'Protección contra 3 enfermedades', 'Panleucopenia, Rinotraqueitis, Calicivirus', 'FelineVax', 365, 1, 2),
('Antirrábica Felina', 'Prevención de rabia en gatos', 'Rabia', 'RabiesControl', 365, 1, 2),
('Leucemia Felina', 'Prevención de leucemia', 'Leucemia Felina (FeLV)', 'FelineVax', 365, 0, 2),
('Tos de las Perreras', 'Prevención de bordetella', 'Bordetella bronchiseptica', 'CanineHealth', 180, 0, 1);
GO

-- Vacunas aplicadas
INSERT INTO VACUNAS_APLICADAS (ID_Mascota, ID_Vacuna, ID_Veterinario, Fecha_Aplicacion, Fecha_Proxima_Dosis, Lote, Observaciones, Reaccion_Adversa) VALUES
(1, 1, 1, '2025-01-15', '2026-01-15', 'SX-2024-001', 'Aplicación sin complicaciones', 0),
(1, 2, 1, '2024-06-20', '2025-06-20', 'RAB-2024-045', 'Primera dosis anual', 0),
(2, 3, 2, '2024-05-10', '2025-05-10', 'TF-2024-023', 'Refuerzo anual', 0),
(2, 4, 2, '2024-05-10', '2025-05-10', 'RAB-2024-023', 'Aplicada junto con triple felina', 0),
(3, 1, 1, '2024-09-15', '2025-09-15', 'SX-2024-089', 'Vacunación de rutina', 0),
(3, 2, 1, '2024-09-15', '2025-09-15', 'RAB-2024-089', 'Sin reacciones', 0),
(4, 1, 3, '2024-12-20', '2025-12-20', 'SX-2024-150', 'Primer refuerzo', 0),
(5, 3, 4, '2024-03-15', '2025-03-15', 'TF-2024-012', 'Vacunación completa', 0),
(8, 1, 1, '2023-08-10', '2024-08-10', 'SX-2023-120', 'Requiere refuerzo próximamente', 0),
(8, 2, 1, '2024-01-05', '2025-01-05', 'RAB-2024-003', 'Al día con vacunación', 0);
GO

-- =============================================
-- MÓDULO 10: SERVICIOS Y EMPLEADOS
-- =============================================

INSERT INTO SERVICIOS (Nombre_Servicio, Descripcion, Precio_Base, Duracion_Estimada_Min, Tipo_Servicio) VALUES
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
GO

INSERT INTO EMPLEADOS (Nombre, Apellido, Puesto, Telefono, Email, Fecha_Contratacion, Estado) VALUES
('Andrea', 'López', 'groomer', '0971234567', 'andrea.lopez@vetclinic.com', '2020-03-15', 'activo'),
('Carlos', 'Mendez', 'groomer', '0972345678', 'carlos.mendez@vetclinic.com', '2021-06-20', 'activo'),
('María', 'Silva', 'recepcionista', '0973456789', 'maria.silva@vetclinic.com', '2019-01-10', 'activo'),
('Jorge', 'Ramos', 'asistente', '0974567890', 'jorge.ramos@vetclinic.com', '2022-02-28', 'activo'),
('Diana', 'Cruz', 'cuidador', '0975678901', 'diana.cruz@vetclinic.com', '2023-05-15', 'activo');
GO

INSERT INTO SERVICIOS_REALIZADOS (ID_Mascota, ID_Servicio, ID_Empleado, Fecha_Servicio, Hora_Inicio, Hora_Fin, Precio_Final, Estado_Pago, Observaciones) VALUES
(1, 2, 1, '2025-01-10', '10:00', '11:00', 20.00, 'pagado', 'Mascota muy cooperativa'),
(2, 4, 2, '2025-01-12', '14:00', '15:00', 25.00, 'pagado', 'Gato nervioso, se usó sedación leve'),
(3, 3, 1, '2025-01-14', '09:00', '10:30', 30.00, 'pagado', 'Pelo enredado, se realizó desenredado'),
(4, 2, 1, '2025-01-18', '11:00', '12:00', 20.00, 'pendiente', 'Servicio realizado, pago pendiente'),
(6, 1, 2, '2025-01-20', '15:00', '15:45', 15.00, 'pagado', 'Primera vez del cachorro en el baño'),
(7, 4, 2, '2025-01-22', '10:00', '11:00', 25.00, 'pagado', 'Sin complicaciones'),
(1, 6, 4, '2025-01-25', '13:00', '13:15', 5.00, 'pagado', 'Corte de uñas de rutina'),
(9, 1, 1, '2025-01-28', '16:00', '16:45', 15.00, 'pendiente', 'Cachorro juguetón'),
(10, 4, 2, '2025-01-30', '11:30', '12:30', 25.00, 'pagado', 'Gato tranquilo');
GO

-- =============================================
-- VERIFICACIÓN DE DATOS
-- =============================================

PRINT '==========================================';
PRINT 'RESUMEN DE DATOS INSERTADOS';
PRINT '==========================================';
PRINT 'Provincias: ' + CAST((SELECT COUNT(*) FROM PROVINCIAS) AS VARCHAR);
PRINT 'Ciudades: ' + CAST((SELECT COUNT(*) FROM CIUDADES) AS VARCHAR);
PRINT 'Clientes: ' + CAST((SELECT COUNT(*) FROM CLIENTES) AS VARCHAR);
PRINT 'Teléfonos: ' + CAST((SELECT COUNT(*) FROM TELEFONOS_CLIENTE) AS VARCHAR);
PRINT 'Especies: ' + CAST((SELECT COUNT(*) FROM ESPECIES) AS VARCHAR);
PRINT 'Razas: ' + CAST((SELECT COUNT(*) FROM RAZAS) AS VARCHAR);
PRINT 'Mascotas: ' + CAST((SELECT COUNT(*) FROM MASCOTAS) AS VARCHAR);
PRINT 'Especialidades: ' + CAST((SELECT COUNT(*) FROM ESPECIALIDADES) AS VARCHAR);
PRINT 'Veterinarios: ' + CAST((SELECT COUNT(*) FROM VETERINARIOS) AS VARCHAR);
PRINT 'Citas: ' + CAST((SELECT COUNT(*) FROM CITAS) AS VARCHAR);
PRINT 'Historiales Médicos: ' + CAST((SELECT COUNT(*) FROM HISTORIAL_MEDICO) AS VARCHAR);
PRINT 'Tratamientos: ' + CAST((SELECT COUNT(*) FROM TRATAMIENTOS) AS VARCHAR);
PRINT 'Medicamentos: ' + CAST((SELECT COUNT(*) FROM MEDICAMENTOS) AS VARCHAR);
PRINT 'Recetas: ' + CAST((SELECT COUNT(*) FROM MEDICAMENTOS_RECETADOS) AS VARCHAR);
PRINT 'Vacunas: ' + CAST((SELECT COUNT(*) FROM VACUNAS) AS VARCHAR);
PRINT 'Vacunas Aplicadas: ' + CAST((SELECT COUNT(*) FROM VACUNAS_APLICADAS) AS VARCHAR);
PRINT 'Servicios: ' + CAST((SELECT COUNT(*) FROM SERVICIOS) AS VARCHAR);
PRINT 'Empleados: ' + CAST((SELECT COUNT(*) FROM EMPLEADOS) AS VARCHAR);
PRINT 'Servicios Realizados: ' + CAST((SELECT COUNT(*) FROM SERVICIOS_REALIZADOS) AS VARCHAR);
PRINT '==========================================';
PRINT 'Datos de prueba insertados exitosamente!';
GO
