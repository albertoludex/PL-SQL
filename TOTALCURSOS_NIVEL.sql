CREATE OR REPLACE FUNCTION TOTALCURSOS_NIVEL(p_nivel CURSO.NUMNIVEL%TYPE)
RETURN NUMBER
IS
    total NUMBER;
BEGIN
    SELECT COUNT(*) INTO total
    FROM CURSO
    WHERE NUMNIVEL=p_nivel;

    RETURN total;
END;
/
-- la / es para que se ejecute directamente si se copia y se pega en el run
/*
SELECT totalcursos_nivel(1) FROM DUAL;--> Esta linea al run dentro del usuario para comprobar que lo hemos hecho correctamente
--dual lo usamos para hacer este tipo de consultas*/