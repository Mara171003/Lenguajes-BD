--creacion de tablas
CREATE TABLE ROLES (
    ID_ROL INT NOT NULL,
    ROL VARCHAR2(20) NOT NULL
);

CREATE TABLE USUARIO (
    ID_USUARIO INT NOT NULL, 
    NOMBRE VARCHAR2(50) NOT NULL,
    PRIMER_APELLIDO VARCHAR2(50) NOT NULL,
    SEGUNDO_APELLIDO VARCHAR2(50) NOT NULL,
    CORREO VARCHAR2(50) NOT NULL,
    TIPO_SUSCRIPCION VARCHAR2(50) NOT NULL,
    ID_ROL INT,
    PASSWORD VARCHAR2(255)
);

CREATE TABLE DETALLES_USUARIO (
    ID_DETALLE INT NOT NULL, 
    FECHA_NACIMIENTO DATE,
    ALTURA_PERSONA NUMBER(10,2),
    PESO_PERSONA NUMBER(10,2),
    LESIONES VARCHAR2(50),
    MEDICAMENTOS VARCHAR2(100),
    EMBARAZO VARCHAR2(50),
    CIRUGIA VARCHAR2(200),
    OBJETIVOS VARCHAR2(255),
    ID_USUARIO INT NOT NULL
);

CREATE TABLE RUTINA (
    ID_RUTINA INT NOT NULL,
    NOMBRE_RUTINA VARCHAR2(50) NOT NULL,
    DIA_RUTINA VARCHAR2(30) NOT NULL,
    ID_USUARIO INT
);

CREATE TABLE EJERCICIO (
    ID_EJERCICIO INT NOT NULL,
    NOMBRE_EJERCICIO VARCHAR2(100) NOT NULL,
    SETSE VARCHAR2(30) NOT NULL,
    MAQUINA VARCHAR2(50) NOT NULL,
    OBSERVACIONES VARCHAR2(200) NOT NULL,
    ID_RUTINA INT
);

CREATE TABLE NOTAMES (
    ID_CHECK INT NOT NULL,
    NOTA_MENSUAL VARCHAR2(1000) NOT NULL,
    ID_FOTO INT
);

CREATE TABLE FOTOS (
    ID_FOTO INT NOT NULL,
    MES VARCHAR2(50) NOT NULL,
    ANNO VARCHAR2(50) NOT NULL,
    RUTA_FOTO VARCHAR2(250),
    ID_USUARIO INT
);

CREATE TABLE PAGOS (
    ID_PAGO INT NOT NULL,
    MONTO NUMERIC(10, 2),
    DIA_PAGO VARCHAR2(20),
    ESTADO VARCHAR2(20),
    ID_USUARIO INT
);

-- insert roles

INSERT INTO roles (id_rol, rol) VALUES (1, 'admin');
INSERT INTO roles (id_rol, rol) VALUES (2, 'user');

-- Constraints PK

ALTER TABLE ROLES ADD CONSTRAINT pk_roles PRIMARY KEY (ID_ROL);
ALTER TABLE USUARIO ADD CONSTRAINT pk_usuario PRIMARY KEY (ID_USUARIO);
ALTER TABLE DETALLES_USUARIO ADD CONSTRAINT pk_detalles_usuario PRIMARY KEY (ID_DETALLE);
ALTER TABLE RUTINA ADD CONSTRAINT pk_rutina PRIMARY KEY (ID_RUTINA);
ALTER TABLE EJERCICIO ADD CONSTRAINT pk_ejercicio PRIMARY KEY (ID_EJERCICIO);
ALTER TABLE NOTAMES ADD CONSTRAINT pk_notaMes PRIMARY KEY (ID_CHECK);
ALTER TABLE FOTOS ADD CONSTRAINT pk_fotos PRIMARY KEY (ID_FOTO);
ALTER TABLE PAGOS ADD CONSTRAINT pk_pagos PRIMARY KEY (ID_PAGO);

