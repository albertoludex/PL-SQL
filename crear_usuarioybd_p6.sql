connect system/bdadmin

CREATE USER PRACTICA6 IDENTIFIED BY P6;
GRANT CONNECT, RESOURCE TO PRACTICA6;

CONNECT PRACTICA6/P6


CREATE TABLE ASIGNATURA
(
   codigo    VARCHAR2(5) CONSTRAINT asi_cod_pk PRIMARY KEY,
   nombre    VARCHAR2(40),
   ncreditos NUMBER,
   observaciones VARCHAR2(50)
);


CREATE TABLE ALUMNO
(
   dni       VARCHAR2(10) CONSTRAINT alu_dni_pk PRIMARY KEY,
   nombre    VARCHAR2(15),
   apellido1 VARCHAR2(15),
   apellido2 VARCHAR2(15),
   ciudad    VARCHAR2(20),
   provincia VARCHAR2(15),
   telefono  VARCHAR2(15), 
   fechanac  DATE,
   estadocivil  VARCHAR2(1) CONSTRAINT alu_est_ch CHECK (estadocivil IN ('S','C','V','P','D'))
);

CREATE TABLE MATRICULAR(
   dni,
   codasig,
   convocatoria  VARCHAR2(7),
   nota     NUMBER,
   CONSTRAINT mat_dni_cod_conv_pk PRIMARY KEY(dni,codasig,convocatoria),
   CONSTRAINT mat_dni_alu FOREIGN KEY (dni) REFERENCES ALUMNO,
   CONSTRAINT mat_cod_asi FOREIGN KEY (codasig) REFERENCES ASIGNATURA
);

INSERT INTO ASIGNATURA VALUES ('ATW','Administracion de Tecnologias Web',6,NULL);
INSERT INTO ASIGNATURA VALUES ('CP','Computacion Paralela',6,NULL);
INSERT INTO ASIGNATURA VALUES ('DGBD','Diseño y Gestion de Bases de Datos',6,NULL);


INSERT INTO ALUMNO VALUES ('11111111A','ANTONIO','FLORES','MARTINEZ',
                           'ELCHE','ALICANTE','648675612',
                           '01/01/2000','S');
INSERT INTO ALUMNO VALUES ('22222222A','ALBERTO','SOLER','GONZALEZ',
                           'BURJASSOT','VALENCIA','654332211',
                           '15/03/2000','S');
INSERT INTO ALUMNO VALUES ('33333333A','TERESA','MORENO','VIEJO',
                           'ELCHE','ALICANTE','905643234',
                           '20/06/2000','S');
INSERT INTO ALUMNO VALUES ('44444444A','JOSE MIGUEL','FLORES','SOLER',
                           'BENIEL','MURCIA','612334455',
                           '07/09/1991','P');
INSERT INTO ALUMNO VALUES ('55555555A','ANTONIA','ORTIZ','MANRESA',
                           'CASTELLON','CASTELLON','645337892',
                           '12/10/1990','D');
INSERT INTO ALUMNO VALUES ('66666666A','JAVIER','TORRES','MARIN',
                           'ORIHUELA','ALICANTE','602223334',
                           '26/11/1985','D');
INSERT INTO ALUMNO VALUES ('77777777A','PATRICIA','GARCIA','ALBADALEJO',
                           'BETERA','VALENCIA','602223334',
                           '26/11/1985','C');
INSERT INTO ALUMNO VALUES ('88888888A','SUSANA','PRIETO','MORA',
                           'ORIHUELA','ALICANTE','602223334',
                           '26/11/1985','C');
INSERT INTO ALUMNO VALUES ('99999999A','MARIA','PEREZ','ROCAMORA',
                           'MURCIA','MURCIA','605223311',
                           '20/05/2000','S');


INSERT INTO MATRICULAR VALUES ('11111111A','ATW','ORD2122',7);
INSERT INTO MATRICULAR VALUES ('22222222A','ATW','ORD2122',4);
INSERT INTO MATRICULAR VALUES ('22222222A','ATW','EXT2122',6);
INSERT INTO MATRICULAR VALUES ('33333333A','ATW','ORD2122',8);
INSERT INTO MATRICULAR VALUES ('44444444A','ATW','EXT2122',3);
INSERT INTO MATRICULAR VALUES ('55555555A','ATW','EXT2122',9);
INSERT INTO MATRICULAR VALUES ('22222222A','CP','ORD2122',3);
INSERT INTO MATRICULAR VALUES ('22222222A','CP','EXT2122',4);
INSERT INTO MATRICULAR VALUES ('55555555A','CP','ORD2122',8);
INSERT INTO MATRICULAR VALUES ('66666666A','CP','ORD2122',3);
INSERT INTO MATRICULAR VALUES ('77777777A','CP','ORD2122',5);
INSERT INTO MATRICULAR VALUES ('22222222A','DGBD','ORD2122',6);
INSERT INTO MATRICULAR VALUES ('33333333A','DGBD','ORD2122',8);
INSERT INTO MATRICULAR VALUES ('88888888A','DGBD','ORD2122',5);
INSERT INTO MATRICULAR VALUES ('99999999A','DGBD','ORD2122',3);
INSERT INTO MATRICULAR VALUES ('99999999A','DGBD','EXT2122',5);
INSERT INTO MATRICULAR VALUES ('11111111A','DGBD','ORD2122',7);
INSERT INTO MATRICULAR VALUES ('11111111A','DGBD','EXT2122',3);
COMMIT;

