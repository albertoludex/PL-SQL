--practica 10, disparadores



------------------------------------------------------CREACION DE
--USUARIO--------------------------------------------
/*SQL> CREATE USER PRACTICA10 IDENTIFIED BY P10;

User created.

SQL> GRANT CONNECT, RESOURCE TO PRACTICA10;*/
----------------------------------------------------------------------------------------------------------------------



/*1.- Crea una tabla llamada BAJAS con la misma estructura que la tabla ALUMNO y
dos nuevos campos llamados usuario y fechabaja cuyos tipos de datos son texto de
tamaño 15 y fecha, respectivamente. Crea un disparador que cada vez que se borre
a un alumno lo inserte en BAJAS con todos sus datos y además asigne a los campos
usuario y fechabaja el usuario que ha dado de baja al alumno y la fecha en que
se ha realizado, respectivamente.*/
CREATE TABLE BAJAS(
   dni          VARCHAR2(10) CONSTRAINT baj_dni_pk PRIMARY KEY, 
   nombre       VARCHAR2(25), 
   apellido1    VARCHAR2(25), 
   telefono     VARCHAR2(30), 
   fechanac     DATE, 
   sexo         VARCHAR2(1) CONSTRAINT baj_sex_ch CHECK (sexo IN ('H','M')),
   email        VARCHAR2(30),
   usuario      VARCHAR2(15),
   fechabaja    DATE
);
CREATE OR REPLACE TRIGGER INSERTAR_BAJAS AFTER DELETE ON ALUMNO
FOR EACH ROW
BEGIN
INSERT INTO BAJAS VALUES (:OLD.dni, :OLD.nombre, :OLD.apellido1, :OLD.telefono, :OLD.fechanac,:OLD.sexo, :OLD.email,USER, SYSDATE);
END;
/
--set LINESIZE 120;
--para comprobar esto lo que haremos sera:
SELECT * FROM BAJAS;
--y luego borramos un alumno
DELETE FROM ALUMNO WHERE dni = '54234568K'; 
--y volvemos a hacer la consulta
SELECT * FROM BAJAS;

/*2.- La dirección del club ha decidido que solamente se pueden dar de alta a
alumnos con edad superior a 7 años. En el caso de que se intente dar de alta a
un niño que no tenga la edad requerida se activará un disparador que imprimirá
el mensaje: “No se realiza el alta. El alumno con DNI DNI no tiene la edad
mínima.”. Para calcular la edad utiliza la función EDAD_REAL, creada en la
práctica 9 de la sesión de funciones*/
--hazlo sin signal sqlstate
CREATE OR REPLACE TRIGGER edadminima BEFORE INSERT ON ALUMNO
FOR EACH ROW
BEGIN
IF EDAD_ANYO(:NEW.fechanac) < 7  OR (:NEW.fechanac IS NULL) THEN
RAISE_APPLICATION_ERROR(-20001, 'No se realiza el alta. El alumno con DNI ' || :NEW.dni || ' no tiene la edad mínima.');
END IF;
END;
/

--Para comprobar esto lo que haremos sera:
    INSERT INTO ALUMNO (dni, nombre, apellido1, telefono, fechanac, sexo) VALUES ('33000311M', 'Juan', 'Garcia', '605112233', '01/01/2015', 'H');
--y nos dara el siguiente error:
--Error starting at line : 1 in command -

/*3.- El precio de un curso no se puede incrementar en más del 10% de su precio.
Crea un disparador que en caso de que se intente asignar un precio con un valor
superior a dicho incremento, le asigne el incremento máximo permitido (10%) e
imprima el mensaje “El precio del curso número del nivel nivel se incrementa el
máximo permitido (10%): precioantiguo -> precionuevo”. En caso de que el precio
que se quiere asignar no supere el 10%, se asigna dicho precio y no se emite
ningún mensaje.*/


CREATE OR REPLACE TRIGGER before_insert_curso
BEFORE INSERT ON cursos
FOR EACH ROW
DECLARE
    precio_maximo NUMBER;
BEGIN
    precio_maximo := :OLD.precio * 1.1;

    IF :NEW.precio > precio_maximo THEN
        :NEW.precio := precio_maximo;
    
    
        DBMS_OUTPUT.PUT_LINE('El precio del curso número ' || :NEW.id_curso || ' del nivel ' || :NEW.nivel || ' se incrementa al máximo permitido (10%): ' || :OLD.precio || ' -> ' || :NEW.precio);
    END IF;
    --añadimos exception para mas del 10%
    EXCEPTION
    WHEN OTHERS THEN
    
END;
/
--para comprobacion:
UPDATE CURSO SET PRECIO = 1000 WHERE NUMERO = 1;
--Para que falle el trigger:
UPDATE CURSO SET PRECIO = 1001 WHERE NUMERO = 1;
/*4.- Dado el siguiente diagrama, crea las tablas y disparadores para controlar
que la generalización sea disjunta, de forma que si se intenta que un empleado
sea a la vez comercial y programador se imprima un mensaje adecuado y no se
realicen cambios en los datos de las tablas.*/
CREATE TABLE EMPLEADO (
dni VARCHAR(9) PRIMARY KEY,
nombre VARCHAR(15),
apellido1 VARCHAR(30),
salario NUMBER
);
CREATE TABLE COMERCIAL (
dni VARCHAR(9) PRIMARY KEY,
comision FLOAT,
FOREIGN KEY (dni) REFERENCES EMPLEADO (dni)
);
CREATE TABLE PROGRAMADOR (
dni VARCHAR(9) PRIMARY KEY,
lenguaje VARCHAR(15),
FOREIGN KEY (dni) REFERENCES EMPLEADO (dni)
);
DELIMITER //
CREATE TRIGGER disjunta BEFORE INSERT ON COMERCIAL
FOR EACH ROW
BEGIN
IF EXISTS (SELECT * FROM PROGRAMADOR WHERE dni = NEW.dni) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede insertar el empleado ' + NEW.dni + ' como comercial porque ya es programador.';
END IF;
END//
DELIMITER ;
DELIMITER //
CREATE TRIGGER disjunta BEFORE INSERT ON PROGRAMADOR
FOR EACH ROW
BEGIN
IF EXISTS (SELECT * FROM COMERCIAL WHERE dni = NEW.dni) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede insertar el empleado ' + NEW.dni + ' como programador porque ya es comercial.';
END IF;
END//
DELIMITER ;

/*5.- Busca información sobre qué son las tablas mutantes, cuándo se produce y
cómo solucionarlo. /*Una tabla mutante es una tabla que se está modificando y
que se referencia a sí misma. Esto puede ocurrir cuando se ejecuta una sentencia
DML (INSERT, UPDATE o DELETE) en una tabla y se referencia a la misma tabla en
una subconsulta, una cláusula WHERE o una cláusula HAVING de la misma
sentencia.*/