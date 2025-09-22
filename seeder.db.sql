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


INSERT INTO public.employees (id, created_at, available, updated_at, deleted_at, names, first_last_name, second_last_name, date_birth, year_old, gender, curp, rfc, nss, ine_number, alergy, nacionality, status, blood_type) VALUES
(3,'2025-07-08 16:47:13.814',true,'2025-07-08 16:47:13.814',NULL,'María','Sánchez','Pérez','1990-07-30',34,'Femenino','SAPE900730MDFRRS9','SAPE9007302H7','45678901234','C3456789012','Gluten','Mexicana','INACTIVE','B-'),
(5,'2025-07-08 16:49:07.287',true,'2025-07-08 16:49:07.287',NULL,'Luis','Martínez','Gómez','1988-11-02',36,'Masculino','MAGO881102HDFMNR6','MAGO8811022E5','76543210987','E5678901234','Ninguna','Mexicana','ACTIVE','O-'),
(6,'2025-07-08 16:49:21.799',true,'2025-07-08 16:49:21.799',NULL,'Juan','Hernández','López','2000-12-18',24,'Masculino','HELO001218HDFNNN3','HELO0012181D6','23456789012','F6789012345','Cacahuates','Mexicana','ACTIVE','O+'),
(7,'2025-07-15 17:59:40.083446',true,'2025-07-15 17:59:40.083446',NULL,'Carl','First','Second','1993-03-22',31,'Masculino','GORA930322HDFNRR5','GORA9303221I8','98765432101','B2345678901','Pollen','Mexicana','ACTIVE','A+'),
(1,'2025-07-08 16:45:19.77',true,'2025-07-08 16:45:19.77',NULL,'Alberto','Vincenso','Casano','1997-10-15',27,'Masculino','PEJ90515HDFGRR0','PEJJ9012151F9','12345678901','A1234567890','Ninguna','Mexicana','ACTIVE','O+'),
(2,'2025-07-08 16:47:00.092',true,'2025-07-08 16:47:00.092',NULL,'Carlos','González','Ramírez','1993-03-22',31,'Masculino','GORA930322HDFNRR5','GORA9303221I8','98765432101','B2345678901','Pollen','Mexicana','ACTIVE','A+'),
(8,'2025-07-14 19:29:18.803379',true,'2025-07-30 20:59:29.917992',NULL,'Juan','Hernández','López','2000-12-18',24,'Masculino','HELO001218HDFNNN3','HELO0012181D6','23456789012','F6789012345','Cacahuates','Mexicana','ACTIVE','O+'),
(9,'2025-07-31 15:42:59.996617',true,'2025-07-31 15:42:59.996617',NULL,'Juan carlos','Ramírez','López','1990-05-14',35,'Masculino','RALJ900514HDFMPN01','RALJ900514ABC','98765432100','0100020003004','Ninguna','Mexicana','ACTIVE','A+'),
(4,'2025-07-08 16:47:59.287',true,'2025-07-08 16:47:59.287',NULL,'Ana','Morales','Torres','1995-09-10',29,'Femenino','MOTA950910MDFRRR2','MOTA9509103C7','65432109876','D4567890123','Lactosa','Mexicana','ACTIVE','AB+'),
(10,'2025-07-09 09:15:23',true,'2025-07-09 09:15:23',NULL,'Laura','Mendoza','Salinas','1989-05-12',36,'Femenino','MESL890512MPLNRL6','MESL8905123A2','34567890123','C3456789012','Penicilina','Mexicana','ACTIVE','B+'),
(11,'2025-07-09 10:02:45',true,'2025-07-09 10:02:45',NULL,'José','Martínez','Lozano','1990-08-30',35,'Masculino','MALJ900830HDFRZS3','MALJ9008304K3','45678901234','D4567890123','Ninguna','Mexicana','ACTIVE','O-'),
(12,'2025-07-10 08:30:10',true,'2025-07-10 08:30:10',NULL,'Paola','Hernández','Ruiz','1995-01-18',30,'Femenino','HERP950118MDFRZL5','HERP9501187Z8','56789012345','E5678901234','Mariscos','Mexicana','ACTIVE','AB+'),
(13,'2025-07-10 09:55:45',true,'2025-07-10 09:55:45',NULL,'Luis','Torres','Gómez','1985-09-14',40,'Masculino','TOGL850914HJCMSL2','TOGL8509149T1','67890123456','F6789012345','Lácteos','Mexicana','ACTIVE','A-'),
(14,'2025-07-11 11:22:33',true,'2025-07-11 11:22:33',NULL,'María','López','Valdez','1998-02-25',27,'Femenino','LOVM980225GGTPLR1','LOVM9802253A5','78901234567','G7890123456','Ninguna','Mexicana','ACTIVE','O+'),
(15,'2025-07-11 13:40:19',true,'2025-07-11 13:40:19',NULL,'Fernando','Ramírez','Zavala','1992-06-10',33,'Masculino','RAZF920610HDFMNR3','RAZF9206106P2','89012345678','H8901234567','Picaduras de abeja','Mexicana','ACTIVE','B-'),
(16,'2025-07-12 08:18:55',true,'2025-07-12 08:18:55',NULL,'Sandra','Navarro','Esquivel','1988-11-05',36,'Femenino','NAES881105NLNSNR7','NAES8811059W3','90123456789','I9012345678','Gluten','Mexicana','ACTIVE','A+'),
(17,'2025-07-13 15:47:12',true,'2025-07-13 15:47:12',NULL,'Ricardo','Sánchez','Pineda','1996-04-08',29,'Masculino','SAPR960408HQTRND1','SAPR9604081M6','91234567890','J9123456789','Ninguna','Mexicana','ACTIVE','O-'),
(18,'2025-07-13 17:05:30',true,'2025-07-13 17:05:30',NULL,'Daniela','Vega','Montiel','1994-12-03',30,'Femenino','VEMD941203MDFNRN3','VEMD9412032Q9','92345678901','K9234567890','Ninguna','Mexicana','ACTIVE','AB-'),
(19,'2025-07-14 09:30:00',true,'2025-07-14 09:30:00',NULL,'Héctor','Cruz','Delgado','1987-07-22',38,'Masculino','CUDH870722YCTRRD2','CUDH8707227H7','93456789012','L9345678901','Polvo','Mexicana','ACTIVE','B+'),
(20,'2025-09-12 10:15:00',true,'2025-09-12 10:15:00',NULL,'Isabel','Durán','Molina','1992-06-01',33,'Femenino','DUMI920601MDFRLS3','DUMI9206016Z3','12378945601','M1237894560','Ninguna','Mexicana','ACTIVE','O+'),
(21,'2025-09-12 10:20:00',true,'2025-09-12 10:20:00',NULL,'Gerardo','Vargas','Nieto','1990-11-17',34,'Masculino','VANG901117HTLRTR1','VANG9011172P1','23456789012','N2345678901','Aspirina','Mexicana','ACTIVE','A+'),
(22,'2025-09-12 10:25:00',true,'2025-09-12 10:25:00',NULL,'Tatiana','Gómez','Reyes','1988-03-11',37,'Femenino','GORT880311MDFRYS5','GORT8803117D4','34567890123','O3456789012','Ninguna','Mexicana','ACTIVE','B+'),
(23,'2025-09-12 10:30:00',true,'2025-09-12 10:30:00',NULL,'Iván','Pérez','Castillo','1995-12-19',29,'Masculino','PECI951219HSLRST3','PECI9512191F2','45678901234','P4567890123','Lácteos','Mexicana','ACTIVE','AB-'),
(24,'2025-09-12 10:35:00',true,'2025-09-12 10:35:00',NULL,'Camila','Ríos','Fernández','1999-01-07',26,'Femenino','RIFC990107MQTRMN8','RIFC9901079K6','56789012345','Q5678901234','Polvo','Mexicana','ACTIVE','O-'),
(88,'2025-09-16 10:11:43.01815',true,'2025-09-16 10:11:43.01815',NULL,'Laura','Gómez','Ramírez','1998-07-22',27,'Femenino','GORL980722MNLLMR07','GORL9807221H5','34567890123','G9012345678','Ninguna','Mexicana','ACTIVE','A+');