SHOW USER

/*2.- Realiza las acciones necesarias para que el usuario PRACTICA6 cree una vista llamada
ALUMNOSCV que contenga todos los datos de la tabla ALUMNO correspondientes a los alumnos
de la Comunidad Valenciana, ordenados por el primer apellido y luego por el segundo apellido.*/

--CONNECT SYSTEM/bdadmin y ahi hacemos el grant
--el GRANT es para que el usuario PRACTICA6 pueda crear vistas
GRANT CREATE VIEW TO PRACTICA6;
--Una vez realiza el grant nos volvemos a conectar al user PRACTICA6
CREATE OR REPLACE VIEW ALUMNOSCV 
AS SELECT * FROM ALUMNO WHERE PROVINCIA IN ('VALENCIA','ALICANTE','CASTELLON') ORDER BY APELLIDO1,APELLIDO2;

/*3.- El usuario PRACTICA6 quiere modificar la provincia del alumno con DNI 88888888A con el valor
“Murcia” utilizando la vista ALUMNOSCV. ¿Se puede realizar el cambio? ¿Por qué? En caso de que
lo permita, realiza los cambios*/
--Select con todas las provincias
SELECT PROVINCIA FROM ALUMNOSCV;
UPDATE ALUMNOSCV SET PROVINCIA='MURCIA' WHERE DNI='88888888A';
--
--si se puede realizar el cambio porque la vista es actualizable

/*4.- PRACTICA6 crea una vista llamada RESUMEN_MATRICULACIONES. En esta vista se obtiene
para cada asignatura el código, nombre y número total de matriculaciones, ordenados
descendentemente por este valor. Inserta un nuevo registro en MATRICULAR y comprueba que se
actualiza convenientemente la vista.*/
--Imprime tabla matricular
    SELECT * FROM MATRICULAR;

CREATE OR REPLACE VIEW RESUMEN_MATRICULACIONES
AS SELECT CODASIG, NOMBRE, COUNT(*) AS NUM_MATRICULACIONES FROM MATRICULAR, ASIGNATURA WHERE CODIGO=CODASIG GROUP BY CODASIG, NOMBRE ORDER BY NUM_MATRICULACIONES DESC;
--el group by es para agrupar por asignatura y nombre porque si no no se puede hacer el count

--Insertamos un nuevo registro en matricular
INSERT INTO MATRICULAR VALUES ('11111111A','ATW','ORD2122',7);
--COMPRUBEA QUE SE ACTUALIZA LA VISTA
SELECT * FROM RESUMEN_MATRICULACIONES;

/*5.- PRACTICA6 crea una vista llamada ALUMNOS_SPD. Esta vista contiene todos los datos de los
alumnos cuyo estado civil es soltero, separado o divorciado y permitirá realizar cambios en cualquier
campo, insertar registros si el estado civil es separado o divorciado.*/
--restriccion para que no se pueda modificar el estado civil
--with check option usarlo 

--listado de restricciones de alumnos
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='ALUMNO';
CREATE OR REPLACE VIEW ALUMNOS_SPD
AS SELECT * FROM ALUMNO WHERE ESTADOCIVIL IN ('S','P','D') WITH CHECK OPTION CONSTRAINT ALU_SPD_ESC;
--el check option es para que no se pueda modificar el estado civil, solo se podra modificar s con p y d, p con d y d con p, si queremos cambiar de s a v o c no se podra

/*6.- Entra como SYSTEM. ¿Qué usuarios hay creados en la base de datos? Realiza una consulta
sobre la vista del sistema adecuada para que muestre únicamente el nombre de los usuarios.*/
    SELECT USERNAME FROM DBA_USERS;
CONNECT SYSTEM/bdadmin;

