INSERT INTO public.departments
(id, created_at, available, updated_at, deleted_at, name, abreviation)
VALUES
(6, '2025-08-01 18:12:32.406255', true, '2025-08-01 18:12:32.406255', NULL, 'DIRECCIÓN GENERAL', 'DG'),
(7, '2025-08-01 18:14:50.577852', true, '2025-08-01 18:14:50.577852', NULL, 'TECNOLOGÍAS', 'TIC'),
(8, '2025-08-01 18:15:17.448954', true, '2025-08-01 18:15:17.448954', NULL, 'NORMATIVIDAD Y PROCESOS', 'N. Y P.'),
(9, '2025-08-01 18:24:16.999503', true, '2025-08-01 18:24:16.999503', NULL, 'FINANZAS', 'FINANC'),
(10, '2025-08-01 18:24:36.017659', true, '2025-08-01 18:24:36.017659', NULL, 'ADMINISTRACIÓN', 'ADMÓN'),
(11, '2025-08-01 18:24:53.452904', true, '2025-08-01 18:24:53.452904', NULL, 'OPERACIONES', 'OPS'),
(12, '2025-08-01 18:25:10.954077', true, '2025-08-01 18:25:10.954077', NULL, 'PROYECTOS', 'PROY');




INSERT INTO public.salary (id,created_at,available,updated_at,deleted_at,amount,salary_in_words) VALUES
	 (1,'2025-07-08 16:26:42.715',true,'2025-07-08 16:26:42.715',NULL,$25,000.00,'Veinticinco mil quinientos'),
	 (2,'2025-07-08 16:26:12.236',true,'2025-07-08 16:26:12.236',NULL,$8,500.00,'Ocho mil quinientos'),
	 (3,'2025-07-08 16:28:07.681',true,'2025-07-08 16:28:07.681',NULL,$18,000.00,'Dieciocho mil'),
	 (4,'2025-07-08 17:02:03.580',true,'2025-07-08 17:02:03.580',NULL,$15,000.00,'Quince mil'),
	 (5,'2025-08-01 17:12:36.142',true,'2025-08-01 17:12:36.142',NULL,$40,000.00,'Cuarenta mil'),
	 (6,'2025-08-01 17:14:31.163',true,'2025-08-01 17:14:31.163',NULL,$20,000.00,'Veinte mil'),
	 (7,'2025-08-01 18:26:36.281',true,'2025-08-01 18:26:36.281',NULL,$50,000.00,'Cincuenta mil'),
	 (9,'2025-08-01 18:43:11.247',true,'2025-08-01 18:43:11.247',NULL,$30,000.00,'Treinta mil');



