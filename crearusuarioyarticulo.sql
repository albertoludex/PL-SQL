CONNECT system/bdadmin

CREATE USER PRACTICA5 IDENTIFIED BY P5;
GRANT CONNECT, RESOURCE TO PRACTICA5;

CONNECT PRACTICA5/P5


CREATE TABLE ARTICULO
(
    codigo VARCHAR2(6) CONSTRAINT art_cod_pk PRIMARY KEY,
    stock  NUMBER(3) DEFAULT 0 
                    CONSTRAINT art_sto_nn NOT NULL 
                    CONSTRAINT art_sto_ch CHECK (stock >= 0)
);

INSERT INTO ARTICULO VALUES ('ART1',2);
INSERT INTO ARTICULO VALUES ('ART2',10);

SHOW USER

COMMIT;

/*1.1.- Inserta el artículo ART3 con 4 unidades. Comprueba que se han introducido los datos.*/
INSERT INTO ARTICULO VALUES ('ART3',4);
SELECT * FROM ARTICULO;
/*1.2.- Crea la tabla PEDIDO según el diseño lógico que se indica. De los pedidos se guarda el número
de pedido (único), el artículo que se pide y el número de unidades. Los tipos de datos de los campos
son NUMBER, VARCHAR2(6) y NUMBER(3), respectivamente.*/
CREATE TABLE PEDIDO
(
    num_pedido NUMBER(3) CONSTRAINT ped_num_pk PRIMARY KEY,
    cod_articulo VARCHAR2(6) CONSTRAINT ped_art_fk REFERENCES ARTICULO(codigo),
    unidades NUMBER(3) CONSTRAINT ped_uni_nn NOT NULL
);

--1.3.- Cancela la transacción (ROLLBACK).
ROLLBACK;
--1.4.- ¿Se debe haber guardado el artículo ART3? ¿Y la tabla PEDIDO? ¿Por qué?
-- se guarda el articulo ART3 porque se ha hecho un rollback despues de crear una tabla,la tabla pedido tambien se guarda.

--1.5 comprueba cual es la solucion
SELECT * FROM ARTICULO;
SELECT * FROM PEDIDO;

----------------------------------------------2----------------------------------------------------------------------------
--2.1.- Se realiza un pedido de 2 unidades del artículo ART1. Este pedido es el número 1. Inserta el pedido.
INSERT INTO PEDIDO VALUES (1,'ART1',2);
--2.2.- Como se han pedido 2 unidades del artículo ART1, actualiza el stock de dicho artículo con 2 unidades menos
UPDATE ARTICULO SET stock = stock - 2 WHERE codigo = 'ART1';
--2.3.- Comprueba que se han hecho los cambios.
SELECT * FROM ARTICULO;
SELECT * FROM PEDIDO;
--2.4.- Confirma la transacción.
COMMIT;
--2.5.- Se quieren pedir 3 unidades más del artículo en el pedido 1. Actualiza el pedido.
UPDATE PEDIDO SET unidades = unidades + 3 WHERE num_pedido = 1;
/*2.6.- Como se han pedido 3 unidades más hay que actualizar el stock disponible del artículo del
pedido 1. Actualiza el stock de dicho artículo restándole 3 unidades. ¿Qué ocurre?*/
UPDATE ARTICULO SET stock = stock - 3 WHERE codigo = 'ART1';
--Nos dara error porque ya estaba a cero el stock de art1
--2.7.- ¿Qué datos contienen las tablas? ¿Dejarías la base de datos así?
SELECT * FROM ARTICULO;
SELECT * FROM PEDIDO;
/*2.8.- Cancela esta transacción para mantener la consistencia de los datos y comprueba que se han
deshecho los cambios de esta transacción*/
ROLLBACK;

