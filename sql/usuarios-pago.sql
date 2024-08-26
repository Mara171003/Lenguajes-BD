
--------------------------------------------------------------------------------
--USUARIO
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_insert_usuario (
    p_id_usuario IN NUMBER,
    p_nombre IN VARCHAR2,
    p_primer_apellido IN VARCHAR2,
    p_segundo_apellido IN VARCHAR2,
    p_correo IN VARCHAR2,
    p_tipo_suscripcion IN VARCHAR2,
    p_id_rol IN NUMBER,
    p_password IN VARCHAR2,
    p_result OUT VARCHAR2
) AS
BEGIN
    INSERT INTO USUARIO (ID_USUARIO, NOMBRE, PRIMER_APELLIDO, SEGUNDO_APELLIDO, CORREO, TIPO_SUSCRIPCION, ID_ROL, PASSWORD)
    VALUES (seq_usuario_id.NEXTVAL, p_nombre, p_primer_apellido, p_segundo_apellido, p_correo, p_tipo_suscripcion, p_id_rol, p_password);

    p_result := 'Insertado correctamente';
EXCEPTION
    WHEN OTHERS THEN
        p_result := SQLERRM;
END;
/

CREATE OR REPLACE PROCEDURE sp_update_usuario (
    p_id_usuario IN NUMBER,
    p_nombre IN VARCHAR2,
    p_primer_apellido IN VARCHAR2,
    p_segundo_apellido IN VARCHAR2,
    p_correo IN VARCHAR2,
    p_tipo_suscripcion IN VARCHAR2,
    p_id_rol IN NUMBER,
    p_password IN VARCHAR2,
    p_result OUT VARCHAR2
) AS
BEGIN
    UPDATE USUARIO
    SET NOMBRE = p_nombre,
        PRIMER_APELLIDO = p_primer_apellido,
        SEGUNDO_APELLIDO = p_segundo_apellido,
        CORREO = p_correo,
        TIPO_SUSCRIPCION = p_tipo_suscripcion,
        ID_ROL = p_id_rol,
        PASSWORD = p_password
    WHERE ID_USUARIO = p_id_usuario;

    p_result := 'Actualizado correctamente';
EXCEPTION
    WHEN OTHERS THEN
        p_result := SQLERRM;
END;
/