INSERT INTO public.positions (id,created_at,available,updated_at,deleted_at,"requiredBoss","name",salary_id,department_id,"parentId") VALUES
	 (37,'2025-08-04 17:05:01.235',true,'2025-08-04 17:05:01.235',NULL,false,'Director general',7,6,NULL),
	 (38,'2025-08-04 17:05:39.564',true,'2025-08-04 17:05:39.564',NULL,false,'Coordinador de normatividad y procesos',5,8,NULL),
	 (39,'2025-08-04 17:05:57.21',true,'2025-08-04 17:05:57.21',NULL,false,'Director de tecnologías',5,7,NULL),
	 (40,'2025-08-04 17:06:11.61',true,'2025-08-04 17:06:11.61',NULL,false,'Director de finanzas',5,9,NULL),
	 (41,'2025-08-04 17:06:25.032',true,'2025-08-04 17:06:25.032',NULL,false,'Director de administración',5,10,NULL),
	 (42,'2025-08-04 17:06:39.325',true,'2025-08-04 17:06:39.325',NULL,false,'Director de operaciones',5,11,NULL),
	 (43,'2025-08-04 17:06:55.746',true,'2025-08-04 17:06:55.746',NULL,false,'Director de proyectos',5,12,NULL),
	 (44,'2025-08-04 17:07:40.524',true,'2025-08-04 17:07:40.524',NULL,false,'Coordinación de soporte técnico',9,7,39),
	 (45,'2025-08-04 17:08:14.616',true,'2025-08-04 17:08:14.616',NULL,false,'Coordinación de desarrollo de infraestructura tecnologíca',9,7,39),
	 (46,'2025-08-04 17:09:28.54',true,'2025-08-04 17:09:28.54',NULL,false,'Coordinación de contabilidad y finanzas',9,9,40),
	 (47,'2025-08-04 17:09:45.047',true,'2025-08-04 17:09:45.047',NULL,false,'Coordinador general de administración',9,10,41),
	 (48,'2025-08-04 17:10:20.116',true,'2025-08-04 17:10:20.116',NULL,false,'Coordinación general de operaciones',9,11,42),
	 (49,'2025-08-04 19:34:50.372',true,'2025-08-04 19:34:50.372',NULL,false,'Coordinación de proyectos',9,12,43),
	 (50,'2025-08-04 19:41:43.34',true,'2025-08-04 19:41:43.34',NULL,false,'Coordinación de recursos humanos',9,10,47),
	 (51,'2025-08-04 19:42:00.065',true,'2025-08-04 19:42:00.065',NULL,false,'Coordinación de recursos materiales y servicios generales',9,10,47),
	 (52,'2025-08-04 19:42:28.457',true,'2025-08-04 19:42:28.457',NULL,true,'Coordinación de preparación documental',1,11,48),
	 (53,'2025-08-04 19:42:32.299',true,'2025-08-04 19:42:32.299',NULL,true,'Coordinación de transformación digital',1,11,48),
	 (54,'2025-08-04 19:42:41.716',true,'2025-08-04 19:42:41.716',NULL,true,'Coordinación de calidad',1,11,48),
	 (55,'2025-08-04 19:42:50.844',true,'2025-08-04 19:42:50.844',NULL,true,'Coordinación de captura',1,11,48),
	 (56,'2025-09-13 18:34:39.876579',true,'2025-09-13 18:34:39.876579',NULL,true,'Digitalizador',3,11,53),
	 (57,'2025-09-13 18:36:19.374039',true,'2025-09-13 18:36:19.374039',NULL,true,'Capturista',2,11,55),
	 (58,'2025-09-13 18:39:42.938599',true,'2025-09-13 18:39:42.938599',NULL,true,'Preparador',2,11,52),
	 (59,'2025-09-13 18:40:33.100373',true,'2025-09-13 18:40:33.100373',NULL,true,'Calidad',3,11,54),
	 (60,'2025-09-13 18:59:32.036843',true,'2025-09-13 18:59:32.036843',NULL,true,'Desarrollador',3,7,45),
	 (61,'2025-09-13 18:59:32.044539',true,'2025-09-13 18:59:32.044539',NULL,true,'Soporte',3,7,44);

INSERT INTO public.positions_closure (id_ancestor,id_descendant) VALUES
    (37,37),
    (38,38),
    (39,39),
    (40,40),
    (41,41),
    (42,42),
    (43,43),
    (44,44),
    (39,44),
    (45,45),
    (39,45),
    (46,46),
    (40,46),
    (47,47),
    (41,47),
    (48,48),
    (42,48),
    (49,49),
    (43,49),
    (50,50),
    (47,50),
    (41,50),
    (51,51),
    (47,51),
    (41,51),
    (52,52),
    (48,52),
    (42,52),
    (53,53),
    (48,53),
    (42,53),
    (54,54),
    (48,54),
    (42,54),
    (55,55),
    (48,55),
    (42,55);


INSERT INTO public.type_contract
(id, created_at, available, updated_at, deleted_at, type, "isAutomatic")
VALUES
(3, '2025-07-10 12:44:07.499346', true, '2025-07-10 12:44:07.499346', NULL, 'Por obra y tiempo determinado', false),
(1, '2025-07-10 12:44:07.484868', true, '2025-07-10 12:44:07.484868', NULL, 'Indeterminado', true),
(2, '2025-07-10 12:44:07.490992', true, '2025-07-10 12:44:07.490992', NULL, 'Sueldos y salarios asimilados', true);