/*2.9.- Inserta el pedido 2 en el que se piden 3 unidades del artículo ART2 y actualiza el stock de este
artículo restándole 3 unidades*/
INSERT INTO PEDIDO VALUES (2 ,'ART2',3);
UPDATE ARTICULO SET stock =stock - 3 WHERE codigo = 'ART2';
--2.10.- Establece un punto de control llamado punto1.
SAVEPOINT punto1;
/*2.11.- Inserta el pedido 3 en el que se piden 5 unidades del artículo ART1 y actualiza el stock de
este artículo restándole 5 unidades.*/
INSERT INTO PEDIDO VALUES (3,'ART1',5);
UPDATE ARTICULO SET stock = stock - 5 WHERE codigo = 'ART1';
--2.12.- Comprueba que se han hecho los cambios.
SELECT * FROM ARTICULO;
SELECT * FROM PEDIDO;
--que informacion devuelve:
--2.13.- Compruébalo.
SELECT * FROM ARTICULO;
SELECT * FROM PEDIDO;
--2.14.- Confirma la transacción.
COMMIT;
----------------------------------------------------3--------------------------------------------------------------------
/*3.1.- Dada la siguiente situación, ¿qué problema de concurrencia es?
a) Actualización perdida
b) Lectura sucia
c) Lectura no repetible
d) Lectura fantasma*/
--c) Lectura no repetible PORQUE SE HAN LEIDO DATOS QUE NO SE HAN CONFIRMADO

/*ventana-1
1.- Consultar los datos del artículo ART1.
SELECT * FROM ARTICULO WHERE codigo = 'ART1';
6.- Consultar los datos del artículo ART1.
SELECT * FROM ARTICULO WHERE codigo = 'ART1';
7.- Finalizar la transacción confirmándola.
COMMIT;
*/

/*Ventana2
2.- Consultar los datos del artículo ART1.
SELECT * FROM ARTICULO WHERE codigo = 'ART1';
3.- Actualizar el stock del artículo ART1 a 15.
UPDATE ARTICULO SET stock = 15 WHERE codigo = 'ART1';
4.- Consultar los datos del artículo ART1.
SELECT * FROM ARTICULO WHERE codigo = 'ART1';
5.- Confirmar transacción.
COMMIT;
*/

-------------------------------------------------------------4-----------------------------------------------------------




/*3.2.- Abre una nueva aplicación de SQL Plus en otra ventana y entra con el mismo usuario y
contraseña. Tendrás dos ventanas abiertas: la Ventana 1, que es donde has trabajado las
actividades anteriores y la Ventana 2, que es la que acabas de abrir. Introduce en cada ventana las
instrucciones para realizar las acciones en el orden que se indica. ¿Se presenta el problema de
concurrencia?
a) Sí
b) No*/
--a) SI porque se han leido datos que no se han confirmado

--3.3.- Actualiza la tabla ARTICULO para que contenga los datos iniciales y confirma la transacción.
UPDATE ARTICULO SET stock = 0 WHERE codigo = 'ART1';

/*3.4.- Establece el nivel de aislamiento de la transacción de la Ventana 1 a SERIALIZABLE con la
instrucción SET TRANSACTION y vuelve a realizar las transacciones. ¿Se produce el problema?
a) Sí
b) No*/

        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- el set es para cambiar el nivel de aislamiento
-- el transaction es para cambiar el nivel de aislamiento de la transaccion
-- el isolation level es para cambiar el nivel de aislamiento de la transaccion
-- el level es para cambiar el nivel de aislamiento de la transaccion
--el serializable es el nivel de aislamiento mas alto

/*3.5.- En la Ventana 1, ¿cuál debe ser el valor del stock del artículo ART1 tras finalizar la transacción
de esta ventana?
a) 0
b) 15
c) Ninguno de los anteriores*/
--b) 15
SELECT * FROM ARTICULO WHERE codigo = 'ART1';

--3.6.- Actualiza la tabla ARTICULO a su estado inicial y confirma la transacción.
UPDATE ARTICULO SET stock = 0 WHERE codigo = 'ART1';


/*4.1.- Realiza las acciones de cada transacción en el orden que se indica y ves respondiendo a las
preguntas conforme vayas realizando las acciones*/

