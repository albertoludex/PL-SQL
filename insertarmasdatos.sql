INSERT INTO ALUMNO (dni, nombre, apellido1, telefono, fechanac, sexo, email) 
               VALUES ('45147825B', 'Salvador', 'Ortiz', '630987654,965431212', '12/04/2000', 'H', 'sortiz@hotmail.com');
INSERT INTO ALUMNO (dni, nombre, apellido1, telefono, fechanac, sexo)       
               VALUES ('45000111P', 'Patricia', 'Vives', '642970313', '19/06/1997', 'M');
INSERT INTO ALUMNO (dni, nombre, apellido1, telefono, fechanac, sexo)       
               VALUES ('72156234C', 'Carmen', 'Rocamora', '630178345', '01/03/1995', 'M');
INSERT INTO ALUMNO (dni, nombre, apellido1, telefono, fechanac, email)      
               VALUES ('54234567M', 'Unay', 'Ramos', '630238343', '18/05/1980', 'uramos@hotmail.es');
INSERT INTO ALUMNO (dni, nombre, apellido1, telefono, fechanac, sexo,EMAIL) 
                VALUES ('54234568K', 'Carlos', 'Ramos', '630178345', '18/05/1980', 'H', 'cramos@hotmail.es');
INSERT INTO ALUMNO (dni, nombre, apellido1, sexo, email)                   
               VALUES ('45700600U', 'Cristina', 'Medina', 'M', 'cmedina@gmail.com');
INSERT INTO ALUMNO (dni, nombre, apellido1, telefono, fechanac, sexo)       
               VALUES ('54000111H', 'Alicia', 'Torres', '630178345', '10/05/1997', 'M');

INSERT INTO CURSO (numnivel, numero, fechaini, horario, numhoras, precio, pista, dnimonitor) 
                VALUES (3, 2, '30/01/2024', 'V,S: 17:00-18:00', 60, 500, 'BRONCE', '44333555S');

INSERT INTO MATRICULAR (nivel, curso, dnialumno) VALUES (1, 1, '33000111M');
INSERT INTO MATRICULAR (nivel, curso, dnialumno) VALUES (1, 1, '33000222N');
INSERT INTO MATRICULAR (nivel, curso, dnialumno) VALUES (1, 1, '33000333P');
INSERT INTO MATRICULAR (nivel, curso, dnialumno) VALUES (1, 2, '33000555M');
INSERT INTO MATRICULAR (nivel, curso, dnialumno) VALUES (3, 1, '54234567M');
INSERT INTO MATRICULAR (nivel, curso, dnialumno) VALUES (3, 1, '54234568K');
INSERT INTO MATRICULAR (nivel, curso, dnialumno) VALUES (3, 1, '45700600U');
INSERT INTO MATRICULAR (nivel, curso, dnialumno) VALUES (3, 1, '54000111H');
INSERT INTO MATRICULAR (nivel, curso, dnialumno) VALUES (3, 2, '33000111M');
INSERT INTO MATRICULAR (nivel, curso, dnialumno) VALUES (3, 2, '72156234C');
INSERT INTO MATRICULAR (nivel, curso, dnialumno) VALUES (3, 2, '45000111P');
INSERT INTO MATRICULAR (nivel, curso, dnialumno) VALUES (4, 1, '54234567M');
INSERT INTO MATRICULAR (nivel, curso, dnialumno) VALUES (4, 1, '54234568K');
INSERT INTO MATRICULAR (nivel, curso, dnialumno) VALUES (4, 1, '33000111M');
INSERT INTO MATRICULAR (nivel, curso, dnialumno) VALUES (4, 1, '72156234C');
INSERT INTO MATRICULAR (nivel, curso, dnialumno) VALUES (1, 2, '33000111M');
INSERT INTO MATRICULAR (nivel, curso, dnialumno) VALUES (1, 2, '33000444A');
INSERT INTO MATRICULAR (nivel, curso, dnialumno) VALUES (2, 1, '33000111M');
INSERT INTO MATRICULAR (nivel, curso, dnialumno) VALUES (2, 1, '33000555M');

COMMIT;

INSERT INTO ALUMNO (dni, nombre, apellido1, telefono, fechanac, sexo)        VALUES ('21000111M', 'Silvia', 'Mora', '630121314', '01/02/1980', 'M');
INSERT INTO ALUMNO (dni, nombre, apellido1, telefono, fechanac, sexo, email) VALUES ('55000222N', 'Ernesto', 'Roca', '630111333', '17/05/1985', 'H', 'eroca@gmail.com');

INSERT INTO PISTA (codigo, estado, observaciones) VALUES ('COBRE', 'Revisar', 'Muy mal estado');

INSERT INTO CURSO (numnivel, numero, fechaini, horario, numhoras, precio, pista, dnimonitor) VALUES (1, 5, '24/03/2024', 'M,J: 10:00-12:00', 100, 600, 'COBRE', '11222333A');
INSERT INTO CURSO (numnivel, numero, fechaini, horario, numhoras, precio, pista, dnimonitor) VALUES (4, 3, '24/03/2024', 'M,J: 16:00-18:00', 80, 700, 'COBRE', '44333555S');

COMMIT;

