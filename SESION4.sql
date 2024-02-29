-- cl scr para limpiar pantalla
--SELECT TABLE_NAME FROM USER_TABLES;
--2.eliminar al alumno con email sortiz@hotmail.com
SELECT * FROM ALUMNO WHERE email='sortiz@hotmail.com';
--ahora eliminar ese alumno
DELETE FROM ALUMNO WHERE email= 'sortiz@hotmail.com';
/*3.- Elimina a la alumna con email chuertas@gmail.com. ¿Qué ocurre? ¿Por qué?
Utiliza todas las instrucciones necesarias para poder borrarla de la BD. En los criterios de
selección de registros (en el WHERE) de la instrucción DELETE solamente puedes
comparar con el dato del email (es decir, no puedes buscar el DNI de esta alumna y escribir
directamente su valor en la instrucción).*/

SELECT * FROM ALUMNO WHERE email='chuertas@gmail.com';
DELETE FROM ALUMNO WHERE email= 'chuertas@gmail.com';
-- asi debe de dar un error con violated-child-record found, para arreglarlo primera hay que eliminarla de la matricula  y luego de alumno
DELETE FROM MATRICULAR
WHERE dnialumno=(SELECT dni FROM ALUMNO WHERE email= 'chuertas@gmail.com');
DELETE FROM ALUMNO WHERE email= 'chuertas@gmail.com';

/*4.- ¿Hay algún alumno que no esté matriculado en ningún curso? Realiza una consulta que
obtenga los DNIs de dichos alumnos. En caso de que haya alumnos no matriculados,
elimínalos de la BD. (Una instrucción DELETE con SELECT).*/
SET PAGESIZE 30
SELECT * FROM ALUMNO ORDER BY dni;
SELECT * FROM ALUMNO WHERE email= 'chuertas@gmail.com';
SELECT * FROM MATRICULAR ORDER BY dni

/*5*/
--Las siguientes lineas de código son para que se vea mejor el resultado de las consultas
    SELECT dni AS "ALUMNO:DNI"
    FROM ALUMNO 
    ORDER BY dni;
    SELECT dni 
    FROM ALUMNO 
    WHERE dni NOT IN (SELECT DISTINCT  dnialumno FROM MATRICULA)
    ORDER BY dni;

    -- borrar los alumnos
    DELETE FROM ALUMNO 
    WHERE dni NOT IN (SELECT DISTINCT  dnialumno FROM MATRICULA);

--5.1.- ¿Cómo se llama la restricción que es clave principal en MATRICULAR?
    SELECT table_name, constraint_name, constraint_type FROM user_constraints ORDER BY table_name;
    --table_name es el nombre de la tabla
    --constraint_name es el nombre de la restriccion
    --constraint_type es el tipo de restriccion
    --user_constraints es una tabla que contiene todas las restricciones de la bd

--5.2.- ¿Qué columnas forman parte de la clave principal en MATRICULAR y en qué orden?
COLUMN column_name FORMAT A20
-- el format es para que se vea mejor el resultado
-- lo que hace el format es que el nombre de la columna se vea en 20 caracteres
SELECT * FROM USER_CONS_COLUMNS WHERE TABLE_NAME = 'MATRICULA'AND CONSTRAINT_NAME = 'MAT_DNI_NIV_CUR_PK';

--5.3.- ¿Cómo se llama en la base de datos la restricción que hace referencia a la clave ajena a ALUMNO?
SELECT constraint_name,constraint_type FROM user_constraints WHERE table_name = 'MATRICULA' AND constraint_type = 'R';
SELECT table_name, constraint_name, constraint_type FROM user_constraints ORDER BY table_name;
--5.4.- En MATRICULAR, ¿qué columna/s forman la clave ajena a ALUMNO?
--USER_CONS_COLUMNS es una tabla que contiene todas las columnas de las restricciones de la bd 
SELECT column_name FROM USER_CONS_COLUMNS WHERE constraint_name = 'MAT_DNI_ALU_FK';
--5.5.- En ALUMNO, ¿a qué columna/s hace referencia la clave ajena que va de MATRICULAR a ALUMNO?
SELECT  table_name, constraint_name, column_name FROM USER_CONS_COLUMNS WHERE constraint_name = 'ALU_DNI_PK';
SELECT column_name FROM USER_CONS_COLUMNS WHERE constraint_name = 'ALU_DNI_PK';
/*5.6.- ¿Cómo se llama el campo de USER_CONSTRAINTS que indica el comportamiento
de una clave ajena ante borrados? ¿Cuál es el comportamiento de la restricción que es
clave ajena de MATRICULAR a ALUMNO?*/
--delete_rule es el campo de user_constraints que indica el comportamiento de una clave ajena ante borrados
DESC USER_CONSTRAINTS;
SELECT table_name, constraint_name,constraint_type FROM USER_CONSTRAINTS ORDER BY table_name;
COLUMN delete_rule FORMAT 12
-- parar ver la columna delete_rule tenemos que hacer DESC USER_CONSTRAINTS
--delete_rule se usa para ver el comportamiento de una clave ajena ante borrados
SELECT delete_rule
FROM USER_CONSTRAINTS
WHERE table_name = 'MATRICULA' AND constraint_name = 'MAT_DNI_ALU_FK';

