-- cOMPROBAR CUANTOS REGISTROS TIENEN LAS TABLAS
SELECT COUNT(*) FROM ALUMNO;
SELECT COUNT(*) FROM MONITOR;
SELECT COUNT(*) FROM NIVEL;
SELECT COUNT(*) FROM PISTA;
SELECT COUNT(*) FROM CURSO;


-- EJ 2
-- EJERCICIO 2.1
INSERT INTO CURSO (numnivel, numero, fechaini, horario, numhoras, precio, pista, dnimonitor) VALUES (2, 1, '09/12/2023', 'L,V: 12:00-13:00', 80, 480, NULL, '11222333A');

-- EJERCICIO 2.2
INSERT INTO CURSO (numnivel, numero, fechaini, horario, numhoras, precio, pista, dnimonitor) 
VALUES (2, 2, '23/12/2023', 'M,X,J: 12:00-13:00', 80, 480, 'ORO', NULL); -- NO DEJA INSERTAR PORQUE EL CAMPO DNIMONITOR NO PUEDE SER NULO

-- EJERCICIO 2.3
INSERT INTO CURSO (numnivel, numero, fechaini, horario, numhoras, precio, pista, dnimonitor)
VALUES (1, 2, '13/01/2024', 'M,J: 13:00-14:00', 100, 750, 'BRONCE', '22333444M'); -- NO DEJA INSERTAR PORQUE SE REPITE LA CLAVE PRINCIPAL

-- EJERCICIO 2.4
INSERT INTO CURSO (numnivel, numero, fechaini, horario, numhoras, precio, pista, dnimonitor)
VALUES (1, NULL, '07/02/2024', 'S,D: 11:00-12:00', 120, 860, 'ORO', '11222333A'); -- NO DEJA INSERTAR PORQUE EL NUMERO NO PUEDE SER NULO

-- EJERCICIO 2.5
INSERT INTO CURSO (numnivel, numero, fechaini, horario, numhoras, precio, pista, dnimonitor)
VALUES (2, 3, '01/02/2024', 'X,J: 12:00-13:00', 50, 400, 'COBRE', '11222333A'); -- NO DEJA INSERTAR PORQUE NO EXISTE LA PISTA BRONCE

-- EJERCICIO 2.6
INSERT INTO CURSO (numnivel, numero, fechaini, horario, numhoras, precio, pista, dnimonitor)
VALUES (3, 1, '31/11/2023', 'L,S: 17:00-18:00', 60, 500, 'ORO', '11222333A'); -- NO DEJA INSERTAR PORQUE NO EXISTE EL DIA 31 DE NOVIEMBRE

-- EJERCICIO 3
INSERT INTO MONITOR (dni, nombre, apellido1, telefono, codigo) VALUES ('44555666P', 'Patricia', 'Moles', '630112233', 'Patri');

INSERT INTO CURSO (numnivel, numero, fechaini, horario, numhoras, precio, pista, dnimonitor)
VALUES (1, 7, '01/03/2024', 'S,D: 19:00-20:30', 32, NULL, NULL, '44555666P');

-- EJERCICIO 4
-- SE INSERTA EL FICHERO INSERTARMASDATOS.SQL

-- EJERCICIO 5
INSERT INTO MATRICULAR (dnialumno, curso, nivel)
(SELECT dnialumno, 2, 4
 FROM MATRICULAR
 WHERE curso = 1 AND nivel = 4);

-- EJERCICIO 6

INSERT INTO ALUMNO (dni, nombre, apellido1, telefono)
(SELECT dni, nombre, apellido1, telefono
 FROM MONITOR
 WHERE apellido1 > 'P');

-- INSERTAMOS A LOS MONITORES EN LA TABLA MATRICULAR

INSERT INTO CURSO (numnivel, numero, fechaini, horario, numhoras, precio, pista, dnimonitor)
VALUES (7, 1, '01/03/2024', 'S,D: 19:00-20:30', 32, NULL, NULL, '44555666P');

INSERT INTO MATRICULAR (dnialumno, nivel, curso) 
SELECT A.dni, 7, 1 FROM ALUMNO A, MONITOR WHERE A.dni = MONITOR.dni AND A.apellido1 > 'P';

-- EJERCICIO 8
UPDATE MONITOR
SET codigo = 'Manu'
WHERE dni = '44333555S';

-- EJERCICIO 9
UPDATE ALUMNO
SET dni = '33000666F'
WHERE dni = '33000666H';

-- EJERCICIO 10
SELECT * FROM ALUMNO WHERE sexo IS NULL;

UPDATE ALUMNO
SET sexo = 'H'
WHERE sexo IS NULL;

-- EJERCICIO 11
UPDATE PISTA
SET estado = 'Disponible', observaciones = NULL
WHERE codigo = 'BRONCE';

-- EJERCICIO 12
SELECT numero FROM CURSO
WHERE dnimonitor = '44333555S';

UPDATE CURSO
SET precio = precio * 1.2
WHERE dnimonitor = '44333555S';

-- EJERCICIO 13
--PRIMERO SE ACTUALIZA EL PRECIO
UPDATE CURSO
SET precio = precio - 30
WHERE numnivel = 3 AND numero = 1;

-- Y LUEGO SE ACTUALIZA EL CURSO
UPDATE MATRICULAR
SET curso = 1
WHERE nivel = 3 AND curso = 2; -- NO FURULA

-- EJERCICIO 14
UPDATE CURSO
SET pista = 'PLATA'
WHERE dnimonitor = (SELECT dni FROM MONITOR WHERE nombre = 'Patricia' AND apellido1 = 'Moles');

-- EJERCICIO 15
UPDATE CURSO
SET dnimonitor = (SELECT dni FROM MONITOR WHERE codigo = 'Manu'), pista = 'COBRE'
WHERE dnimonitor = (SELECT dni FROM MONITOR WHERE nombre = 'Lola');