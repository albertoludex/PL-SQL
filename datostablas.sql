INSERT INTO ALUMNO (dni, nombre, apellido1, telefono, fechanac, sexo) VALUES ('33000111M', 'Susana', 'Mora', '649000111', '01/02/2000', 'M');
INSERT INTO ALUMNO (dni, nombre, apellido1, telefono, fechanac, sexo, email) VALUES ('33000222N', 'Diego', 'Rocamora', '605111222', '07/05/1990', 'H', 'drocamora@gmail.com');
INSERT INTO ALUMNO (dni, nombre, apellido1, telefono, fechanac, email) VALUES ('33000333P', 'Antonio', 'Oliva', '965437657, 630112233', '21/09/2001', 'aoliva@hotmail.com');
INSERT INTO ALUMNO (dni, nombre, apellido1, telefono, fechanac, email) VALUES ('33000444A', 'Santiago', 'Pardo', '96545555, 630113344', '15/09/1997', 'saldeguer@hotmail.com');
INSERT INTO ALUMNO (dni, nombre, apellido1, telefono, fechanac, email, sexo) VALUES ('33000555M', 'Cristina', 'Huertas', '649125467', '30/11/2000', 'chuertas@gmail.com', 'M');
INSERT INTO ALUMNO (dni, nombre, apellido1, telefono, email, sexo) VALUES ('33000666H', 'Carmen', 'Torres', '605887689', 'ctorres@gmail.com', 'M');
INSERT INTO ALUMNO (dni, nombre, apellido1, telefono, sexo) VALUES ('55111222X', 'Susana', 'Molina', '649004362', 'M');


INSERT INTO MONITOR VALUES ('11222333A', 'Antonio','Soler', '605112233', 'Toni');
INSERT INTO MONITOR (codigo, dni, nombre, apellido1, telefono) VALUES ('Lola', '22333444M', 'Maria Dolores', 'Molins', '649001122');
INSERT INTO MONITOR VALUES ('44333555S', 'Manuel Antonio', 'Vives', '630214123', 'Toni2');
INSERT INTO MONITOR VALUES ('55111222X', 'Susana', 'Molina', '649004362', 'Chus');
INSERT INTO MONITOR VALUES ('66777888Y', 'Daniel', 'Pamies', '605000123', 'Dani');


INSERT INTO NIVEL VALUES (1, 'INICIACION I', 'Para quien no sabe nada');
INSERT INTO NIVEL VALUES (2, 'INICIACION II', 'Para quien tiene algunas nociones');
INSERT INTO NIVEL VALUES (3, 'INTERMEDIO I', 'Para quien juega habitualmente');
INSERT INTO NIVEL VALUES (4, 'INTERMEDIO II', 'Para quien compite en categ. 5 o 6');
INSERT INTO NIVEL VALUES (5, 'AVANZADO I', 'Para quien compite en categ. 4');
INSERT INTO NIVEL VALUES (6, 'AVANZADO II', 'Para quien compite en categ. 3');
INSERT INTO NIVEL VALUES (7, 'EXPERTO', 'Para quien compite en categ. 1 o 2');


INSERT INTO PISTA VALUES ('ORO', 'Disponible', NULL);
INSERT INTO PISTA (codigo, estado) VALUES ('PLATA', 'Disponible');
INSERT INTO PISTA (codigo, observaciones, estado) VALUES ('BRONCE', 'Limpiar pista y ajustar red', 'Mantenimiento');


INSERT INTO CURSO (numnivel, numero, fechaini, horario, numhoras, precio, pista, dnimonitor) 
            VALUES (1, 1, '01/12/2023', 'L,X: 10:00-11:30', 50, 350, 'PLATA', '11222333A');
INSERT INTO CURSO (numnivel, numero, fechaini, horario, numhoras, precio, pista, dnimonitor) 
            VALUES (1, 2, NULL,'M,J: 12:00-13:00', 80, 480, 'PLATA', '11222333A');
INSERT INTO CURSO (numnivel, numero, fechaini, horario, numhoras, precio, pista, dnimonitor) 
            VALUES (4, 1, '22/12/2023', 'L,X,V: 16:00-17:30', NULL, NULL, 'ORO', '11222333A');
INSERT INTO CURSO (numnivel, numero, fechaini, horario, numhoras, precio, pista, dnimonitor) 
            VALUES (4, 2, '14/01/2024', 'X,V: 19:30-21:00', 100, 960, NULL, '22333444M');
