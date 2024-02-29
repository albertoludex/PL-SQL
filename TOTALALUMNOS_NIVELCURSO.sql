CREATE OR REPLACE FUNCTION TOTALALUMNOS_NIVELCURSO (p_nivel NUMBER, p_curso NUMBER)
RETURN NUMBER
IS
   total NUMBER;
BEGIN
   SELECT COUNT(*) INTO total
   FROM MATRICULAR
   WHERE MATRICULAR.nivel = p_nivel AND MATRICULAR.curso = p_curso;
   RETURN total;
END;
/*SELECT TOTALALUMNOS_NIVELCURSO(7,1) FROM DUAL;
    esta linea la usaremos para comprobar que realmente lo hemos hecho bien, lo ejecutaremos en el run dentro del usuario para poder ver que esta bien
*/