/*7.- ¿Cuál de los campos de DBA_USERS indica si un usuario está o no bloqueado? Bloquea a
PRACTICA6 (usuario creado en la actividad anterior) para que no pueda acceder a la BD y
comprueba qué valor tiene este campo para PRACTICA6*/
SELECT USERNAME, ACCOUNT_STATUS FROM DBA_USERS;
ALTER USER PRACTICA6 ACCOUNT LOCK;
/*8.- PRACTICA6 abre una nueva sesión de SQL-Plus e intenta acceder a su cuenta. Comprueba
que no puede hacerlo y que se muestra el mensaje correspondiente de bloqueo.*/
--CONNECT PRACTICA6/P6
--no se puede conectar porque esta bloqueado porque el campo account_status es locked
/*9.- Desbloquea a PRACTICA6 y verifica que se ha actualizado el campo que controla si un usuario
está o no bloqueado.*/
ALTER USER PRACTICA6 ACCOUNT UNLOCK;

/*11.- ¿Qué roles tiene PRACTICA6? Realiza una consulta desde SYSTEM sobre la vista adecuada
que obtenga esta información*/
CONNECT SYSTEM/bdadmin;
--EL DBA_ROLE_PRIVS ES PARA VER LOS ROLES QUE TIENE EL USUARIO
--EL DBA_SYS_PRIVS ES PARA VER LOS PRIVILEGIOS QUE TIENE EL USUARIO
SELECT * FROM  DBA_SYS_PRIVS WHERE GRANTEE='PRACTICA6';
SELECT * FROM  DBA_ROLE_PRIVS WHERE GRANTEE='PRACTICA6';

/*12.- ¿Qué privilegios/permisos tiene el rol RESOURCE? Realiza las consultas sobre las vistas
adecuadas para obtener esta información.*/
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE='RESOURCE';
SELECT * FROM  DBA_ROLE_PRIVS WHERE GRANTEE='RESOURCE';
-- el rol resource es un rol que tiene privilegios de crear tablas, vistas, secuencias, procedimientos, funciones, triggers, indices, etc
/*13.- Crea un usuario llamado CRISTINA con contraseña CRI.*/
CONNECT SYSTEM/bdadmin;
CREATE USER CRISTINA IDENTIFIED BY CRI;
GRANTEE CONNECT, RESOURCE TO CRISTINA;

/*14.- Abre una nueva ventana y asígnale el color de fondo rosa. CRISTINA se intenta conectar a la
base de datos en esta ventana. No debe permitir conectarse.
Asígnale el rol o privilegio necesario para que solamente pueda conectarse.
CRISTINA se conecta (en la ventana rosa).*/
CONNECT SYSTEM/bdadmin;
GRANT CONNECT  TO CRISTINA;
/*15.- PRACTICA6 (ventana azul) concede permisos a CRISTINA sobre la vista ALUMNOSCV
(creada en la Actividad 1) para que pueda consultar y modificar los datos de los alumnos a través
de esta vista.*/
CONNECT PRACTICA6/P6
GRANT SELECT, UPDATE ON ALUMNOSCV TO CRISTINA;
--el update es para que pueda modificar los datos de los alumnos a traves de la vista en la que se le ha dado permiso
/*16.- CRISTINA (ventana rosa) consulta los datos de esta vista y le asigna al alumno con DNI
11111111A el primer apellido VAZQUEZ. Recuerda confirmar la transacción (Tema 3) para que se
hagan efectivos los cambios.*/
CONNECT CRISTINA/CRI
SELECT * FROM ALUMNOSCV;
UPDATE ALUMNOSCV SET APELLIDO1='VAZQUEZ' WHERE DNI='11111111A';
COMMIT;
--commit para que se hagan efectivos los cambioS
/*seleccion el alumno para comprobar los cambios
SELECT * FROM ALUMNOSCV WHERE DNI='11111111A';*/

/*17.- PRACTICA6 (ventana azul) realiza una consulta sobre la tabla ALUMNO y verifica que se han
hecho los cambios de CRISTINA.*/

SELECT * FROM ALUMNO WHERE DNI='11111111A';

/*18.- SYSTEM (ventana negra) crea un usuario llamado DANIEL con contraseña DAN y roles de
conexión y recursos*/
CONNECT SYSTEM/bdadmin;
CREATE USER DANIEL IDENTIFIED BY DAN;
GRANT CONNECT, RESOURCE TO DANIEL;
/*19.- DANIEL abre una nueva ventana, se conecta a la base de datos y crea una tabla llamada
FESTIVOS con 2 campos.
El primer campo se llamará día y contiene el día mes y año del día festivo (por ejemplo 06/12/23) y
es la clave principal de la tabla. Su tjpo de datos es fecha. El segundo campo se llamará descripción
y es un texto de longitud 100*/
CONNECT DANIEL/DAN
CREATE TABLE FESTIVOS(
    DIA DATE CONSTRAINT FES_DIA_PK PRIMARY KEY,
    DESCRIPCION VARCHAR2(100)
);