--Constraints FK

ALTER TABLE USUARIO ADD CONSTRAINT fk_usuario_roles FOREIGN KEY (ID_ROL) REFERENCES ROLES (ID_ROL);
ALTER TABLE DETALLES_USUARIO ADD CONSTRAINT fk_detalles_usuario_usuario FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO (ID_USUARIO) ON DELETE CASCADE;
ALTER TABLE RUTINA ADD CONSTRAINT fk_rutina_usuario FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO (ID_USUARIO) ON DELETE CASCADE;
ALTER TABLE EJERCICIO ADD CONSTRAINT fk_ejercicio_rutina FOREIGN KEY (ID_RUTINA) REFERENCES RUTINA (ID_RUTINA) ON DELETE CASCADE;
ALTER TABLE NOTAMES ADD CONSTRAINT fk_notaMes_fotos FOREIGN KEY (ID_FOTO) REFERENCES FOTOS (ID_FOTO) ON DELETE CASCADE;
ALTER TABLE FOTOS ADD CONSTRAINT fk_fotos_usuario FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO (ID_USUARIO) ON DELETE CASCADE;
ALTER TABLE PAGOS ADD CONSTRAINT fk_pagos_usuario FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO (ID_USUARIO) ON DELETE CASCADE;
  
--Auto increment
CREATE SEQUENCE seq_usuario_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_detalle_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_rutina_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ejercicio_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_notaMes_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_foto_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_pagos_id START WITH 1 INCREMENT BY 1;

--------------------------------------------------------------------------------
-- Procedimientos almacenados 
/*set serveroutput on;*/
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
        seq_detalle_id.NEXTVAL, TO_DATE('2000-01-01', 'YYYY-MM-DD'), NULL, NULL, NULL, NULL, NULL, NULL, NULL, p_id_usuario
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