INSERT INTO public.employment_record
(id, created_at, available, updated_at, deleted_at, date_register, date_end, reason, comment, email, telephone, address, emergency_contact, status_civil, number_account_bank, type_contract_id, bank_id, "employeeId")
VALUES
(1,'2025-09-15 16:10:52.733005',true,'2025-09-15 16:10:52.733005',NULL,'2020-04-25',NULL,'a',NULL,'albertovc@cts.com','555-1234-5678','Calle ficticia 123, ciudad, estado','[{"name":"Jhon Doe","relationship":"Padre","phone":"+525598765431"}]'::jsonb,'Soltero/a','123456789123456',3,2,1),
(2,'2025-09-15 16:12:11.389193',true,'2025-09-15 16:12:11.389193',NULL,'2021-07-12',NULL,'a',NULL,'carlosgr@cts.com','555-9876-5432','Av. reforma 456, ciudad, estado','[{"name":"María González","relationship":"Madre","phone":"+525558765432"}]'::jsonb,'Casado/a','234567890123456',2,3,2),
(3,'2025-09-15 16:15:20.996325',true,'2025-09-15 16:15:20.996325',NULL,'2019-11-05',NULL,'a',NULL,'marias@cts.com','555-3456-7890','Calle libertad 789, ciudad, estado','[{"name":"Ana Sánchez","relationship":"Hermana","phone":"+525512345678"}]'::jsonb,'Divorciado/a','345678901234567',1,1,3),
(4,'2025-09-15 16:15:21.005341',true,'2025-09-15 16:15:21.005341',NULL,'2022-02-18',NULL,'a',NULL,'anam@cts.com','555-5678-1234','Paseo de la reforma 101, ciudad, estado','[{"name":"Luis Morales","relationship":"Esposo","phone":"+525589876543"}]'::jsonb,'Casado/a','456789012345678',3,2,4),
(5,'2025-09-15 16:17:03.890006',true,'2025-09-15 16:17:03.890006',NULL,'2023-01-14',NULL,'a',NULL,'luism@cts.com','555-8765-4321','Calle mayor 12, ciudad, estado','[{"name":"Laura Martínez","relationship":"Hermana","phone":"+525597654321"}]'::jsonb,'Soltero/a','567890123456789',2,3,5),
(6,'2025-09-15 16:20:01.100001',true,'2025-09-15 16:20:01.100001',NULL,'2020-01-15',NULL,'a',NULL,'correo6@cts.com','555-1000-0006','Calle Reforma 6, Ciudad MX','[{"name":"Contacto6","relationship":"Hermano","phone":"+525510000006"}]'::jsonb,'Soltero/a','600000000000006',1,1,6),
(7,'2025-09-15 16:20:01.200002',true,'2025-09-15 16:20:01.200002',NULL,'2020-02-15',NULL,'a',NULL,'correo7@cts.com','555-1000-0007','Calle Reforma 7, Ciudad MX','[{"name":"Contacto7","relationship":"Padre","phone":"+525510000007"}]'::jsonb,'Casado/a','700000000000007',2,2,7),
(8,'2025-09-15 16:20:01.300003',true,'2025-09-15 16:20:01.300003',NULL,'2020-03-15',NULL,'a',NULL,'correo8@cts.com','555-1000-0008','Calle Reforma 8, Ciudad MX','[{"name":"Contacto8","relationship":"Madre","phone":"+525510000008"}]'::jsonb,'Divorciado/a','800000000000008',3,3,8),
(9,'2025-09-15 16:20:01.400004',true,'2025-09-15 16:20:01.400004',NULL,'2020-04-15',NULL,'a',NULL,'correo9@cts.com','555-1000-0009','Calle Reforma 9, Ciudad MX','[{"name":"Contacto9","relationship":"Amigo","phone":"+525510000009"}]'::jsonb,'Soltero/a','900000000000009',1,4,9),
(10,'2025-09-15 16:20:01.500005',true,'2025-09-15 16:20:01.500005',NULL,'2020-05-15',NULL,'a',NULL,'correo10@cts.com','555-1000-0010','Calle Reforma 10, Ciudad MX','[{"name":"Contacto10","relationship":"Hermana","phone":"+525510000010"}]'::jsonb,'Casado/a','1000000000000010',2,1,10),
(11,'2025-09-15 16:20:01.600006',true,'2025-09-15 16:20:01.600006',NULL,'2020-06-15',NULL,'a',NULL,'correo11@cts.com','555-1000-0011','Calle Reforma 11, Ciudad MX','[{"name":"Contacto11","relationship":"Padre","phone":"+525510000011"}]'::jsonb,'Divorciado/a','1100000000000011',3,2,11),
(12,'2025-09-15 16:20:01.700007',true,'2025-09-15 16:20:01.700007',NULL,'2020-07-15',NULL,'a',NULL,'correo12@cts.com','555-1000-0012','Calle Reforma 12, Ciudad MX','[{"name":"Contacto12","relationship":"Madre","phone":"+525510000012"}]'::jsonb,'Soltero/a','1200000000000012',1,3,12),
(13,'2025-09-15 16:20:01.800008',true,'2025-09-15 16:20:01.800008',NULL,'2020-08-15',NULL,'a',NULL,'correo13@cts.com','555-1000-0013','Calle Reforma 13, Ciudad MX','[{"name":"Contacto13","relationship":"Amigo","phone":"+525510000013"}]'::jsonb,'Casado/a','1300000000000013',2,4,13),
(14,'2025-09-15 16:20:01.900009',true,'2025-09-15 16:20:01.900009',NULL,'2020-09-15',NULL,'a',NULL,'correo14@cts.com','555-1000-0014','Calle Reforma 14, Ciudad MX','[{"name":"Contacto14","relationship":"Hermano","phone":"+525510000014"}]'::jsonb,'Divorciado/a','1400000000000014',3,1,14),
(15,'2025-09-15 16:20:02.00001',true,'2025-09-15 16:20:02.00001',NULL,'2020-10-15',NULL,'a',NULL,'correo15@cts.com','555-1000-0015','Calle Reforma 15, Ciudad MX','[{"name":"Contacto15","relationship":"Hermana","phone":"+525510000015"}]'::jsonb,'Soltero/a','1500000000000015',1,2,15),
(16,'2025-09-15 16:20:02.100011',true,'2025-09-15 16:20:02.100011',NULL,'2020-11-15',NULL,'a',NULL,'correo16@cts.com','555-1000-0016','Calle Reforma 16, Ciudad MX','[{"name":"Contacto16","relationship":"Padre","phone":"+525510000016"}]'::jsonb,'Casado/a','1600000000000016',2,3,16),
(17,'2025-09-15 16:20:02.200012',true,'2025-09-15 16:20:02.200012',NULL,'2020-12-15',NULL,'a',NULL,'correo17@cts.com','555-1000-0017','Calle Reforma 17, Ciudad MX','[{"name":"Contacto17","relationship":"Madre","phone":"+525510000017"}]'::jsonb,'Divorciado/a','1700000000000017',3,4,17),
(18,'2025-09-15 16:20:02.300013',true,'2025-09-15 16:20:02.300013',NULL,'2021-01-15',NULL,'a',NULL,'correo18@cts.com','555-1000-0018','Calle Reforma 18, Ciudad MX','[{"name":"Contacto18","relationship":"Amigo","phone":"+525510000018"}]'::jsonb,'Soltero/a','1800000000000018',1,1,18),
(19,'2025-09-15 16:20:02.400014',true,'2025-09-15 16:20:02.400014',NULL,'2021-02-15',NULL,'a',NULL,'correo19@cts.com','555-1000-0019','Calle Reforma 19, Ciudad MX','[{"name":"Contacto19","relationship":"Hermano","phone":"+525510000019"}]'::jsonb,'Casado/a','1900000000000019',2,2,19),
(20,'2025-09-15 16:20:02.500015',true,'2025-09-15 16:20:02.500015',NULL,'2021-03-15',NULL,'a',NULL,'correo20@cts.com','555-1000-0020','Calle Reforma 20, Ciudad MX','[{"name":"Contacto20","relationship":"Hermana","phone":"+525510000020"}]'::jsonb,'Divorciado/a','2000000000000020',3,3,20),
(21,'2025-09-15 16:20:02.600016',true,'2025-09-15 16:20:02.600016',NULL,'2021-04-15',NULL,'a',NULL,'correo21@cts.com','555-1000-0021','Calle Reforma 21, Ciudad MX','[{"name":"Contacto21","relationship":"Padre","phone":"+525510000021"}]'::jsonb,'Soltero/a','2100000000000021',1,4,21),
(22,'2025-09-15 16:20:02.700017',true,'2025-09-15 16:20:02.700017',NULL,'2021-05-15',NULL,'a',NULL,'correo22@cts.com','555-1000-0022','Calle Reforma 22, Ciudad MX','[{"name":"Contacto22","relationship":"Madre","phone":"+525510000022"}]'::jsonb,'Casado/a','2200000000000022',2,1,22),
(23,'2025-09-15 16:20:02.800018',true,'2025-09-15 16:20:02.800018',NULL,'2021-06-15',NULL,'a',NULL,'correo23@cts.com','555-1000-0023','Calle Reforma 23, Ciudad MX','[{"name":"Contacto23","relationship":"Amigo","phone":"+525510000023"}]'::jsonb,'Divorciado/a','2300000000000023',3,2,23),
(24,'2025-09-15 16:20:02.900019',true,'2025-09-15 16:20:02.900019',NULL,'2021-07-15',NULL,'a',NULL,'correo24@cts.com','555-1000-0024','Calle Reforma 24, Ciudad MX','[{"name":"Contacto24","relationship":"Hermano","phone":"+525510000024"}]'::jsonb,'Soltero/a','2400000000000024',1,3,24),
(32,'2025-09-16 10:11:43.01815',true,'2025-09-16 10:11:43.01815',NULL,'2025-09-13',NULL,NULL,NULL,'lauragomez98@mail.com','555-7890-1234','Av. las palmas 123, monterrey, nuevo león','[{"name":"María Ramírez","relationship":"Madre","phone":"+525511987654"}]'::jsonb,'Soltero/a','123456789012345',2,2,88);


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
(id, created_at, available, updated_at, deleted_at, employee_id, position_id)
VALUES
(25,'2025-09-16 10:11:43.01815',true,'2025-09-16 10:11:43.01815',NULL,32,60),
(1,'2025-09-15 16:29:09.482281',true,'2025-09-15 16:29:09.482281',NULL,1,37),
(2,'2025-09-15 16:29:35.768279',true,'2025-09-15 16:29:35.768279',NULL,2,38),
(3,'2025-09-15 16:29:35.776617',true,'2025-09-15 16:29:35.776617',NULL,3,39),
(4,'2025-09-15 16:29:35.77998',true,'2025-09-15 16:29:35.77998',NULL,5,41),
(5,'2025-09-15 16:29:35.78173',true,'2025-09-15 16:29:35.78173',NULL,6,42),
(6,'2025-09-15 16:29:35.783238',true,'2025-09-15 16:29:35.783238',NULL,7,43),
(7,'2025-09-15 16:29:35.786082',true,'2025-09-15 16:29:35.786082',NULL,8,44),
(8,'2025-09-15 16:29:35.787615',true,'2025-09-15 16:29:35.787615',NULL,9,45),
(9,'2025-09-15 16:30:27.920428',true,'2025-09-15 16:30:27.920428',NULL,10,47),
(10,'2025-09-15 16:30:27.925749',true,'2025-09-15 16:30:27.925749',NULL,11,48),
(11,'2025-09-15 16:30:27.927994',true,'2025-09-15 16:30:27.927994',NULL,12,49),
(12,'2025-09-15 16:30:27.932991',true,'2025-09-15 16:30:27.932991',NULL,15,52),
(13,'2025-09-15 16:30:27.934265',true,'2025-09-15 16:30:27.934265',NULL,16,53),
(14,'2025-09-15 16:30:27.935544',true,'2025-09-15 16:30:27.935544',NULL,17,54),
(15,'2025-09-15 16:30:27.936778',true,'2025-09-15 16:30:27.936778',NULL,18,55),
(16,'2025-09-15 16:31:26.848332',true,'2025-09-15 16:31:26.848332',NULL,19,56),
(17,'2025-09-15 16:31:26.856342',true,'2025-09-15 16:31:26.856342',NULL,20,57),
(18,'2025-09-15 16:31:26.857957',true,'2025-09-15 16:31:26.857957',NULL,21,58),
(19,'2025-09-15 16:31:26.859227',true,'2025-09-15 16:31:26.859227',NULL,22,59),
(20,'2025-09-15 16:31:26.860276',true,'2025-09-15 16:31:26.860276',NULL,23,60),
(21,'2025-09-15 16:31:26.861141',true,'2025-09-15 16:31:26.861141',NULL,24,61),
(22,'2025-09-15 16:30:27.929797',true,'2025-09-15 16:30:27.929797',NULL,13,56),
(23,'2025-09-15 16:30:27.931628',true,'2025-09-15 16:30:27.931628',NULL,14,57),
(24,'2025-09-15 16:29:35.77838',true,'2025-09-15 16:29:35.77838',NULL,4,58);