INSERT INTO public.banks
(id, created_at, available, updated_at, deleted_at, name)
VALUES
(1, '2025-07-08 16:23:53.602', true, '2025-07-08 16:23:53.602', NULL, 'BANORTE'),
(2, '2025-07-08 16:23:57.784', true, '2025-07-08 16:23:57.784', NULL, 'HSBC'),
(3, '2025-07-08 16:24:09.764', true, '2025-07-08 16:24:09.764', NULL, 'BANAMEX'),
(4, '2025-07-08 16:24:15.642', true, '2025-07-08 16:24:15.642', NULL, 'BBVA');

INSERT INTO public.types_bonds (id,created_at,available,updated_at,deleted_at,"type") VALUES
	(1,'2025-09-18 14:27:52.219',true,'2025-09-18 14:27:52.219',NULL,'Bono por Proyecto.'),
	(2,'2025-09-18 14:27:52.225',true,'2025-09-18 14:27:52.225',NULL,'Bono Indefinido.'),
	(3,'2025-09-18 14:27:52.227',true,'2025-09-18 14:27:52.227',NULL,'Bono Temporal.'),
	(4,'2025-09-18 14:27:52.230',true,'2025-09-18 14:27:52.230',NULL,'Ajuste de Salario.');

INSERT INTO public.description_bonds (id,created_at,available,updated_at,deleted_at,description) VALUES
	(1,'2025-09-18 14:27:09.704',true,'2025-09-18 14:27:09.704',NULL,'Bono de actuación.'),
	(2,'2025-09-18 14:27:20.297',true,'2025-09-18 14:27:20.297',NULL,'Ajuste Salarial.');