--
CREATE OR REPLACE PROCEDURE sp_update_detalles_usuario (
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
END;
/

--------------------------------------------------------------------------------
--NOTA MES
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_insert_notames (
    p_id_check IN NUMBER,
    p_nota_mensual IN VARCHAR2(50) NOT NULL,
    p_id_foto IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    -- Inserta un nuevo registro en la tabla NOTAMES
    INSERT INTO NOTAMES (ID_CHECK, NOTA_MENSUAL, ID_FOTO)
    VALUES (p_id_check, p_nota_mensual, p_id_foto);
    
    p_result := 'Insertado correctamente';
EXCEPTION
    -- Captura cualquier error que ocurra durante la inserci�n
    WHEN OTHERS THEN
        p_result := SQLERRM;
END;
/
CREATE OR REPLACE PROCEDURE sp_update_notames (
    p_id_check IN NUMBER,
    p_nota_mensual IN VARCHAR2(50) NOT NULL,
    p_id_foto IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    -- Actualiza el registro en la tabla NOTAMES
    UPDATE NOTAMES
    SET NOTA_MENSUAL = p_nota_mensual
    WHERE ID_CHECK = p_id_check;
    
    p_result := 'Actualizado correctamente';
EXCEPTION
    -- Captura cualquier error que ocurra durante la actualizaci�n
    WHEN OTHERS THEN
        p_result := SQLERRM;
END;
/

CREATE OR REPLACE PROCEDURE sp_delete_notames (
    p_id_check IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
    -- Elimina el registro de la tabla NOTAMES
    DELETE FROM NOTAMES
    WHERE ID_CHECK = p_id_check;
    
    p_result := 'Eliminado correctamente';
EXCEPTION
    -- Captura cualquier error que ocurra durante la eliminaci�n
    WHEN OTHERS THEN
        p_result := SQLERRM;
END;
/

CREATE OR REPLACE PROCEDURE sp_get_notames (
    p_id_check IN NUMBER
) AS
    -- Declarar el cursor
    CURSOR notames_cursor IS
        SELECT ID_CHECK, NOTA_MENSUAL, ID_FOTO 
        FROM NOTAMES
        WHERE ID_CHECK = p_id_check;

    v_id_check NUMBER;
    v_nota_mensual VARCHAR2(50) NOT NULL;
    v_id_foto NUMBER;
BEGIN
    -- Abre el cursor
    OPEN notames_cursor;

    LOOP
        FETCH notames_cursor INTO v_id_check, v_nota_mensual, v_id_foto;
        EXIT WHEN notames_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('ID_CHECK: ' || v_id_check || ', NOTA_MENSUAL: ' || v_nota_mensual || ', ID_FOTO: ' || v_id_foto);
    END LOOP;

    -- Cierra el cursor
    CLOSE notames_cursor;
EXCEPTION
    WHEN OTHERS THEN
        -- Obtiene el mensaje de error
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

--------------------------------------------------------------------------------
--FOTOS
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_insert_fotos (
    p_id_foto IN NUMBER,
    p_mes IN VARCHAR2,
    p_anno IN VARCHAR2,
    p_ruta_foto IN VARCHAR2,
    p_id_usuario IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
-- Inserta un nuevo registro en la tabla FOTOS
    INSERT INTO FOTOS (ID_FOTO, MES, ANNO, RUTA_FOTO, ID_USUARIO)
    VALUES (p_id_foto, p_mes, p_anno, p_ruta_foto, p_id_usuario);
    
    p_result := 'Insertado correctamente';
EXCEPTION
-- Captura cualquier error que ocurra durante la inserci?n
    WHEN OTHERS THEN
        p_result := SQLERRM;
END;
/

CREATE OR REPLACE PROCEDURE sp_update_fotos (
    p_id_foto IN NUMBER,
    p_mes IN VARCHAR2,
    p_anno IN VARCHAR2,
    p_ruta_foto IN VARCHAR2,
    p_id_usuario IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
-- Actualiza el registro en la tabla FOTOS
    UPDATE FOTOS
    SET MES = p_mes,
        ANNO = p_anno,
        RUTA_FOTO = p_ruta_foto,
        ID_USUARIO = p_id_usuario
    WHERE ID_FOTO = p_id_foto;
    
    p_result := 'Actualizado correctamente';
EXCEPTION
-- Captura cualquier error
    WHEN OTHERS THEN
        p_result := SQLERRM;
END;
/

CREATE OR REPLACE PROCEDURE sp_delete_fotos (
    p_id_foto IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
-- Elimina el registro de la tabla FOTOS
    DELETE FROM FOTOS
    WHERE ID_FOTO = p_id_foto;
    
    p_result := 'Eliminado correctamente';
EXCEPTION
    WHEN OTHERS THEN
        p_result := SQLERRM;
END;
/

CREATE OR REPLACE PROCEDURE sp_get_fotos (
    p_id_foto IN NUMBER
) AS
    CURSOR fotos_cursor IS
        SELECT ID_FOTO, MES, ANNO, RUTA_FOTO, ID_USUARIO
        FROM FOTOS
        WHERE ID_FOTO = p_id_foto;
    
    v_id_foto NUMBER;
    v_mes VARCHAR2(50);
    v_anno VARCHAR2(50);
    v_ruta_foto VARCHAR2(250);
    v_id_usuario NUMBER;
BEGIN
-- CURSOR
    OPEN fotos_cursor;
    LOOP
        FETCH fotos_cursor INTO v_id_foto, v_mes, v_anno, v_ruta_foto, v_id_usuario;
        EXIT WHEN fotos_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('ID_FOTO: ' || v_id_foto || ', MES: ' || v_mes || ', ANNO: ' || v_anno || ', RUTA_FOTO: ' || v_ruta_foto || ', ID_USUARIO: ' || v_id_usuario);
    END LOOP;
    
-- Cierra el cursor
    CLOSE fotos_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

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
--------------------------------------------------------------------------------
--PAGOS
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
commit;


-------------------------------------------------------------------------------
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
--FOTO
--------------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_dueno_foto AS
SELECT f.ID_FOTO, f.MES, f.ANNO, f.RUTA_FOTO, u.NOMBRE
FROM FOTOS f
JOIN USUARIO u ON f.ID_USUARIO = u.ID_USUARIO;
/
--------------------------------------------------------------------------------
-- Funciones
--------------------------------------------------------------------------------
--FOTO
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_get_dueno_foto(
p_id_foto IN NUMBER
)
RETURN VARCHAR2
IS
    v_nombre_usuario VARCHAR2(100);
BEGIN
    SELECT u.NOMBRE
    INTO v_nombre_usuario
    FROM FOTOS f
    JOIN USUARIO u ON f.ID_USUARIO= u.ID_USUARIO
    WHERE f.ID_FOTO = p_id_foto;

    RETURN v_nombre_usuario;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error: ' || SQLERRM;
END;
/

CREATE OR REPLACE FUNCTION obtener_nota_foto(p_id_foto INT) 
RETURN VARCHAR2(50) NOT NULL 
IS
    v_nota VARCHAR2(50) NOT NULL;
BEGIN
    SELECT nm.nota_mensual
    INTO v_nota
    FROM notames nm
    WHERE nm.id_foto = p_id_foto;

    RETURN v_nota;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Ocurri? un error al obtener la nota de la foto.';
END;
/

--Paquetes
CREATE OR REPLACE PACKAGE pkg_usuario AS
    PROCEDURE insert_usuario (
        p_nombre IN VARCHAR2,
        p_primer_apellido IN VARCHAR2,
        p_segundo_apellido IN VARCHAR2,
        p_correo IN VARCHAR2,
        p_tipo_suscripcion IN VARCHAR2,
        p_id_rol IN NUMBER,
        p_password IN VARCHAR2,
        p_result OUT VARCHAR2
    );
    
    PROCEDURE update_usuario (
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
    
    PROCEDURE delete_usuario (
        p_id_usuario IN NUMBER,
        p_result OUT VARCHAR2
    );
    
    PROCEDURE get_usuario (
        p_id_usuario IN NUMBER
    );
END pkg_usuario;
/

CREATE OR REPLACE PACKAGE BODY pkg_usuario AS
    PROCEDURE insert_usuario (
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
        INSERT INTO USUARIO (NOMBRE, PRIMER_APELLIDO, SEGUNDO_APELLIDO, CORREO, TIPO_SUSCRIPCION, ID_ROL, PASSWORD)
        VALUES (p_nombre, p_primer_apellido, p_segundo_apellido, p_correo, p_tipo_suscripcion, p_id_rol, p_password);

        p_result := 'Insertado correctamente';
    EXCEPTION
        WHEN OTHERS THEN
            p_result := SQLERRM;
    END;
    
    PROCEDURE update_usuario (
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
    
    PROCEDURE delete_usuario (
        p_id_usuario IN NUMBER,
        p_result OUT VARCHAR2
    ) AS
    BEGIN
        DELETE FROM USUARIO WHERE ID_USUARIO = p_id_usuario;

        p_result := 'Eliminado correctamente';
    EXCEPTION
        WHEN OTHERS THEN
            p_result := SQLERRM;
    END;
    
    PROCEDURE get_usuario (
        p_id_usuario IN NUMBER
    ) AS
        CURSOR usuario_cursor IS
            SELECT ID_USUARIO, NOMBRE, PRIMER_APELLIDO, SEGUNDO_APELLIDO, CORREO, TIPO_SUSCRIPCION, ID_ROL, PASSWORD
            FROM USUARIO
            WHERE ID_USUARIO = p_id_usuario;
            
        v_id_usuario NUMBER;
        v_nombre VARCHAR2(50);
        v_primer_apellido VARCHAR2(50);
        v_segundo_apellido VARCHAR2(50);
        v_correo VARCHAR2(50);
        v_tipo_suscripcion VARCHAR2(50);
        v_id_rol NUMBER;
        v_password VARCHAR2(255);
    BEGIN
        OPEN usuario_cursor;
        LOOP
            FETCH usuario_cursor INTO v_id_usuario, v_nombre, v_primer_apellido, v_segundo_apellido, v_correo, v_tipo_suscripcion, v_id_rol, v_password;
            EXIT WHEN usuario_cursor%NOTFOUND;

            DBMS_OUTPUT.PUT_LINE('ID_USUARIO: ' || v_id_usuario || ', NOMBRE: ' || v_nombre || ', PRIMER_APELLIDO: ' || v_primer_apellido || ', SEGUNDO_APELLIDO: ' || v_segundo_apellido || ', CORREO: ' || v_correo || ', TIPO_SUSCRIPCION: ' || v_tipo_suscripcion || ', ID_ROL: ' || v_id_rol || ', PASSWORD: ' || v_password);
        END LOOP;

        CLOSE usuario_cursor;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END;
END pkg_usuario;
/

CREATE OR REPLACE PACKAGE BODY pkg_detalles_usuario AS
    PROCEDURE insert_detalles_usuario (
        p_fecha_nacimiento IN DATE,
        p_altura_persona IN FLOAT,
        p_peso_persona IN FLOAT,
        p_lesiones IN VARCHAR2,
        p_medicamentos IN VARCHAR2,
        p_embarazo IN VARCHAR2,
        p_cirugia IN VARCHAR2,
        p_objetivos IN VARCHAR2(50) NOT NULL,
        p_id_usuario IN NUMBER,
        p_result OUT VARCHAR2
    ) AS
    BEGIN
        INSERT INTO DETALLES_USUARIO (FECHA_NACIMIENTO, ALTURA_PERSONA, PESO_PERSONA, LESIONES, MEDICAMENTOS, EMBARAZO, CIRUGIA, OBJETIVOS, ID_USUARIO)
        VALUES (p_fecha_nacimiento, p_altura_persona, p_peso_persona, p_lesiones, p_medicamentos, p_embarazo, p_cirugia, p_objetivos, p_id_usuario);

        p_result := 'Insertado correctamente';
    EXCEPTION
        WHEN OTHERS THEN
            p_result := SQLERRM;
    END;
    
    PROCEDURE update_detalles_usuario (
        p_id_detalle IN NUMBER,
        p_fecha_nacimiento IN DATE,
        p_altura_persona IN FLOAT,
        p_peso_persona IN FLOAT,
        p_lesiones IN VARCHAR2,
        p_medicamentos IN VARCHAR2,
        p_embarazo IN VARCHAR2,
        p_cirugia IN VARCHAR2,
        p_objetivos IN VARCHAR2(50) NOT NULL,
        p_id_usuario IN NUMBER,
        p_result OUT VARCHAR2
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
            OBJETIVOS = p_objetivos,
            ID_USUARIO = p_id_usuario
        WHERE ID_DETALLE = p_id_detalle;

        p_result := 'Actualizado correctamente';
    EXCEPTION
        WHEN OTHERS THEN
            p_result := SQLERRM;
    END;
    
    PROCEDURE delete_detalles_usuario (
        p_id_detalle IN NUMBER,
        p_result OUT VARCHAR2
    ) AS
    BEGIN
        DELETE FROM DETALLES_USUARIO WHERE ID_DETALLE = p_id_detalle;

        p_result := 'Eliminado correctamente';
    EXCEPTION
        WHEN OTHERS THEN
            p_result := SQLERRM;
    END;
    
    PROCEDURE get_detalles_usuario (
        p_id_detalle IN NUMBER
    ) AS
        CURSOR detalles_cursor IS
            SELECT ID_DETALLE, FECHA_NACIMIENTO, ALTURA_PERSONA, PESO_PERSONA, LESIONES, MEDICAMENTOS, EMBARAZO, CIRUGIA, OBJETIVOS, ID_USUARIO
            FROM DETALLES_USUARIO
            WHERE ID_DETALLE = p_id_detalle;
            
        v_id_detalle         DETALLES_USUARIO.ID_DETALLE%TYPE;
        v_fecha_nacimiento   DETALLES_USUARIO.FECHA_NACIMIENTO%TYPE;
        v_altura_persona     DETALLES_USUARIO.ALTURA_PERSONA%TYPE;
        v_peso_persona       DETALLES_USUARIO.PESO_PERSONA%TYPE;
        v_lesiones           DETALLES_USUARIO.LESIONES%TYPE;
        v_medicamentos       DETALLES_USUARIO.MEDICAMENTOS%TYPE;
        v_embarazo           DETALLES_USUARIO.EMBARAZO%TYPE;
        v_cirugia            DETALLES_USUARIO.CIRUGIA%TYPE;
        v_objetivos          DETALLES_USUARIO.OBJETIVOS%TYPE;
        v_id_usuario         DETALLES_USUARIO.ID_USUARIO%TYPE;
    BEGIN
        OPEN detalles_cursor;
        FETCH detalles_cursor INTO v_id_detalle, v_fecha_nacimiento, v_altura_persona, v_peso_persona, v_lesiones, v_medicamentos, v_embarazo, v_cirugia, v_objetivos, v_id_usuario;
        CLOSE detalles_cursor;

        IF detalles_cursor%FOUND THEN
            DBMS_OUTPUT.PUT_LINE('ID DETALLE: ' || v_id_detalle);
            DBMS_OUTPUT.PUT_LINE('FECHA NACIMIENTO: ' || v_fecha_nacimiento);
            DBMS_OUTPUT.PUT_LINE('ALTURA PERSONA: ' || v_altura_persona);
            DBMS_OUTPUT.PUT_LINE('PESO PERSONA: ' || v_peso_persona);
            DBMS_OUTPUT.PUT_LINE('LESIONES: ' || v_lesiones);
            DBMS_OUTPUT.PUT_LINE('MEDICAMENTOS: ' || v_medicamentos);
            DBMS_OUTPUT.PUT_LINE('EMBARAZO: ' || v_embarazo);
            DBMS_OUTPUT.PUT_LINE('CIRUGIA: ' || v_cirugia);
            DBMS_OUTPUT.PUT_LINE('OBJETIVOS: ' || v_objetivos);
            DBMS_OUTPUT.PUT_LINE('ID USUARIO: ' || v_id_usuario);
        ELSE
            DBMS_OUTPUT.PUT_LINE('No se encontraron detalles para el ID proporcionado.');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al recuperar los detalles: ' || SQLERRM);
    END;
END pkg_detalles_usuario;
/










-- Eliminar la restricción de clave foránea en la tabla DETALLES_USUARIO
ALTER TABLE DETALLES_USUARIO 
   DROP CONSTRAINT fk_detalles_usuario_usuario;

-- Eliminar la restricción de clave foránea en la tabla RUTINA
ALTER TABLE RUTINA 
   DROP CONSTRAINT fk_rutina_usuario;

-- Eliminar la restricción de clave foránea en la tabla EJERCICIO
ALTER TABLE EJERCICIO 
   DROP CONSTRAINT fk_ejercicio_rutina;

-- Eliminar la restricción de clave foránea en la tabla NOTAMES
ALTER TABLE NOTAMES 
   DROP CONSTRAINT fk_notaMes_fotos;

-- Eliminar la restricción de clave foránea en la tabla FOTOS
ALTER TABLE FOTOS 
   DROP CONSTRAINT fk_fotos_usuario;

-- Eliminar la restricción de clave foránea en la tabla PAGOS
ALTER TABLE PAGOS 
   DROP CONSTRAINT fk_pagos_usuario;