insert into public.projects (
    id,	created_at,	available, updated_at,	deleted_at,	"isExternal", contract_number, name, description, start_date, end_date, number_expedients, number_images, productions_days, sum_productions, status) 
    values (
    1,'2025-09-13 18:24:33.261711',true,'2025-09-13 18:24:33.261711',null, false,'','Centro de Tecnologías del Sureste','CTS','2020-01-01','2020-01-01',0,0,0,0,'ACTIVE');


INSERT INTO public.extension
(id, created_at, available, updated_at, deleted_at, number_expedients, start_date, end_date, "projectId")
VALUES
();

INSERT INTO public.headquarters (id, created_at, available, updated_at, deleted_at, name, address, city, postal_code, phone, start_date, end_date, production_days, number_expedients, sum_productions, status, project_id)
VALUES
(1, '2025-09-13 18:26:22.514128', TRUE, '2025-09-13 18:26:22.514128', NULL, 'Rio Nilo', 'C. Rio Nilo #90, Piso 3. Alcaldia Cuahutemoc, CDMX', 'CDMX', '06500', '+529141398454', '2023-01-01', '2023-01-01', 0, 0, 0, 'ACTIVE', 1),
(2, '2025-09-13 18:26:22.514128', TRUE, '2025-09-13 18:26:22.514128', NULL, 'La Ceiba', 'C. La Ceiba #. Villahermosa, Tabasco', 'Villahermosa', '80600', '+529141398454', '2023-01-01', '2023-01-01', 0, 0, 0, 'ACTIVE', 1);


