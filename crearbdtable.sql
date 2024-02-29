-- cl scr para limpiar pantalla
CREATE TABLE ALUMNO
(
dni VARCHAR2(10) CONSTRAINT alu_dni_pk PRIMARY KEY,
nombre VARCHAR2(25),
apellido1 VARCHAR2(25),
telefono VARCHAR2(30),
fechanac DATE,
sexo VARCHAR(10)
);
CREATE TABLE ASIGNAR 
(
dnimonitor VARCHAR(10) CONSTRAINT asi_mon_fk REFERENCES MONITOR(dni),
ciftienda VARCHAR(10) CONSTRAINT asi_tie_fk REFERENCES TIENDA,
-- El number(4,2) es que de esos 4 numeros 2 son decimales
descuento NUMBER(4,2),
--asi_dni_cif_pk es el nombre de la constraint, esta constraint significa que la clave primaria esta formada por los campos dnimonitor y ciftienda
CONSTRAINT asi_dni_cif_pk PRIMARY KEY (dnimonitor, ciftienda)
);
CREATE TABLE COMPRAR
(
--CONSTRAINT es una restriccion de la tabla
--REFERENCES es una referencia a otra tabla
dnialumno VARCHAR2(10) CONSTRAINT com_alu_fk REFERENCES ALUMNO,
dnimonitor VARCHAR2(10) CONSTRAINT com_mon_fk REFERENCES MONITOR,
ciftienda VARCHAR2(10) CONSTRAINT com_tie_fk REFERENCES TIENDA,
fecha DATE,
--6,2 es que de esos 6 4 son enteros y 2 decimales
importeinicial NUMBER(6,2),
importefinal NUMBER(6,2),
CONSTRAINT com_dni_mon_cif_pk PRIMARY KEY (dnialumno, dnimonitor, ciftienda, fecha)
);

CREATE TABLE CURSO
(
	numnivel NUMBER(2) CONSTRAINT cur_niv_fk REFERENCES NIVEL,
	numero NUMBER(3),
	fechaini DATE,
	horario VARCHAR(100),
	numhoras NUMBER(3),
	precio NUMBER(8,2),
	dnimonitor CONSTRAINT cur_mon_fk REFERENCES MONITOR,
	CONSTRAINT cur_niv_num_pk PRIMARY KEY (numnivel,numero)
);
CREATE TABLE MATRICULA
(
dnialumno VARCHAR2(10) CONSTRAINT mat_alu_fk REFERENCES ALUMNO,
nivel NUMBER(2),
curso NUMBER(2),
diasasiste NUMBER(2),
CONSTRAINT mat_dni_niv_pk PRIMARY KEY (dnialumno, nivel, curso),
CONSTRAINT mat_cur_fk FOREIGN KEY (nivel, curso) REFERENCES CURSO( numnivel, numero)
);

CREATE TABLE MONITOR
( 
dni VARCHAR2(10) CONSTRAINT mon_dni_pk PRIMARY KEY,
nombre VARCHAR2(25),
apellido1 VARCHAR2(25),
telefono VARCHAR2(30)
);

CREATE TABLE NIVEL
(
numero NUMBER(2) CONSTRAINT niv_num_pk PRIMARY KEY,
nombre VARCHAR2(10),
descripcion VARCHAR2(50)
);
CREATE TABLE PISTA
(
codigo VARCHAR(10) CONSTRAINT pis_cod_pk PRIMARY KEY,
estado VARCHAR(20),
observacion VARCHAR(50)
);
CREATE TABLE TIENDA
(
cif VARCHAR2(10) CONSTRAINT tie_cif_pk PRIMARY KEY,
nombre VARCHAR2(50),
telefono VARCHAR2(30)
);


/* 
2. obtener la informacion que se indica en los siguiente apartados introduciendo los comandos necesarios:
2a.Lista el nombre de las tablas creadas y verifica que solamente existen las tablas indicadas en el diseño logico
--SELECT table_name FROM user_tables;
2b.Lista el nombre de las columnas de la tabla alumno
2b.- Lista las restricciones definidas sobre la base de datos: nombre, tipo y tabla sobre la
que se han creado.

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE FROM USER_CONSTRAINTS; Si queremos listar todas las tablas

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'COMPRAR'; O solo una tabla
2.c Cuantas claves principales hay, escribe una instruccion que obtenga el numero 

select b.table_name,b.constraint_name,
COUNT(b.constraint_type) AS PKs
from user_constraints b
WHERE b.constraint_type= 'P'
GROUP BY
b.table_name,
b.constraint_name;

O el total  de PKs
select 
COUNT(*) AS PKs
from user_constraints b
WHERE b.constraint_type= 'P';

2.d y cuantas claves ajenas, escribe una instruccion que obtenga el numero

select b.table_name,b.constraint_name,
COUNT(b.constraint_type) AS FKs
from user_constraints b
WHERE b.constraint_type= 'R'
GROUP BY
b.table_name,
b.constraint_name;


*/ 
/*ver todas las tablas que tenemos creadas en usuario1
SELECT table_name FROM user_tables;
*/

	
