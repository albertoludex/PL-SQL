SET SERVEROUTPUT ON 
CREATE OR REPLACE PROCEDURE DATOS_MONITOR (p_codigo IN MONITOR.codigo%TYPE) IS
    v_DNI MONITOR.DNI%TYPE;
    v_nombre MONITOR.nombre%TYPE;
    v_apellido1 MONITOR.apellido1%TYPE;
BEGIN
    SELECT DNI, nombre, apellido1 INTO v_DNI, v_nombre, v_apellido1
    FROM MONITOR
    WHERE codigo = p_codigo;

    DBMS_OUTPUT.PUT_LINE(v_DNI || ' ' || v_nombre || ' ' || v_apellido1);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('El monitor con apodo ' || p_codigo || ' no existe.');
END DATOS_MONITOR;
/
--haz una comprobacion del procedimiento anterior
EXEC DATOS_MONITOR('Pepito');
/*2.- Crea un procedimiento llamado MATRICULAR_ALUMNONIVELCURSO que dados el DNI de un
alumno, un número de nivel y un número de curso, matricule al alumno en dichos números de nivel
y curso, si el curso no está completo. Un curso está completo cuando hay 4 alumnos matriculados.
Si no hay errores al insertar el registro, se matriculará al alumno y el procedimiento imprimirá:
“Se ha matriculado al alumno dnialumno en el curso numerocurso del nivel numeronivel.”
Si el curso está completo no se matriculará al alumno y se imprimirá:
“No quedan plazas en el curso numerocurso del nivel numeronivel.”
Controla los errores que se indican a continuación utilizando excepciones e imprimiendo el mensaje
que se indica. La excepción 1 habrá que definirla y hacerla saltar en el sitio adecuado, la excepción
2 se controlará por su número y la excepción 3 por su nombre. Una vez funcione correctamente el
procedimiento confirma (COMMIT) dentro del procedimiento la transacción para que los cambios en
la matriculación del alumno sean permanentes.*/

-- el numero de plazas es 4 como maximo
CREATE OR REPLACE PROCEDURE MATRICULAR_ALUMNONIVELCURSO (p_DNI IN ALUMNO.DNI%TYPE, p_numnivel IN NIVEL.numero%TYPE, p_numcurso IN CURSO.numero%TYPE) IS
    v_numalumnos NUMBER(2);