CREATE OR REPLACE PROCEDURE sp_get_usuario (
    p_id_usuario IN NUMBER,
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT ID_USUARIO, NOMBRE, PRIMER_APELLIDO, SEGUNDO_APELLIDO, CORREO, TIPO_SUSCRIPCION, ID_ROL
        FROM USUARIO
        WHERE ID_USUARIO = p_id_usuario;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

--** Para admin **--
CREATE OR REPLACE PROCEDURE sp_get_usuario_admin (
    p_id_usuario IN NUMBER,
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT ID_USUARIO, NOMBRE, PRIMER_APELLIDO, SEGUNDO_APELLIDO, CORREO, TIPO_SUSCRIPCION, ID_ROL
        FROM USUARIO
        WHERE ID_USUARIO != p_id_usuario;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE sp_get_correo (
    p_correo IN VARCHAR2,
    p_existe OUT NUMBER
) AS
BEGIN
    SELECT COUNT(*) INTO p_existe
    FROM usuario
    WHERE correo = p_correo;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE sp_get_usuario_X_correo (
    p_correo IN VARCHAR2,
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    -- Abre un cursor para seleccionar los datos
    OPEN p_cursor FOR
    SELECT * 
    FROM USUARIO
    WHERE CORREO = p_correo;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE sp_usuario_login (
    p_correo IN VARCHAR2,
    p_password IN VARCHAR2,
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT *
        FROM USUARIO
        WHERE CORREO = p_correo and PASSWORD = p_password;
        
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


CREATE OR REPLACE PROCEDURE sp_get_usuario_filter (
    p_id_usuario IN NUMBER,
    p_estado IN VARCHAR2 DEFAULT NULL,
    p_nombre IN VARCHAR2 DEFAULT NULL,
    p_apellido IN VARCHAR2 DEFAULT NULL,
    p_cursor_usuario OUT SYS_REFCURSOR
) AS
     v_sql VARCHAR2(1000);
BEGIN
    --indicar que muestre todos los usuarios menos el de admin
     v_sql := 'SELECT * FROM V_USUARIOS_PAGOS WHERE ID_USUARIO != ' || p_id_usuario;

--filtros-----
--verifica contenido de parametros y concatena los where= y los and where, para la consulta final.

    IF p_nombre IS NOT NULL THEN
        v_sql := v_sql || ' AND NOMBRE LIKE ''%' || p_nombre || '%''';
    END IF;
    
    IF p_apellido IS NOT NULL THEN
        v_sql := v_sql || ' AND (PRIMER_APELLIDO LIKE ''%' || p_apellido || '%'' OR SEGUNDO_APELLIDO LIKE ''%' || p_apellido || '%'')';
    END IF;
    
    IF p_estado IS NOT NULL THEN
        v_sql := v_sql || ' AND ESTADO = ''' || p_estado || '''';
    END IF;
    
    OPEN p_cursor_usuario FOR v_sql;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE sp_update_usuario (
    p_valor VARCHAR2,
    p_id_usuario IN NUMBER
) AS
BEGIN
    UPDATE USUARIO
    SET TIPO_SUSCRIPCION = p_valor
    WHERE ID_USUARIO = p_id_usuario;

    IF SQL%ROWCOUNT > 0 THEN
        COMMIT;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

--------------------------------------------------------------------------------
--DETALLES USUARIO
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_insert_detalles_usuario
AFTER INSERT ON USUARIO
FOR EACH ROW
BEGIN
    -- llama al procedimiento almacenado con el ID_USUARIO del nuevo registro
    sp_insertar_detalles_usuario(:NEW.ID_USUARIO);
END;
/

CREATE OR REPLACE PROCEDURE sp_insertar_detalles_usuario (
    p_id_usuario IN NUMBER
) AS
BEGIN
    INSERT INTO DETALLES_USUARIO (
        ID_DETALLE, FECHA_NACIMIENTO, ALTURA_PERSONA, PESO_PERSONA,
        LESIONES, MEDICAMENTOS, EMBARAZO, CIRUGIA, OBJETIVOS, ID_USUARIO
    ) VALUES (
        seq_detalle_id.NEXTVAL, TO_DATE('2000-01-01', 'YYYY-MM-DD'), '0', '0', 'vacio', 'vacio', 'vacio', 'vacio', 'vacio', p_id_usuario
    );
    commit;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

--
CREATE OR REPLACE PROCEDURE sp_update_detalles_usuario (
    p_fecha_nacimiento IN DATE,
    p_altura_persona IN VARCHAR2,
    p_peso_persona IN VARCHAR2,
    p_lesiones IN VARCHAR2,
    p_medicamentos IN VARCHAR2,
    p_embarazo IN VARCHAR2,
    p_cirugia IN VARCHAR2,
    p_objetivos IN VARCHAR2,
    p_id_usuario IN NUMBER
    
) AS
BEGIN
    UPDATE DETALLES_USUARIO
    SET FECHA_NACIMIENTO = p_fecha_nacimiento,
        ALTURA_PERSONA = p_altura_persona,
        PESO_PERSONA = p_peso_persona,
        LESIONES = p_lesiones,
        MEDICAMENTOS = p_medicamentos,
        EMBARAZO = p_embarazo,
        CIRUGIA = p_cirugia,
        OBJETIVOS = p_objetivos
    WHERE ID_USUARIO = p_id_usuario;

    IF SQL%ROWCOUNT > 0 THEN
        COMMIT;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

--SP llamar vista usuario detalles
CREATE OR REPLACE PROCEDURE sp_get_v_usuario_detalles (
    p_id_usuario IN NUMBER,
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT *
    FROM V_USUARIOS_DETALLES
    WHERE ID_USUARIO = p_id_usuario;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

--------------------------------------------------------------------------------
-- Vistas
--------------------------------------------------------------------------------
--USUARIO
--------------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_USUARIOS_DETALLES AS
SELECT 
    U.ID_USUARIO,
    U.NOMBRE,
    U.PRIMER_APELLIDO,
    U.SEGUNDO_APELLIDO,
    U.CORREO,
    U.TIPO_SUSCRIPCION,
    U.ID_ROL,
    D.ID_DETALLE,
    D.FECHA_NACIMIENTO,
    D.ALTURA_PERSONA,
    D.PESO_PERSONA,
    D.LESIONES,
    D.MEDICAMENTOS,
    D.EMBARAZO,
    D.CIRUGIA,
    D.OBJETIVOS
FROM 
    USUARIO U
LEFT JOIN 
    DETALLES_USUARIO D
ON 
    U.ID_USUARIO = D.ID_USUARIO;
/

CREATE OR REPLACE VIEW V_USUARIOS_PAGOS AS
SELECT 
    U.ID_USUARIO,
    U.NOMBRE,
    U.PRIMER_APELLIDO,
    U.SEGUNDO_APELLIDO,
    U.CORREO,
    U.TIPO_SUSCRIPCION,
    U.ID_ROL,
    P.ID_PAGO,
    P.MONTO,
    P.DIA_PAGO,
    P.ESTADO
FROM 
    USUARIO U
LEFT JOIN 
    PAGOS P
ON 
    U.ID_USUARIO = P.ID_USUARIO;
/
--------------------------------------------------------------------------------
--PAGOS
-------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_verificar_pagos (
    p_id_usuario IN NUMBER,
    p_existe OUT NUMBER
) AS
BEGIN

    SELECT COUNT(*) INTO p_existe
    FROM PAGOS
    WHERE ID_USUARIO = p_id_usuario;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE sp_get_pagos (
    p_id_usuario IN NUMBER,
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_PAGO, MONTO, DIA_PAGO, ESTADO
    FROM PAGOS
    WHERE ID_USUARIO = p_id_usuario;
END;
/

CREATE OR REPLACE PROCEDURE sp_update_pagos (
    p_id_usuario IN NUMBER,
    p_monto IN NUMERIC,
    p_dia_pago IN NUMBER,
    p_estado IN VARCHAR2
) AS
BEGIN
    UPDATE PAGOS
    SET MONTO = p_monto,
    DIA_PAGO = p_dia_pago,
    ESTADO = p_estado
    WHERE ID_USUARIO = p_id_usuario;

    IF SQL%ROWCOUNT > 0 THEN
        COMMIT;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE sp_insert_pagos (
    p_id_usuario IN NUMBER,
    p_monto IN NUMBER,
    p_dia_pago IN NUMBER,
    p_estado IN VARCHAR2
) AS
BEGIN
    -- Insertar un nuevo registro en la tabla PAGOS
    INSERT INTO PAGOS (ID_PAGO, MONTO, DIA_PAGO, ESTADO,ID_USUARIO)
    VALUES (seq_pagos_id.NEXTVAL, p_monto, p_dia_pago, p_estado,p_id_usuario);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

--****************************************************************************

CREATE OR REPLACE PACKAGE pkg_usuario AS
    -- Inserciones
    PROCEDURE sp_insert_usuario (
        p_id_usuario IN NUMBER,
        p_nombre IN VARCHAR2,
        p_primer_apellido IN VARCHAR2,
        p_segundo_apellido IN VARCHAR2,
        p_correo IN VARCHAR2,
        p_tipo_suscripcion IN VARCHAR2,
        p_id_rol IN NUMBER,
        p_password IN VARCHAR2,
        p_result OUT VARCHAR2
    );

    PROCEDURE sp_insertar_detalles_usuario (
        p_id_usuario IN NUMBER
    );

    -- Actualizaciones
    PROCEDURE sp_update_usuario (
        p_id_usuario IN NUMBER,
        p_nombre IN VARCHAR2,
        p_primer_apellido IN VARCHAR2,
        p_segundo_apellido IN VARCHAR2,
        p_correo IN VARCHAR2,
        p_tipo_suscripcion IN VARCHAR2,
        p_id_rol IN NUMBER,
        p_password IN VARCHAR2,
        p_result OUT VARCHAR2
    );

    PROCEDURE sp_update_detalles_usuario (
        p_fecha_nacimiento IN DATE,
        p_altura_persona IN FLOAT,
        p_peso_persona IN FLOAT,
        p_lesiones IN VARCHAR2,
        p_medicamentos IN VARCHAR2,
        p_embarazo IN VARCHAR2,
        p_cirugia IN VARCHAR2,
        p_objetivos IN VARCHAR2,
        p_id_usuario IN NUMBER
    );

    -- Consultas
    PROCEDURE sp_get_usuario (
        p_id_usuario IN NUMBER,
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE sp_get_usuario_admin (
        p_id_usuario IN NUMBER,
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE sp_get_correo (
        p_correo IN VARCHAR2,
        p_existe OUT NUMBER
    );

    PROCEDURE sp_get_usuario_X_correo (
        p_correo IN VARCHAR2,
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE sp_usuario_login (
        p_correo IN VARCHAR2,
        p_password IN VARCHAR2,
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE sp_get_usuario_filter (
        p_id_usuario IN NUMBER,
        p_estado IN VARCHAR2 DEFAULT NULL,
        p_nombre IN VARCHAR2 DEFAULT NULL,
        p_apellido IN VARCHAR2 DEFAULT NULL,
        p_cursor_usuario OUT SYS_REFCURSOR
    );

    PROCEDURE sp_get_v_usuario_detalles (
        p_id_usuario IN NUMBER,
        p_cursor OUT SYS_REFCURSOR
    );

    -- Triggers
    PROCEDURE trg_insert_detalles_usuario (
        p_id_usuario IN NUMBER
    );
END pkg_usuario;
/

CREATE OR REPLACE PACKAGE BODY pkg_usuario AS
    PROCEDURE sp_insert_usuario (
        p_id_usuario IN NUMBER,
        p_nombre IN VARCHAR2,
        p_primer_apellido IN VARCHAR2,
        p_segundo_apellido IN VARCHAR2,
        p_correo IN VARCHAR2,
        p_tipo_suscripcion IN VARCHAR2,
        p_id_rol IN NUMBER,
        p_password IN VARCHAR2,
        p_result OUT VARCHAR2
    ) AS
    BEGIN
        INSERT INTO USUARIO (ID_USUARIO, NOMBRE, PRIMER_APELLIDO, SEGUNDO_APELLIDO, CORREO, TIPO_SUSCRIPCION, ID_ROL, PASSWORD)
        VALUES (seq_usuario_id.NEXTVAL, p_nombre, p_primer_apellido, p_segundo_apellido, p_correo, p_tipo_suscripcion, p_id_rol, p_password);

        p_result := 'Insertado correctamente';
    EXCEPTION
        WHEN OTHERS THEN
            p_result := SQLERRM;
    END sp_insert_usuario;

    PROCEDURE sp_insertar_detalles_usuario (
        p_id_usuario IN NUMBER
    ) AS
    BEGIN
        INSERT INTO DETALLES_USUARIO (
            ID_DETALLE, FECHA_NACIMIENTO, ALTURA_PERSONA, PESO_PERSONA,
            LESIONES, MEDICAMENTOS, EMBARAZO, CIRUGIA, OBJETIVOS, ID_USUARIO
        ) VALUES (
            seq_detalle_id.NEXTVAL, TO_DATE('2000-01-01', 'YYYY-MM-DD'), NULL, NULL, NULL, NULL, NULL, NULL, NULL, p_id_usuario
        );
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END sp_insertar_detalles_usuario;

    PROCEDURE sp_update_usuario (
        p_id_usuario IN NUMBER,
        p_nombre IN VARCHAR2,
        p_primer_apellido IN VARCHAR2,
        p_segundo_apellido IN VARCHAR2,
        p_correo IN VARCHAR2,
        p_tipo_suscripcion IN VARCHAR2,
        p_id_rol IN NUMBER,
        p_password IN VARCHAR2,
        p_result OUT VARCHAR2
    ) AS
    BEGIN
        UPDATE USUARIO
        SET NOMBRE = p_nombre,
            PRIMER_APELLIDO = p_primer_apellido,
            SEGUNDO_APELLIDO = p_segundo_apellido,
            CORREO = p_correo,
            TIPO_SUSCRIPCION = p_tipo_suscripcion,
            ID_ROL = p_id_rol,
            PASSWORD = p_password
        WHERE ID_USUARIO = p_id_usuario;

        p_result := 'Actualizado correctamente';
    EXCEPTION
        WHEN OTHERS THEN
            p_result := SQLERRM;
    END sp_update_usuario;

    PROCEDURE sp_update_detalles_usuario (
        p_fecha_nacimiento IN DATE,
        p_altura_persona IN FLOAT,
        p_peso_persona IN FLOAT,
        p_lesiones IN VARCHAR2,
        p_medicamentos IN VARCHAR2,
        p_embarazo IN VARCHAR2,
        p_cirugia IN VARCHAR2,
        p_objetivos IN VARCHAR2,
        p_id_usuario IN NUMBER
    ) AS
    BEGIN
        UPDATE DETALLES_USUARIO
        SET FECHA_NACIMIENTO = p_fecha_nacimiento,
            ALTURA_PERSONA = p_altura_persona,
            PESO_PERSONA = p_peso_persona,
            LESIONES = p_lesiones,
            MEDICAMENTOS = p_medicamentos,
            EMBARAZO = p_embarazo,
            CIRUGIA = p_cirugia,
            OBJETIVOS = p_objetivos
        WHERE ID_USUARIO = p_id_usuario;

        IF SQL%ROWCOUNT > 0 THEN
            COMMIT;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END sp_update_detalles_usuario;

    PROCEDURE sp_get_usuario (
        p_id_usuario IN NUMBER,
        p_cursor OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT ID_USUARIO, NOMBRE, PRIMER_APELLIDO, SEGUNDO_APELLIDO, CORREO, TIPO_SUSCRIPCION, ID_ROL
            FROM USUARIO
            WHERE ID_USUARIO = p_id_usuario;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END sp_get_usuario;

    PROCEDURE sp_get_usuario_admin (
        p_id_usuario IN NUMBER,
        p_cursor OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT ID_USUARIO, NOMBRE, PRIMER_APELLIDO, SEGUNDO_APELLIDO, CORREO, TIPO_SUSCRIPCION, ID_ROL
            FROM USUARIO
            WHERE ID_USUARIO != p_id_usuario;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END sp_get_usuario_admin;

    PROCEDURE sp_get_correo (
        p_correo IN VARCHAR2,
        p_existe OUT NUMBER
    ) AS
    BEGIN
        SELECT COUNT(*) INTO p_existe
        FROM USUARIO
        WHERE CORREO = p_correo;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END sp_get_correo;

    PROCEDURE sp_get_usuario_X_correo (
        p_correo IN VARCHAR2,
        p_cursor OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
        SELECT * 
        FROM USUARIO
        WHERE CORREO = p_correo;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END sp_get_usuario_X_correo;

    PROCEDURE sp_usuario_login (
        p_correo IN VARCHAR2,
        p_password IN VARCHAR2,
        p_cursor OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT *
            FROM USUARIO
            WHERE CORREO = p_correo and PASSWORD = p_password;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END sp_usuario_login;

    PROCEDURE sp_get_usuario_filter (
        p_id_usuario IN NUMBER,
        p_estado IN VARCHAR2 DEFAULT NULL,
        p_nombre IN VARCHAR2 DEFAULT NULL,
END pkg_usuario;
/       