/*Ventana 1:
1.- Consultar los datos del artículo ART1.
SELECT * FROM ARTICULO WHERE codigo = 'ART1';
2.- Incrementar su stock en 2 unidades.
UPDATE ARTICULO SET stock = stock + 2 WHERE codigo = 'ART1';
3.- Consultar los datos del artículo ART1.
SELECT * FROM ARTICULO WHERE codigo = 'ART1';
6.- Confirmar transacción.(
COMMIT;
*/

/*ventana2:
4.- Consultar los datos del artículo ART1.
SELECT * FROM ARTICULO WHERE codigo = 'ART1';
5.- Incrementar su stock en 10 unidades.
UPDATE ARTICULO SET stock = stock + 10 WHERE codigo = 'ART1';
7.- Confirmar transacción.
COMMIT;
*/

/*4.1.1.- Después de realizar la acción 4, ¿cuál debe ser el stock de ART1 en la ventana 2?
a) 0
b) 2
c) 17
d) Ninguno de los anteriores
*/
-- la opcion correcta es la c) 17 porque el nivel de aislamiento es read committed y no se bloquea la fila
/*4.1.2.- Después de realizar la acción 5, ¿qué ocurre en la transacción de la ventana 2?
a) Se actualiza el valor.
b) La transacción da un error.
c) La transacción se bloquea*/
--c) La transacción se bloquea 

/*4.1.3.- Después de realizar la acción 6, ¿qué ocurrirá si se consulta el stock del artículo ART1 en la
transacción de la ventana 2?
a) Se muestra un 10.
b) Se muestra un 12.
c) La transacción de la ventana 2 se bloquea.
d) La transacción de la ventana 2 da un error*/
--b) Se muestra un 12.
--4.2.- Actualiza la tabla ARTICULO con los datos iniciales y confirma la transacción.
UPDATE ARTICULO SET stock = 0 WHERE codigo = 'ART1';
/*4.3.- Establece el modo de aislamiento a SERIALIZABLE en las transacciones de las dos ventanas
y ejecútalas de nuevo. ¿Cuál de estas opciones es correcta?
a) La transacción de la ventana 2 da error.
b) Después de realizar la acción 4, la transacción de la ventana 2 se bloquea.
c) Después de realizar la acción 4, el stock de ART1 es 2*/
--c) Después de realizar la acción 4, el stock de ART1 es 2
SELECT * FROM ARTICULO WHERE codigo = 'ART1';
--1. haz el serializable
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;


--4.4.- Actualiza la tabla ARTICULO con los datos iniciales y confirma la transacción.
UPDATE ARTICULO SET stock = 0 WHERE codigo = 'ART1';


----------------------------------------Actividad 5: Agencia de viajes---------------------------
/*Crea la tabla AUTOBUS que contiene la matrícula (clave principal) y el número de plazas libres.
Inserta el autobús del viaje cuya matrícula es 1234FGH y en el que quedan 5 plazas libres.*/
CREATE TABLE AUTOBUS
(
    matricula VARCHAR2(10) CONSTRAINT aut_mat_pk PRIMARY KEY,
    libres NUMBER
);

INSERT INTO AUTOBUS VALUES ('1234FGH',5);


/*A continuación, se presentan tres posibles escenarios. El nivel de aislamiento de la base de datos
es READ COMMITTED. Indica en qué condiciones consideras más adecuado un escenario u otro.
a) Escenario 1: SELECT
b) Escenario 2: SELECT… FOR UPDATE
c) Escenario 3: SELECT… FOR UPDATE NOWAIT*/

/*Escenario 1: (SELECT)
El SELECT no bloquea la fila, por lo que se pueden hacer consultas simultaneas
 OFICINA 1: 4 PLAZAS
1.- Consulta las plazas del autobús 1234FGH.
(Informa al cliente que quedan 5 libres)
SELECT * FROM AUTOBUS WHERE matricula = '1234FGH';
3.- El cliente indica que se haga la reserva.
Actualiza el número de plazas libres del
autobús restándole 4 unidades
UPDATE AUTOBUS SET libres = libres - 4 WHERE matricula = '1234FGH';
5.- Confirma la transacción.
COMMIT;
*/