INSERT INTO public.employees
(id, created_at, available, updated_at, deleted_at, date_register, names, first_last_name, second_last_name, date_birth, year_old, email, telephone, address, gender, curp, rfc, nss, ine_number, alergy, emergency_contact, nacionality, status, blood_type, status_civil, number_account_bank, "bankId", "typeContractId")
VALUES
(1, '2025-07-08 16:45:19.77', true, '2025-07-08 16:45:19.77', NULL, '2020-04-25', 'Alberto', 'Vincenso', 'Casano', '1997-10-15', 27, 'albertovc@cts.com', '555-1234-5678', 'Calle ficticia 123, ciudad, estado', 'Masculino', 'PEJ90515HDFGRR0', 'PEJJ9012151F9', '12345678901', 'A1234567890', 'Ninguna', '[{"name":"Jhon Doe","relationship":"Padre","phone":"+525598765431"}]', 'Mexicana', 'ACTIVE', 'O+', 'Soltero/a', '123456789123456', 2, 3),
(2, '2025-07-08 16:47:00.092', true, '2025-07-08 16:47:00.092', NULL, '2021-07-12', 'Carlos', 'González', 'Ramírez', '1993-03-22', 31, 'carlosgr@cts.com', '555-9876-5432', 'Av. reforma 456, ciudad, estado', 'Masculino', 'GORA930322HDFNRR5', 'GORA9303221I8', '98765432101', 'B2345678901', 'Pollen', '[{"name":"María González","relationship":"Madre","phone":"+525558765432"}]', 'Mexicana', 'ACTIVE', 'A+', 'Casado/a', '234567890123456', 3, 2),
(3, '2025-07-08 16:47:13.814', true, '2025-07-08 16:47:13.814', NULL, '2019-11-05', 'María', 'Sánchez', 'Pérez', '1990-07-30', 34, 'marias@cts.com', '555-3456-7890', 'Calle libertad 789, ciudad, estado', 'Femenino', 'SAPE900730MDFRRS9', 'SAPE9007302H7', '45678901234', 'C3456789012', 'Gluten', '[{"name":"Ana Sánchez","relationship":"Hermana","phone":"+525512345678"}]', 'Mexicana', 'INACTIVE', 'B-', 'Divorciado/a', '345678901234567', 1, 1),
(4, '2025-07-08 16:47:59.287', true, '2025-07-08 16:47:59.287', NULL, '2022-02-18', 'Ana', 'Morales', 'Torres', '1995-09-10', 29, 'anam@cts.com', '555-5678-1234', 'Paseo de la reforma 101, ciudad, estado', 'Femenino', 'MOTA950910MDFRRR2', 'MOTA9509103C7', '65432109876', 'D4567890123', 'Lactosa', '[{"name":"Luis Morales","relationship":"Esposo","phone":"+525589876543"}]', 'Mexicana', 'ACTIVE', 'AB+', 'Casado/a', '456789012345678', 2, 3),
(5, '2025-07-08 16:49:07.287', true, '2025-07-08 16:49:07.287', NULL, '2023-01-14', 'Luis', 'Martínez', 'Gómez', '1988-11-02', 36, 'luism@cts.com', '555-8765-4321', 'Calle mayor 12, ciudad, estado', 'Masculino', 'MAGO881102HDFMNR6', 'MAGO8811022E5', '76543210987', 'E5678901234', 'Ninguna', '[{"name":"Laura Martínez","relationship":"Hermana","phone":"+525597654321"}]', 'Mexicana', 'ACTIVE', 'O-', 'Soltero/a', '567890123456789', 3, 2),
(6, '2025-07-08 16:49:21.799', true, '2025-07-08 16:49:21.799', NULL, '2023-05-09', 'Juan', 'Hernández', 'López', '2000-12-18', 24, 'juanh@cts.com', '555-2345-6789', 'Calle del sol 345, ciudad, estado', 'Masculino', 'HELO001218HDFNNN3', 'HELO0012181D6', '23456789012', 'F6789012345', 'Cacahuates', '[{"name":"Pedro Hernández","relationship":"Padre","phone":"+525511234567"}]', 'Mexicana', 'ACTIVE', 'O+', 'Soltero/a', '678901234567890', 1, 1),
(21, '2025-07-15 17:59:40.083446', true, '2025-07-15 17:59:40.083446', NULL, '2021-07-12', 'Carl', 'First', 'Second', '1993-03-22', 31, 'correo@hotmail.com', '555-9876-5432', 'Av. reforma 456, ciudad, estado', 'Masculino', 'GORA930322HDFNRR5', 'GORA9303221I8', '98765432101', 'B2345678901', 'Pollen', '[{"name":"María González","relationship":"Madre","phone":"+525558765432"}]', 'Mexicana', 'ACTIVE', 'A+', 'Casado/a', '234567890123456', 3, 2),
(18, '2025-07-14 19:29:18.803379', true, '2025-07-30 20:59:29.917992', NULL, '2023-05-19', 'Juan', 'Hernández', 'López', '2000-12-18', 24, 'juanh@google.com', '555-2345-6789', 'Calle del sol 345, ciudad, estado', 'Masculino', 'HELO001218HDFNNN3', 'HELO0012181D6', '23456789012', 'F6789012345', 'Cacahuates', '[{"name":"Pedro Hernández","relationship":"Padre","phone":"+525511234567"}]', 'Mexicana', 'ACTIVE', 'O+', 'Soltero/a', '678901234567890', 1, 1),
(22, '2025-07-31 15:42:59.996617', true, '2025-07-31 15:42:59.996617', NULL, '2025-07-30', 'Juan carlos', 'Ramírez', 'López', '1990-05-14', 35, 'juan.ramirez@example.com', '+5215512345678', 'Av. reforma 123, col. centro, cdmx', 'Masculino', 'RALJ900514HDFMPN01', 'RALJ900514ABC', '98765432100', '0100020003004', 'Ninguna', '[{"name":"María Ramírez","relationship":"Hermana","phone":"+525511122233"}]', 'Mexicana', 'ACTIVE', 'A+', 'Casado/a', '123456789012345678', 3, 1);

-- Tabla type_document
INSERT INTO public.type_document
(id, created_at, available, updated_at, deleted_at, type)
VALUES
(1, '2025-07-08 16:33:09.112', true, '2025-07-08 16:33:09.112', NULL, 'NSS'),
(2, '2025-07-08 16:33:14.595', true, '2025-07-08 16:33:14.595', NULL, 'RFC'),
(3, '2025-07-08 16:33:18.478', true, '2025-07-08 16:33:18.478', NULL, 'INE'),
(4, '2025-07-08 16:33:29.3', true, '2025-07-08 16:33:29.3', NULL, 'ACTA DE NACIMIENTO'),
(5, '2025-07-08 16:36:38.621', true, '2025-07-08 16:36:38.621', NULL, 'COMPROBANTE DE DOMICILIO');


