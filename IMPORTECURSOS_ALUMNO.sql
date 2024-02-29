CREATE OR REPLACE FUNCTION IMPORTECURSOS_ALUMNO (p_dni VARCHAR2)
RETURN NUMBER
IS
   total NUMBER;
BEGIN
   SELECT SUM(CURSO.precio)
   INTO total
   FROM CURSO, MATRICULAR
   WHERE MATRICULAR.dnialumno = p_dni AND MATRICULAR.nivel = CURSO.numnivel AND MATRICULAR.curso = CURSO.numero;
   RETURN total;
END;
/*
SELECT IMPORTECURSOS_ALUMNO('54234568K') FROM DUAL;
esta linea la usaremos para comprobar que realmente hemos realizado correctamente la funcion, esto lo tenemos que llevar al run y ejecutarla
*/