/*Inserta algunos registros. Asigna a la ventana de DANIEL el color de fondo verde. Ahora tendrás 4
ventanas de SQL-Plus abiertas correspondientes a los usuarios SYSTEM, PRACTICA6, CRISTINA
y DANIEL con colores negro, azul, rosa y verde, respectivamente.*/
INSERT INTO FESTIVOS VALUES(TO_DATE('01/01/1999','DD/MM/YYYY') ,'descripcion1');
INSERT INTO FESTIVOS VALUES(TO_DATE('01/01/2000','DD/MM/YYYY') ,'descripcion2');
/*20.- DANIEL (ventana verde) concede a PRACTICA6 permisos de consulta sobre la tabla
FESTIVOS.*/
GRANT SELECT ON FESTIVOS TO PRACTICA6;

/*21.- PRACTICA6 (ventana azul) consulta la información de FESTIVOS, que le ha compartido
DANIEL. Intenta modificar algún dato pero el sistema no debe permitir hacerlo.*/
UPDATE FESTIVOS SET DESCRIPCION= 'descripcion1'WHERE DIA= TO_DATE('01/01/2000', 'DD/MM/YYYY'); 

/*21.- PRACTICA6 (ventana azul) consulta la información de FESTIVOS, que le ha compartido
DANIEL. Intenta modificar algún dato pero el sistema no debe permitir hacerlo.*/
SELECT * FROM FESTIVOS;
UPDATE FESTIVOS SET DIA='2020-12-25' WHERE FECHA='2020-12-25';
/*22.- PRACTICA6 (ventana azul) concede a CRISTINA permisos de consulta sobre la tabla
FESTIVOS que le ha compartido DANIEL. ¿Puede realizar la acción?*/
-- el grant es para que PRACTICA6 pueda compartir la tabla FESTIVOS con CRISTINA
GRANT SELECT ON FESTIVOS TO CRISTINA;
-- Sí puede realizar la acción porque PRACTICA6 tiene permisos de consulta sobre la tabla FESTIVOS y puede compartirlo con CRISTINA
/*23.- DANIEL (ventana verde) concede ahora a PRACTICA6 permisos de consulta sobre la tabla
FESTIVOS para que a su vez éste pueda compartirla con quien quiera*/
GRANT SELECT ON FESTIVOS TO PRACTICA6 WITH GRANT OPTION;
-- el with grant option es para que PRACTICA6 pueda compartir la tabla FESTIVOS con quien quiera

/*24.- PRACTICA6 (ventana azul) concede a CRISTINA permisos de consulta sobre la tabla
FESTIVOS que le ha compartido DANIEL. ¿Puede realizar la acción?*/
GRANT SELECT ON FESTIVOS TO CRISTINA;
-- EL GRANT es para que PRACTICA6 pueda compartir la tabla FESTIVOS con CRISTINA
-- Sí puede realizar la acción porque PRACTICA6 tiene permisos de consulta sobre la tabla FESTIVOS y puede compartirlo con CRISTINA
/*25.- CRISTINA (ventana rosa) consulta la información de la tabla FESTIVOS de DANIEL que le ha
compartido PRACTICA6.*/
CONNECT CRISTINA/CRI
SELECT * FROM FESTIVOS;

/*26.- ¿Cómo sabe DANIEL quién tiene permisos sobre su tabla FESTIVOS? Realiza la consulta
sobre la vista correspondiente del diccionario de datos. DANIEL comprueba que CRISTINA tiene
acceso a su tabla FESTIVOS y quién le ha dado dicho permiso.*/
CONNECT DANIEL/DAN
SELECT * FROM DBA_TAB_PRIVS WHERE TABLE_NAME='FESTIVOS';
--el DBA_TAB_PRIVS es para ver los permisos que tiene cada usuario sobre las tablas
-- grantee es quien tiene permisos, grantor es quien le ha dado los permisos
/*27.- DANIEL (ventana verde) deja de compartir con PRACTICA6 la tabla FESTIVOS. ¿Puede
CRISTINA acceder a los datos de PRUEBA?*/
CONNECT DANIEL/DAN
REVOKE SELECT ON FESTIVOS FROM PRACTICA6;
-- NO puede acceder a los datos de PRUEBA porque DANIEL ha dejado de compartir la tabla FESTIVOS con PRACTICA6
-- el revoke es para quitar los permisos
/*Borra a los usuarios CRISTINA y DANIEL del sistema.*/

CONNECT SYSTEM/bdadmin;
DROP USER CRISTINA CASCADE;
DROP USER DANIEL CASCADE;
--muestra los usuarios que hay
SELECT * FROM DBA_USERS;