INSERT INTO public.employee_has_positions
(id, created_at, available, updated_at, deleted_at, "employeeIdId", "positionIdId")
VALUES
(35, '2025-08-05 12:56:27.72011', true, '2025-08-05 12:56:27.72011', NULL, 1, 37),
(36, '2025-08-05 12:57:00.658405', true, '2025-08-05 12:57:00.658405', NULL, 2, 48),
(39, '2025-08-05 12:57:58.788179', true, '2025-08-05 12:57:58.788179', NULL, 5, 52),
(40, '2025-08-05 12:57:58.793591', true, '2025-08-05 12:57:58.793591', NULL, 6, 53),
(41, '2025-08-05 12:58:18.226057', true, '2025-08-05 12:58:18.226057', NULL, 18, 54),
(42, '2025-08-05 12:58:33.334809', true, '2025-08-05 12:58:33.334809', NULL, 21, 55),
(44, '2025-08-05 12:58:45.481632', true, '2025-08-05 12:58:45.481632', NULL, 22, 57),
(37, '2025-08-05 12:57:07.109638', true, '2025-08-05 12:57:07.109638', NULL, 3, 52),
(38, '2025-08-05 12:57:12.945889', true, '2025-08-05 12:57:12.945889', NULL, 4, 53);

INSERT INTO public.projects
(id, created_at, available, updated_at, deleted_at, contract_number, name, description, start_date, end_date, number_expedients, number_images, productions_days, sum_productions, status, "isExternal")
VALUES
(2, '2025-07-22 18:55:09.696641', true, '2025-07-22 18:55:09.696641', NULL, '0198329012839102', 'Prueba de proyecto grande', 'Proyecto mas poderoso', '2025-07-04', '2025-07-25', 12, 0, 12, 12, 'EVALUATION', false),
(3, '2025-07-22 19:04:39.863', true, '2025-07-22 19:04:39.863', NULL, '0198329012839102', 'Prueba de proyecto grande', 'Proyecto mas poderoso', '2025-07-05', '2025-07-26', 12, 0, 12, 12, 'EVALUATION', false),
(4, '2025-07-22 19:06:03.541', true, '2025-07-22 19:06:03.541', NULL, '0198329012839102', 'Prueba de proyecto grande', 'Proyecto mas poderoso', '2025-07-05', '2025-07-26', 12, 0, 12, 12, 'EVALUATION', false),
(5, '2025-07-23 18:06:25.589714', true, '2025-07-23 18:06:25.589714', NULL, '0198329012839102', 'Prueba de proyecto grande', 'Proyecto mas poderoso', '2025-07-04', '2025-07-25', 12, 0, 12, 12, 'EVALUATION', false),
(6, '2025-07-23 18:08:19.799702', true, '2025-07-23 18:08:19.799702', NULL, '12ZWM1231', 'Proyecto', 'Descripción del proyecto', '2025-07-04', '2025-12-01', 12000, 0, 1200, 12000, 'EVALUATION', false),
(7, '2025-07-25 23:11:21.819', true, '2025-07-25 23:11:21.819', NULL, '12ZWM1231', 'Proyecto', 'Descripción del proyecto', '2025-07-04', '2025-12-01', 12000, 0, 1200, 12000, 'EVALUATION', false),
(8, '2025-07-31 16:31:55.691', true, '2025-07-31 16:31:55.691', NULL, 'CT-2025-0012', 'Contrato de servicios audiovisuales', 'Contrato para la producción de material audiovisual para campañas institucionales.', '2025-07-31', '2025-12-30', 10000, 100000, 8000, 100000, 'ACTIVE', false),
(9, '2025-07-22 19:04:39.863', true, '2025-07-22 19:04:39.863', NULL, '0198329012839102', 'Prueba de proyecto grande', 'Proyecto mas poderoso', '2025-07-05', '2025-07-26', 12, 0, 12, 12, 'EVALUATION', false),
(10, '2025-07-22 19:06:03.541', true, '2025-07-22 19:06:03.541', NULL, '0198329012839102', 'Prueba de proyecto grande', 'Proyecto mas poderoso', '2025-07-05', '2025-07-26', 12, 0, 12, 12, 'EVALUATION', false),
(11, '2025-07-22 19:04:39.863', true, '2025-07-22 19:04:39.863', NULL, '0198329012839102', 'Prueba de proyecto grande', 'Proyecto mas poderoso', '2025-07-05', '2025-07-26', 12, 0, 12, 12, 'EVALUATION', false),
(12, '2025-07-22 19:06:03.541', true, '2025-07-22 19:06:03.541', NULL, '0198329012839102', 'Prueba de proyecto grande', 'Proyecto mas poderoso', '2025-07-05', '2025-07-26', 12, 0, 12, 12, 'EVALUATION', false),
(1, '2025-07-22 18:47:54.909169', true, '2025-07-22 18:47:54.909169', NULL, '0198329012839102', 'Prueba de proyecto grande', 'Proyecto mas poderoso', '2025-07-04', '2025-12-25', 12, 0, 1200, 12000, 'EVALUATION', true);

