--------------------------------------------------------------------------------
--RUTINA
--------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE sp_insert_rutina (
    p_nombre_rutina IN VARCHAR2,
    p_dia_rutina IN VARCHAR2,
    p_id_usuario IN NUMBER
) AS
BEGIN
    INSERT INTO RUTINA (ID_RUTINA, NOMBRE_RUTINA, DIA_RUTINA, ID_USUARIO)
    VALUES (seq_rutina_id.NEXTVAL, p_nombre_rutina, p_dia_rutina, p_id_usuario);

IF SQL%ROWCOUNT > 0 THEN
        COMMIT;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE sp_update_rutina (
    p_id_rutina IN NUMBER,
    p_nombre_rutina IN VARCHAR2,
    p_dia_rutina IN VARCHAR2
) AS
BEGIN
    UPDATE RUTINA
    SET NOMBRE_RUTINA = p_nombre_rutina,
        DIA_RUTINA = p_dia_rutina
    WHERE ID_RUTINA = p_id_rutina;
    
    IF SQL%ROWCOUNT > 0 THEN
        COMMIT;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE sp_delete_rutina (
    p_id_rutina IN NUMBER
) AS
BEGIN
    DELETE FROM RUTINA
    WHERE ID_RUTINA = p_id_rutina;
    
IF SQL%ROWCOUNT > 0 THEN
        COMMIT;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
--Sp consulta listado rutina (id usuario)
CREATE OR REPLACE PROCEDURE sp_get_rutinas (
    p_id_usuario IN NUMBER,
    p_cursor OUT SYS_REFCURSOR
) AS
    BEGIN
    OPEN p_cursor FOR
        SELECT ID_RUTINA, NOMBRE_RUTINA, DIA_RUTINA, ID_USUARIO
        FROM RUTINA
        WHERE ID_USUARIO = p_id_usuario;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

--sp consulta rutina individualmente (id rutina)
CREATE OR REPLACE PROCEDURE sp_get_rutina (
    p_id_rutina IN NUMBER,
    p_cursor OUT SYS_REFCURSOR
) AS
    BEGIN
    OPEN p_cursor FOR
        SELECT ID_RUTINA, NOMBRE_RUTINA, DIA_RUTINA
        FROM RUTINA
        WHERE ID_RUTINA = p_id_rutina;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

--------------------------------------------------------------------------------
--Ejercicio
--------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE sp_insert_ejercicio (
    p_nombre_ejercicio IN VARCHAR2,
    p_setse IN VARCHAR2,
    p_maquina IN VARCHAR2,
    p_observaciones IN VARCHAR2,
    p_id_rutina IN NUMBER
) AS
BEGIN
    INSERT INTO EJERCICIO (ID_EJERCICIO, NOMBRE_EJERCICIO, SETSE, MAQUINA, OBSERVACIONES, ID_RUTINA)
    VALUES (seq_ejercicio_id.NEXTVAL, p_nombre_ejercicio, p_setse, p_maquina, p_observaciones, p_id_rutina);

    IF SQL%ROWCOUNT > 0 THEN
        COMMIT;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE sp_update_ejercicio (
    p_id_ejercicio IN NUMBER,
    p_nombre_ejercicio IN VARCHAR2,
    p_setse IN VARCHAR2,
    p_maquina IN VARCHAR2,
    p_observaciones IN VARCHAR2
) AS
BEGIN
    UPDATE EJERCICIO
    SET NOMBRE_EJERCICIO = p_nombre_ejercicio,
        SETSE = p_setse,
        MAQUINA = p_maquina,
        OBSERVACIONES = p_observaciones
    WHERE ID_EJERCICIO = p_id_ejercicio;
    
    IF SQL%ROWCOUNT > 0 THEN
        COMMIT;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE sp_delete_ejercicio (
    p_id_ejercicio IN NUMBER
) AS
BEGIN
    DELETE FROM EJERCICIO
    WHERE ID_EJERCICIO = p_id_ejercicio;
    
    IF SQL%ROWCOUNT > 0 THEN
        COMMIT;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE sp_get_ejercicios (
    p_id_rutina IN NUMBER,
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT ID_EJERCICIO, NOMBRE_EJERCICIO, SETSE, MAQUINA, OBSERVACIONES, ID_RUTINA
        FROM EJERCICIO
        WHERE ID_RUTINA = p_id_rutina;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE sp_get_ejercicio (
    p_id_ejercicio IN NUMBER,
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT ID_EJERCICIO, NOMBRE_EJERCICIO, SETSE, MAQUINA, OBSERVACIONES
        FROM EJERCICIO
        WHERE ID_EJERCICIO = p_id_ejercicio;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

--Sp consulta listado ejercicios (id rutina)
CREATE OR REPLACE PROCEDURE sp_get_ejercicios (
    p_id_rutina IN NUMBER,
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT ID_EJERCICIO, NOMBRE_EJERCICIO, SETSE, MAQUINA, OBSERVACIONES, ID_RUTINA
        FROM EJERCICIO
        WHERE ID_RUTINA = p_id_rutina;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
commit;
--sp consulta ejercicio individualmente (id ejercicio)
CREATE OR REPLACE PROCEDURE sp_get_ejercicio (
    p_id_ejercicio IN NUMBER,
    p_cursor OUT SYS_REFCURSOR
) AS
    BEGIN
    OPEN p_cursor FOR
        SELECT ID_RUTINA, NOMBRE_RUTINA, DIA_RUTINA
        FROM RUTINA
        WHERE ID_RUTINA = p_id_ejercicio;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