/*OFICINA 2: 2 PLAZAS
2.- Consulta las plazas del autobús 1234FGH.
¿Quedan suficientes plazas libres?
(Informa al cliente)
SELECT * FROM AUTOBUS WHERE matricula = '1234FGH';
4.- Realiza la reserva, disminuyendo en 2
unidades las plazas libres
UPDATE AUTOBUS SET libres = libres - 2 WHERE matricula = '1234FGH';
6.- Confirma la transacción.
COMMIT;
*/
UPDATE AUTOBUS SET libres = libres -2 WHERE MATRICULA = '1234FGH';

/*Escenario 2: (SELECT ... FOR UPDATE) 
el FOR UPDATE bloquea la fila para que no se pueda modificar
Oficina1: 4 plazas
1.- Consulta las plazas del autobús 1234FGH. ( informa al cliente que quedan 5 libres)
SELECT * FROM AUTOBUS WHERE matricula = '1234FGH';
3.- El cliente indica que se haga la reserva. (Actualiza el número de plazas libres del autobús restándole 4 unidades)
UPDATE AUTOBUS SET libres = libres - 4 WHERE matricula = '1234FGH';
4.- Confirma la transacción.
COMMIT;
*/

/*Oficina2: 2 plazas
2.- Consulta las plazas del autobús 1234FGH. (Informa al cliente)
SELECT * FROM AUTOBUS WHERE matricula = '1234FGH';
¿que ocurre? se bloquea la fila
5.-¿Hay suficientes plazas libres?
 SELECT * FROM AUTOBUS WHERE matricula = '1234FGH' FOR UPDATE;
6. Finaliza la transacción.
COMMIT;
*/

UPDATE AUTOBUS SET libres = libres -2 WHERE MATRICULA = '1234FGH';

/*Escenario 3: (SELECT ... FOR UPDATE NOWAIT) 
el FOR UPDATE NOWAIT bloquea la fila y si no se puede bloquear da error

Oficina1: 4 plazas
1.- Consulta las plazas del autobús 1234FGH. ( informa al cliente que quedan 5 libres)
SELECT * FROM AUTOBUS WHERE matricula = '1234FGH';
3.- El cliente indica que se haga la reserva. (Actualiza el número de plazas libres del autobús restándole 4 unidades)
UPDATE AUTOBUS SET libres = libres - 4 WHERE matricula = '1234FGH';
4.- Confirma la transacción.
COMMIT;
Oficina2: 2 plazas
2.- Consulta las plazas del autobús 1234FGH.¿Que ocurre? se bloquea la fila
SELECT * FROM AUTOBUS WHERE matricula = '1234FGH';
4.-Consulta las plazas del autobus 1234FGH ¿ Que ocurre? da error
SELECT * FROM AUTOBUS WHERE matricula = '1234FGH' FOR UPDATE NOWAIT;
6.- Consulta las plazas del autobus 1234FGH ¿ Hay suficientes plazas libres? (Informa al cliente) 
SELECT * FROM AUTOBUS WHERE matricula = '1234FGH' FOR UPDATE NOWAIT;
7.- Confirma la transacción.
COMMIT;
*/





----------------------------------------6---------------------------------------
/*Realiza un resumen sobre las recomendaciones que darías sobre el uso de COMMIT, ROLLBACK,
puntos de control, cómo se comportan las transacciones cuando acceden a recursos utilizados
concurrentemente por otras transacciones según el tipo de nivel de aislamiento, cuándo utilizar la
instrucción SELECT con las opciones FOR UPDATE y FOR UPDATE NOWAIT.*/
--COMMIT: confirma la transaccion
--ROLLBACK: deshace la transaccion
--puntos de control: se utiliza para deshacer una parte de la transaccion
--SELECT FOR UPDATE: bloquea la fila para que no se pueda modificar
--SELECT FOR UPDATE NOWAIT: bloquea la fila para que no se pueda modificar y si no se puede bloquear da error