/*6.- En esta actividad vas a tener que modificar la estructura de las tablas (ALTER TABLE)
para realizar los borrados que se indican.*/

-- en las siguientes lineas lo que estamos haciendo es que estamos borrando la restriccion de la tabla matricula y luego la estamos añadiendo de nuevo pero con el on delete cascade que lo que hace es que cuando borremos un alumno de la tabla alumno se borre automaticamente de la tabla matricula
ALTER TABLE MATRICULA
    DROP CONSTRAINT mat_alu_fk;

ALTER TABLE MATRICULA
    ADD CONSTRAINT MAT_ALU_FK

    FOREIGN KEY (dnialumno) REFERENCES ALUMNO
    ON DELETE CASCADE;

--el select de abajo es para ver que se ha borrado la restriccion y se ha añadido de nuevo
SELECT table_name, constraint_name,constraint_type FROM USER_CONSTRAINTS ORDER BY table_name;

/*6.1.- Al borrar a un alumno de la tabla ALUMNO se quiere que automáticamente se borren
todas sus matriculaciones. Haz los cambios necesarios en la restricción correspondiente*/
ALTER TABLE MATRICULA
    DROP CONSTRAINT mat_alu_fk;
    -- la tenemos que añadir con el ON DELETE CASCADE


    /*6.2.- Al eliminar una pista de la BD se quiere que automáticamente los cursos que se
impartían en dicha pista no tengan pista asignada. Haz los cambios en la restricción
correspondiente.
La pista COBRE se encuentra en muy mal estado. La dirección ha decidido no arreglarla
ya que se tiene previsto realizar una piscina en el espacio que ocupa esta pista y así ampliar
la oferta de servicios del club. Elimina la pista COBRE de la BD y verifica que todos los
cursos que se imparten en esa pista no tengan pista asignada.*/
--1º se borra la fk de la tabla curso
ALTER TABLE CURSO
    DROP CONSTRAINT cur_pis_fk;
--2º añadimos la fk de nuevo pero con el on delete set null
ALTER TABLE CURSO
    ADD CONSTRAINT CUR_PIS_FK
    FOREIGN KEY (pista) REFERENCES PISTA ON DELETE SET NULL


--3º 
    SELECT numnivel, numero, pista FROM CURSO  WHERE pista = 'COBRE';
    DELETE FROM PISTA WHERE codigo = 'COBRE';
    SELECT numnivel, numero, pista FROM CURSO

    /*7.- En esta actividad vas a trabajar con la activación y desactivación de restricciones
(ALTER TABLE).
Modifica el DNI del alumno Unay Ramos que es 54234567M a 54234567P. ¿Se puede
cambiar? ¿Por qué?
En Oracle no existe la instrucción ON UPDATE CASCADE para las claves ajenas. Una
forma de hacer esta actualización consiste en:
1) identificar el nombre de la restricción que es clave ajena
2) deshabilitar temporalmente la restricción
3) realizar los cambios en los datos y
4) habilitar la restricción una vez realizados los cambios.
Realiza todas las instrucciones necesarias para modificar el DNI del alumno.*/
    SELECT * FROM ALUMNO WHERE dni = '54234567M';
UPDATE SET dni = '54234567P' WHERE dni = '54234567M';
--deshabilitar la restriccion, actualizar dni alumno, actualizar dni matricula y habiiitar la restriccion
DESC USER_CONSTRAINTS;
SELECT table_name, constraint_name, status FROM USER_CONSTRAINTS ORDER BY constraint_name;
ALTER TABLE MATRICULA
    MODIFY CONSTRAINT MAT_ALU_FK DISABLE;

UPDATE ALUMNO
    SET dni = '54234567P'
    WHERE dni = '54234567M';

UPDATE MATRICULA
    SET dnialumno = '54234567P'
    WHERE dnialumno = '54234567M';
ALTER TABLE MATRICULA
    MODIFY CONSTRAINT MAT_ALU_FK ENABLE;







