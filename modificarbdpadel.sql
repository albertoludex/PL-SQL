/*tenemos que utilizar la instruccion   ALTER TABLE
ALTER es para modificar la tabla
MODIFY es para modificar el campo
*/
-- 1. Modificar la tabla PISTA para que el campo codigo tenga una longitud de 10 caracteres.
ALTER TABLE PISTA MODIFY (codigo VARCHAR2(10));
--2.modifcar en tabla alumno, añade una columna email para que tenga una longitud de 30 caracteres, verifica que se añade la columna
ALTER TABLE ALUMNO ADD(email VARCHAR2(30));
--verificar que se añade la columna
SELECT * FROM USER_TAB_COLUMNS WHERE TABLE_NAME='ALUMNO';
--3. Modificar la tabla ALUMNO para que el campo sexo tenga una longitud de 1 caracter.
ALTER TABLE ALUMNO MODIFY(sexo VARCHAR2(1));
--VER LOS CAMPOS DE LA TABLA ALUMNO aunque este vacio
SELECT * FROM ALUMNO;
--ver los campos que tiene alumno
DESC ALUMNO; 
--4. Modificar la tabla ALUMNO para que el campo sexo tenga una longitud de 1 caracter y que solo pueda tener los valores 'H' o 'M'.
--el CHECK es para que solo pueda tener los valores 'H' o 'M'
ALTER TABLE ALUMNO MODIFY(sexo CONSTRAINT alu_sex_ch CHECK(sexo IN ('H','M')));
--imprime las constraints 
    SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='ALUMNO';
--5. Modificar la tabla MONITOR para que el campo telefono no pueda ser nulo.
ALTER TABLE MONITOR MODIFY (telefono CONSTRAINT mon_tel_nn NOT NULL);
--6. Modificar la tabla MONITOR para que el campo codigo tenga una longitud de 15 caracteres y que no pueda ser nulo.
--el UNIQUE es para que no se repita el codigo
ALTER TABLE MONITOR ADD (codigo VARCHAR2(15) CONSTRAINT mon_cod_uq UNIQUE
                                            CONSTRAINT mon_cod_nn NOT NULL);

--7. Modificar la tabla CURSO para que el campo pista sea una clave foránea que haga referencia al campo codigo de la tabla PISTA.
--primero borramos la clave foranea, SI EXISTE, Como no existe no hace nada
--muestra las claves foraneas que tiene curso 
--SELECT CONSTRAINT_NAME, R_CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE TABLE_NAME='CURSO';
--luego añadimos la clave foranea
ALTER TABLE CURSO ADD CONSTRAINT cur_pis_fk FOREIGN KEY(pista) REFERENCES PISTA(codigo);
--8. Modificar la tabla CURSO para que el campo dnimonitor no pueda ser nulo.
ALTER TABLE CURSO MODIFY (dnimonitor CONSTRAINT cur_dni_nn NOT NULL);
--Crea campo para comprobar que funciona con el insert:
INSERT INTO CURSO VALUES (1,1,TO_DATE('01/01/2019','DD/MM/YYYY'),'L,X: 10:00-11:30',1,10,'P1','12345678A');-- este se puede introducir
INSERT INTO CURSO VALUES (1,1,TO_DATE('01/01/2019','DD/MM/YYYY'),'L,X: 10:00-11:30',1,10,'P1');--este no se puede introducir
--ahora elimina el campo anterior DELETE FROM CURSO WHERE numnivel=1 AND numero=1;
--9. tabla asignar para que el campo descuento tenga un valor por defecto de 0 y que no pueda ser negativo.
ALTER TABLE ASIGNAR MODIFY (descuento DEFAULT 0
                            CONSTRAINT asi_des_ch CHECK(descuento >= 0));
--el default es para que tenga un valor por defecto de 0
--el check es para comprobar que no sea negativo
--crea un campo para comprobar que funciona con el insert:
INSERT INTO ASIGNAR VALUES ('12345678A','12345678A',0.5);
--elimina el campo anterior DELETE FROM ASIGNAR WHERE dnimonitor='12345678A' AND ciftienda='12345678A';
--10. Modificar la tabla COMPRAR para que el campo importefinal no pueda ser mayor que el campo importeinicial.
ALTER TABLE COMPRAR ADD CONSTRAINT com_imp_ch CHECK (importeinicial<=importefinal OR importefinal IS NULL OR importeinicial IS NULL);
--Is null es para que si no se introduce nada no de error
--crea un campo para comprobar que funciona con el insert:
INSERT INTO TIENDA VALUES ('12345678A','tienda1','123456789');
INSERT INTO COMPRAR VALUES ('12345678A','12345678A','12345678A',TO_DATE('01/01/2019','DD/MM/YYYY'),10,5);
--las values de comprar son (dnialumno,dnimonitor,ciftienda,fecha,importeinicial,importefinal)
--11.modifica la tabla compra para elminar las claves ajenas a monitor y tienda y crea la clave ajena a ASIGNAR
ALTER TABLE COMPRAR DROP CONSTRAINT com_mon_fk;
ALTER TABLE COMPRAR DROP CONSTRAINT com_tie_fk;
ALTER TABLE COMPRAR ADD CONSTRAINT com_mon_fk FOREIGN KEY(dnimonitor,ciftienda) REFERENCES ASIGNAR(dnimonitor,ciftienda);
--Ejercicio 12: imprimir el numero de restricciones
SELECT COUNT(*) FROM USER_CONSTRAINTS;
--Ejercicio 13: imprimir el numero de restricciones de cada tipo de restriccion
SELECT CONSTRAINT_TYPE, COUNT(*) FROM USER_CONSTRAINTS GROUP BY CONSTRAINT_TYPE;
--la r es de referencia, la p es de primary key, la u es de unique, la c es de check