BEGIN
    SELECT COUNT(*) INTO v_numalumnos
    FROM MATRICULAR
    WHERE nivel = p_numnivel AND curso = p_numcurso;

    IF v_numalumnos < 4 THEN
        INSERT INTO MATRICULAR (dnialumno, nivel, curso)
        VALUES (p_DNI, p_numnivel, p_numcurso);

        DBMS_OUTPUT.PUT_LINE('Se ha matriculado al alumno ' || p_DNI || ' en el curso ' || p_numcurso || ' del nivel ' || p_numnivel || '.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No quedan plazas en el curso ' || p_numcurso || ' del nivel ' || p_numnivel || '.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('El nivel ' || p_numnivel || ' o el curso ' || p_numcurso || ' no existe.');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('El alumno ' || p_DNI || ' ya está matriculado en el curso ' || p_numcurso || ' del nivel ' || p_numnivel || '.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error desconocido.');
        
    -- sacar nombre de la excepcion
    -- DBMS_OUTPUT.PUT_LINE(SQLERRM);
END MATRICULAR_ALUMNONIVELCURSO;
--Para comprobar el procedimiento anterior, ejecuta las siguientes sentencias:
EXEC MATRICULAR_ALUMNONIVELCURSO('33000111M', 1, 1);

/*Sesión de prácticas: Práctica 9
PL/SQL: Manejo de excepciones
2 / 3
3 (Nombre) Matricular a un alumno en un
curso en el que ya está
matriculado.
“El alumno dnialumno ya estaba matriculado en
el curso numerocurso del nivel numeronivel.”
A continuación, se muestran diferentes ejemplos de ejecución y su salida por pantalla.
3.- Crea un procedimiento llamado ELIMINAR_CURSOSVACIOS_FECHAS que realice las
siguientes acciones:
• Acción 1: Mostrar un listado de los cursos cuya fecha de inicio esté comprendida entre las
fechas que se indiquen como primer y segundo parámetros. El listado estará ordenado por la
fecha de inicio.
Para realizar esta acción puedes llamar al procedimiento ESTADO_CURSOS_FECHAINICIO
implementado en la práctica anterior para mostrar el listado. En el caso de que no lo tengas
creado impleméntalo ahora. La información que imprime este procedimiento (un curso por línea)
es la siguiente:
fechainicio nivel numerocurso totalalumnos estado
Los valores que puede tomar el estado son:
SIN ALUMNOS No hay alumnos matriculados en el curso.
Sesión de prácticas: Práctica 9
PL/SQL: Manejo de excepciones
3 / 3
QUEDAN PLAZAS Hay algún alumno matriculado y no se ha llegado al máximo
recomendado.
COMPLETO El número de alumnos matriculados coincide con el máximo
recomendado.
OVERBOOKING Se ha superado el máximo número recomendado de alumnos por curso.
El máximo número recomendado de alumnos en un curso es 4.
• Acción 2: Eliminar los cursos que no tengan alumnos e imprimir cuántos cursos se hanCREATE OR REPLACE PROCEDURE ELIMINAR_CURSOSVACIOS_FECHAS (p_fechainicio1 IN CURSO.fechaini%TYPE, p_fechainicio2 IN CURSO.fechaini%TYPE) IS
    v_numcursos NUMBER(2);
BEGIN
    ESTADO_CURSOS_FECHAINICIO(p_fechainicio1, p_fechainicio2);

    DELETE FROM CURSO
    WHERE numero NOT IN (SELECT curso FROM MATRICULAR)
    AND fechaini BETWEEN p_fechainicio1 AND p_fechainicio2;

    v_numcursos := SQL%ROWCOUNT;

    IF v_numcursos > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Se han eliminado ' || v_numcursos || ' cursos.');
        ESTADO_CURSOS_FECHAINICIO(p_fechainicio1, p_fechainicio2);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('No se ha podido realizar el borrado. ' || SQLCODE || ': ' || SQLERRM);
END ELIMINAR_CURSOSVACIOS_FECHAS;
eliminado.
• Acción 3: Si se ha eliminado algún curso se mostrará de nuevo el listado de los cursos que hay
tras realizar el borrado (llamada al procedimiento ESTADO_CURSOS_FECHAINICIO).
Se utilizará la sección EXCEPTION para controlar cualquier excepción que se pueda producir y se
imprimirá el mensaje “No se ha podido realizar el borrado”, el número de excepción que se produce
y el mensaje que el SGBD tiene asociado.
Una vez hayas comprobado que el procedimiento funciona correctamente, confirma el borrado de
los registros dentro del procedimiento.
En la siguiente imagen se muestra un ejemplo de ejecución del procedimiento.*/


CREATE ESTADO_CURSOS_FECHAINICIO (p_fechainicio1 IN CURSO.fechaini%TYPE, p_fechainicio2 IN CURSO.fechaini%TYPE) IS
    CURSOR c_cursos IS
        SELECT fechaini, numnivel, numero, COUNT(*) AS totalalumnos
        FROM CURSO c
        LEFT JOIN MATRICULAR m ON c.numero = m.curso
        --el left join es para que salgan todos los cursos aunque no tengan alumnos
        WHERE fechaini BETWEEN p_fechainicio1 AND p_fechainicio2
        GROUP BY fechaini, numnivel, numero
        ORDER BY fechaini;

    v_fechaini CURSO.fechaini%TYPE;
    v_numnivel NIVEL.numero%TYPE;
    v_numero CURSO.numero%TYPE;
    v_totalalumnos NUMBER(2);
    v_estado VARCHAR2(20);
BEGIN
    DBMS_OUTPUT.PUT_LINE('fechainicio nivel numerocurso totalalumnos estado');

    FOR c_curso IN c_cursos LOOP
        v_fechaini := c_curso.fechaini;
        v_numnivel := c_curso.numnivel;
        v_numero := c_curso.numero;
        v_totalalumnos := c_curso.totalalumnos;

        IF v_totalalumnos = 0 THEN
            v_estado := 'SIN ALUMNOS';
        ELSIF v_totalalumnos < 4 THEN
            v_estado := 'QUEDAN PLAZAS';
        ELSIF v_totalalumnos = 4 THEN
            v_estado := 'COMPLETO';
        ELSE
            v_estado := 'OVERBOOKING';
        END IF;

        DBMS_OUTPUT.PUT_LINE(v_fechaini || ' ' || v_numnivel || ' ' || v_numero || ' ' || v_totalalumnos || ' ' || v_estado);
    END LOOP;
END ESTADO_CURSOS_FECHAINICIO;
--PARA COMPROBAR EL PROCEDIMIENTO ANTERIOR, EJECUTA LAS SIGUIENTES SENTENCIAS:
EXEC ELIMINAR_CURSOSVACIOS_FECHAS('01/01/2023', '01/01/2024');


CREATE OR REPLACE PROCEDURE ELIMINAR_CURSOSVACIOS_FECHAS (p_fechainicio1 IN CURSO.fechaini%TYPE, p_fechainicio2 IN CURSO.fechaini%TYPE) IS
    v_numcursos NUMBER(2);
BEGIN
    ESTADO_CURSOS_FECHAINICIO(p_fechainicio 1, p_fechainicio2);

    DELETE FROM CURSO
    WHERE numero NOT IN (SELECT curso FROM MATRICULAR)
    AND fechaini BETWEEN p_fechainicio1 AND p_fechainicio2;

    v_numcursos := SQL%ROWCOUNT;

    IF v_numcursos > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Se han eliminado ' || v_numcursos || ' cursos.');
        ESTADO_CURSOS_FECHAINICIO(p_fechainicio1, p_fechainicio2);
        --llama otra vez al procedimiento para que se vea el cambio
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No hay cursos que eliminar.');
    
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error de clave duplicada.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('No se ha podido realizar el borrado. ' || SQLCODE || ': ' || SQLERRM);    
    
END ELIMINAR_CURSOSVACIOS_FECHAS;


--ejemplo de ejecucion del procedimiento
EXEC ELIMINAR_CURSOSVACIOS_FECHAS('01/01/2023', '01/01/2024');