INSERT INTO public.headquarters_position_quota
(id, created_at, available, updated_at, deleted_at, max_employee, position_id, "headquartersId")
VALUES
();

INSERT INTO public.staff
(id, created_at, available, updated_at, deleted_at, employee_has_positions_id, headquarter_id, "parentId")
VALUES
(1,'2025-09-15 16:39:41.713686',true,'2025-09-15 16:39:41.713686',NULL,1,1,NULL),
(2,'2025-09-15 16:39:45.901579',true,'2025-09-15 16:39:45.901579',NULL,2,1,NULL),
(3,'2025-09-15 16:39:48.451202',true,'2025-09-15 16:39:48.451202',NULL,3,1,NULL),
(4,'2025-09-15 16:39:50.956161',true,'2025-09-15 16:39:50.956161',NULL,4,1,NULL),
(5,'2025-09-15 16:40:26.745429',true,'2025-09-15 16:40:26.745429',NULL,5,1,NULL),
(6,'2025-09-15 16:40:30.278544',true,'2025-09-15 16:40:30.278544',NULL,6,1,NULL),
(7,'2025-09-15 16:40:34.492226',true,'2025-09-15 16:40:34.492226',NULL,7,1,NULL),
(8,'2025-09-15 16:41:00.177304',true,'2025-09-15 16:41:00.177304',NULL,8,1,NULL),
(9,'2025-09-15 16:41:04.588484',true,'2025-09-15 16:41:04.588484',NULL,9,1,NULL),
(10,'2025-09-15 16:41:07.162346',true,'2025-09-15 16:41:07.162346',NULL,10,1,NULL),
(11,'2025-09-15 16:41:21.456463',true,'2025-09-15 16:41:21.456463',NULL,11,1,NULL),
(16,'2025-09-15 17:34:45.053208',true,'2025-09-15 17:34:45.053208',NULL,12,1,10),
(17,'2025-09-15 17:39:08.580527',true,'2025-09-15 17:39:08.580527',NULL,13,1,10),
(18,'2025-09-15 17:39:08.583698',true,'2025-09-15 17:39:08.583698',NULL,14,1,10),
(19,'2025-09-15 17:39:08.585762',true,'2025-09-15 17:39:08.585762',NULL,15,1,10),
(20,'2025-09-15 17:39:08.587346',true,'2025-09-15 17:39:08.587346',NULL,16,1,17),
(21,'2025-09-15 17:50:01.237242',true,'2025-09-15 17:50:01.237242',NULL,17,1,19),
(22,'2025-09-15 17:50:01.246134',true,'2025-09-15 17:50:01.246134',NULL,18,1,16),
(23,'2025-09-15 17:50:01.248088',true,'2025-09-15 17:50:01.248088',NULL,19,1,18),
(24,'2025-09-15 17:50:01.249528',true,'2025-09-15 17:50:01.249528',NULL,20,1,8),
(25,'2025-09-15 17:50:01.250735',true,'2025-09-15 17:50:01.250735',NULL,21,1,7),
(26,'2025-09-15 17:53:05.471482',true,'2025-09-15 17:53:05.471482',NULL,22,1,17),
(27,'2025-09-15 17:53:05.479964',true,'2025-09-15 17:53:05.479964',NULL,23,1,19),
(28,'2025-09-15 17:55:07.543343',true,'2025-09-15 17:55:07.543343',NULL,24,1,16),
(31,'2025-09-16 10:11:43.01815',true,'2025-09-16 10:11:43.01815',NULL,25,1,8);


INSERT INTO public.staff_closure (id_ancestor, id_descendant) VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6),
(7,7),
(8,8),
(9,9),
(10,10),
(11,11),
(16,16),
(10,16),
(17,17),
(10,17),
(18,18),
(10,18),
(19,19),
(10,19),
(20,20),
(17,20),
(21,21),
(19,21),
(22,22),
(16,22),
(23,23),
(8,23),
(25,25),
(7,25),
(26,26),
(17,26),
(27,27),
(19,27),
(28,28),
(16,28),
(31,31),
(8,31);



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
(id, created_at, available, updated_at, deleted_at, email, status, required_access, user_id, employee_id)
VALUES
(64,'2025-09-16 10:11:43.01815',true,'2025-09-16 10:11:43.01815',NULL,'rh@empresaejemplo.com.mx',false,true,NULL,88);