INSERT INTO public.extension
(id, created_at, available, updated_at, deleted_at, number_expedients, start_date, end_date, "projectId")
VALUES
(3, '2025-07-31 18:47:53.61', true, '2025-07-31 18:47:53.61', NULL, 5000, '2026-01-06', '2026-03-14', 8);

INSERT INTO public.headquarters
(id, created_at, available, updated_at, deleted_at, name, address, city, postal_code, phone, production_days, number_expedients, sum_productions, status, "projectId", start_date, end_date)
VALUES
(9, '2025-07-28 21:02:35.347949', true, '2025-07-28 21:02:35.347949', NULL, 'Tecnologias de la informacion y comunicacion', 'Ciudad de mexico', 'Mexico', '07877', '+525539039231', 3, 4, 2, 'EVALUATION', 1, '2025-07-11', '2025-07-21'),
(8, '2025-07-28 16:28:01.275803', true, '2025-07-30 21:17:28.95827', NULL, 'Company def actualizada', '62413 industrial park', 'Metropolis', '06500', '+529933234290', 6000, 6000, 6000, 'ACTIVE', 1, '2025-07-04', '2025-11-30'),
(10, '2025-07-31 16:37:38.947925', true, '2025-07-31 16:37:38.947925', NULL, 'Planta de producción norte', 'Carretera federal 45 km 12, parque industrial la luz', 'León', '37207', '+524777001122', 90, 4000, 4000, 'ACTIVE', 8, '2025-08-04', '2025-12-19'),
(11, '2025-07-31 16:40:56.939869', true, '2025-07-31 16:40:56.939869', NULL, 'Planta de producción sur', 'Av. tecnológico 200, parque industrial innovación', 'Querétaro', '76159', '+524422223344', 120, 6000, 6000, 'ACTIVE', 8, '2025-07-31', '2025-12-30');

INSERT INTO public.headquarters_position_quota
(id, created_at, available, updated_at, deleted_at, max_employee, position_id, "headquartersId")
VALUES
(19, '2025-07-30 16:29:57.613746', true, '2025-07-30 16:29:57.613746', NULL, 6, 4, 8),
(15, '2025-07-28 16:28:01.275', true, '2025-07-28 16:28:01.275', NULL, 18, 1, 8),
(14, '2025-07-28 16:28:01.275', true, '2025-07-28 16:28:01.275', NULL, 2, 2, 8),
(23, '2025-07-31 16:40:56.939869', true, '2025-07-31 16:40:56.939869', NULL, 1, 2, 11),
(24, '2025-07-31 16:40:56.939869', true, '2025-07-31 16:40:56.939869', NULL, 10, 1, 11),
(16, '2025-07-28 21:02:35.347949', true, '2025-07-28 21:02:35.347949', NULL, 1, 48, 9),
(17, '2025-07-28 21:02:35.347949', true, '2025-07-28 21:02:35.347949', NULL, 1, 52, 9),
(20, '2025-07-31 16:37:38.947925', true, '2025-07-31 16:37:38.947925', NULL, 1, 53, 9),
(21, '2025-07-31 16:37:38.947925', true, '2025-07-31 16:37:38.947925', NULL, 1, 54, 9),
(22, '2025-07-31 16:37:38.947925', true, '2025-07-31 16:37:38.947925', NULL, 1, 55, 9);

