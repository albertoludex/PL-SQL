SET SERVEROUTPUT ON 
CREATE OR REPLACE PROCEDURE LISTADO1_CURSOS_MONITOR (p_dnimonitor VARCHAR)
IS
    CURSOR c_cursos_monitor IS
        SELECT fechaini, horario, numnivel, numero
        FROM CURSO
        WHERE UPPER (CURSO.dnimonitor) = UPPER(pc_dni)
        ORDER BY fechaini;
BEGIN
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Monitor: ' || dni_monitor);
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------');
    
    FOR registro IN c_datos(p_dnimonitor) LOOP
        DBMS_OUTPUT.PUT_LINE(registro.fechaini || ' '||
                             registro.horario || ' '  ||
                             registro.numnivel || ' ' ||
                             registro.numero);
    END LOOP;
    