INSERT INTO public.staff
(id, created_at, available, updated_at, deleted_at, "employeeHasPositionsId", "headquarterId", "parentId")
VALUES
(36, '2025-08-15 21:32:47.596036', true, '2025-08-15 21:32:47.596036', NULL, 36, 9, NULL),
(40, '2025-08-15 22:05:37.974444', true, '2025-08-15 22:08:30.705432', NULL, 37, 9, 36);

INSERT INTO public.staff_closure
(id_ancestor, id_descendant)
VALUES
(36, 36),
(40, 40),
(36, 40);


INSERT INTO public.profiles
(id, created_at, available, updated_at, deleted_at, name, saved)
VALUES
(1, '2025-07-10 23:56:58.814556', true, '2025-07-10 23:56:58.814556', NULL, 'Admin - rh', true),
(4, '2025-07-11 17:16:26.874194', true, '2025-07-11 17:16:26.874194', NULL, 'Admin - rh', true),
(3, '2025-07-11 17:11:28.382098', true, '2025-07-11 18:28:18.453003', NULL, 'Admin', true),
(5, '2025-07-15 17:25:03.426851', true, '2025-07-15 17:25:03.426851', NULL, 'Profile admin-dev', true);

INSERT INTO public.role
(id, created_at, available, updated_at, deleted_at, type)
VALUES
(1, '2025-07-10 19:49:45.046242', true, '2025-07-10 19:49:45.046242', NULL, 'Administrador'),
(2, '2025-07-10 19:49:52.754431', true, '2025-07-10 19:49:52.754431', NULL, 'Usuario'),
(3, '2025-07-10 19:49:57.659557', true, '2025-07-10 19:49:57.659557', NULL, 'Capturista'),
(4, '2025-07-10 19:50:07.260546', true, '2025-07-10 19:50:07.260546', NULL, 'Superusuario'),
(5, '2025-07-15 17:36:37.391773', true, '2025-07-15 17:36:37.391773', NULL, 'User');

INSERT INTO public.module
(id, created_at, available, updated_at, deleted_at, name, description)
VALUES
(1, '2025-07-10 19:50:26.327627', true, '2025-07-10 19:50:26.327627', NULL, 'Empleados', NULL),
(2, '2025-07-10 19:50:36.354908', true, '2025-07-10 19:50:36.354908', NULL, 'Puestos y salarios', NULL),
(3, '2025-07-10 19:50:45.988002', true, '2025-07-10 19:50:45.988002', NULL, 'Departamentos', NULL),
(4, '2025-07-10 19:51:24.33179', true, '2025-07-10 19:51:24.33179', NULL, 'Empleados-posiciones', NULL),
(5, '2025-07-15 16:26:04.109', true, '2025-07-15 16:27:43.728242', NULL, 'Administración general', 'Configuración genral del sistema');

INSERT INTO public.permission
(id, created_at, available, updated_at, deleted_at, name, description)
VALUES
(1, '2025-07-10 21:09:47.887187', true, '2025-07-10 21:09:47.887187', NULL, 'created', 'Permite crear nuevos registros en el sistema'),
(2, '2025-07-10 21:10:05.01415', true, '2025-07-10 21:10:05.01415', NULL, 'edit', 'Permite editar los registros en el sistema'),
(3, '2025-07-10 21:10:20.842173', true, '2025-07-10 21:10:20.842173', NULL, 'view', 'Permite ver registros del sistema'),
(4, '2025-07-10 21:10:36.718198', true, '2025-07-10 21:10:36.718198', NULL, 'delete', NULL),
(5, '2025-07-10 21:11:33.999', true, '2025-07-10 21:11:33.999', NULL, 'asigned', NULL),
(6, '2025-07-15 16:17:36.773', true, '2025-07-15 16:24:56.523295', NULL, 'prueba dev', 'Permiso de prueba para dev');

INSERT INTO public."permission_has_module"
(id, created_at, available, updated_at, deleted_at, "permissionId", "moduleId")
VALUES
(1, '2025-07-10 23:56:58.814556', true, '2025-07-10 23:56:58.814556', NULL, 1, 1),
(2, '2025-07-10 23:56:58.814556', true, '2025-07-10 23:56:58.814556', NULL, 4, 1),
(24, '2025-07-11 16:48:39.313524', true, '2025-07-11 16:48:39.313524', NULL, 2, 1),
(25, '2025-07-11 17:11:28.382098', true, '2025-07-11 17:11:28.382098', NULL, 2, 2),
(26, '2025-07-11 17:11:28.382098', true, '2025-07-11 17:11:28.382098', NULL, 3, 2),
(29, '2025-07-15 17:24:21.784432', true, '2025-07-15 17:24:21.784432', NULL, 4, 2),
(30, '2025-07-15 17:24:21.790981', true, '2025-07-15 17:24:21.790981', NULL, 5, 2),
(31, '2025-07-15 17:24:21.794409', true, '2025-07-15 17:24:21.794409', NULL, 6, 2),
(40, '2025-07-15 17:25:03.426851', true, '2025-07-15 17:25:03.426851', NULL, 3, 1),
(41, '2025-07-15 17:25:03.426851', true, '2025-07-15 17:25:03.426851', NULL, 5, 1),
(42, '2025-07-15 17:25:03.426851', true, '2025-07-15 17:25:03.426851', NULL, 6, 1),
(32, '2025-07-15 17:25:03.426851', true, '2025-07-15 17:25:03.426851', NULL, 1, 2),
(34, '2025-07-15 17:25:03.426851', true, '2025-07-15 17:25:03.426851', NULL, 1, 3),
(37, '2025-07-15 17:25:03.426851', true, '2025-07-15 17:25:03.426851', NULL, 2, 3),
(38, '2025-07-15 17:25:03.426851', true, '2025-07-15 17:25:03.426851', NULL, 3, 3),
(35, '2025-07-15 17:25:03.426851', true, '2025-07-15 17:25:03.426851', NULL, 4, 3),
(36, '2025-07-15 17:25:03.426851', true, '2025-07-15 17:25:03.426851', NULL, 5, 3),
(39, '2025-07-15 17:25:03.426851', true, '2025-07-15 17:25:03.426851', NULL, 6, 3),
(33, '2025-07-15 17:25:03.426851', true, '2025-07-15 17:25:03.426851', NULL, 1, 4),
(44, '2025-07-15 17:25:03.426851', true, '2025-07-15 17:25:03.426851', NULL, 2, 4),
(46, '2025-07-15 17:25:03.426851', true, '2025-07-15 17:25:03.426851', NULL, 3, 4),
(47, '2025-07-15 17:25:03.426851', true, '2025-07-15 17:25:03.426851', NULL, 4, 4),
(43, '2025-07-15 17:25:03.426851', true, '2025-07-15 17:25:03.426851', NULL, 5, 4),
(45, '2025-07-15 17:25:03.426851', true, '2025-07-15 17:25:03.426851', NULL, 6, 4);


INSERT INTO public.users
(id, created_at, available, updated_at, deleted_at, username, password, "roleId", "profileId")
VALUES
(9, '2025-07-31 19:43:55.171', true, '2025-07-31 19:43:55.171', NULL, 'juan carlos ramírez lópez', '$2b$10$MOEfypBwKkz978wT8EtlMeGn32ftEStkrIPGi502ohYc36Q51lALS', 1, 1),
(6, '2025-07-16 17:58:53.885', true, '2025-07-16 17:58:53.885', NULL, 'juan hernández lópez', '$2b$10$cc60UUvV6GIncjJxVVsJM.rbNkyhWe28.8hkqiWHwElHhxybkOW1G', NULL, NULL);

INSERT INTO public.emails
(id, created_at, available, updated_at, deleted_at, email, status, user_id, employee_id, required_access)
VALUES
(5, '2025-07-14 19:29:18.803379', true, '2025-07-16 17:58:53.885291', NULL, 'adan.imh@gmail.com', false, 6, 18, true),
(7, '2025-07-15 17:59:40.083446', true, '2025-07-15 18:02:13.022099', NULL, 'carl.fs@centrodetecnologias.com.mx', false, NULL, 21, true),
(8, '2025-07-31 15:42:59.996617', true, '2025-07-31 19:43:55.171354', NULL, 'adan@centrodetecnologias.com.mx', false, 9, 22, true);
