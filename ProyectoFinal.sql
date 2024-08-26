--creacion de tablas
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
    NOTA_MENSUAL VARCHAR2(1000),
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

CREATE TABLE ROLES (
    ID_ROL INT NOT NULL,
    ROL VARCHAR2(20) NOT NULL
);
--Constraints FK

ALTER TABLE USUARIO ADD CONSTRAINT fk_usuario_roles FOREIGN KEY (ID_ROL) REFERENCES ROLES (ID_ROL);
ALTER TABLE DETALLES_USUARIO ADD CONSTRAINT fk_detalles_usuario_usuario FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO (ID_USUARIO) ON DELETE CASCADE;
ALTER TABLE RUTINA ADD CONSTRAINT fk_rutina_usuario FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO (ID_USUARIO) ON DELETE CASCADE;
ALTER TABLE EJERCICIO ADD CONSTRAINT fk_ejercicio_rutina FOREIGN KEY (ID_RUTINA) REFERENCES RUTINA (ID_RUTINA) ON DELETE CASCADE;
ALTER TABLE NOTAMES ADD CONSTRAINT fk_notaMes_fotos FOREIGN KEY (ID_FOTO) REFERENCES FOTOS (ID_FOTO) ON DELETE CASCADE;
ALTER TABLE FOTOS ADD CONSTRAINT fk_fotos_usuario FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO (ID_USUARIO) ON DELETE CASCADE;
ALTER TABLE PAGOS ADD CONSTRAINT fk_pagos_usuario FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO (ID_USUARIO) ON DELETE CASCADE;

  --PARA NOTAMES Y FOTOS
ALTER TABLE notames
DROP CONSTRAINT FK_NOTAMES_FOTOS;

ALTER TABLE notames
ADD CONSTRAINT FK_NOTAMES_FOTOS
FOREIGN KEY (id_foto) REFERENCES fotos(id_foto)
ON DELETE CASCADE;

--Auto increment
CREATE SEQUENCE seq_usuario_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_detalle_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_rutina_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ejercicio_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_notaMes_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_foto_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_pagos_id START WITH 1 INCREMENT BY 1;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--NOTA MES
--------------------------------------------------------------------------------
/*CREATE OR REPLACE PROCEDURE sp_insert_notames (
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
/*/

--------------------------------------------------------------------------------
--FOTOS
--------------------------------------------------------------------------------
/*CREATE OR REPLACE PROCEDURE sp_insert_fotos (
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
*/

-----------------------------------------------------------------------------------------------
--CHECK PHP -----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE mesValidacionNotaMes(
    p_idUsuario IN INT,
    p_existe OUT INT
) AS
    v_sql VARCHAR2(1000);
    v_count INT;
BEGIN
    -- Construcci�n del SQL din�mico
    v_sql := 'SELECT COUNT(*) FROM NOTAMES NM JOIN FOTOS F ON NM.ID_FOTO = F.ID_FOTO ' ||
             'WHERE F.ID_USUARIO = :idUsuario ' ||
             'AND F.MES = TO_CHAR(SYSDATE, ''Month'', ''NLS_DATE_LANGUAGE=SPANISH'') ' ||
             'AND F.ANNO = TO_CHAR(SYSDATE, ''YYYY'')';

    -- Ejecutar el SQL din�mico y obtener el resultado
    EXECUTE IMMEDIATE v_sql INTO v_count USING p_idUsuario;

    -- Validar el resultado
    IF v_count > 0 THEN
        p_existe := 1;
    ELSE
        p_existe := 0;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        -- Manejo de errores: devuelve p_existe como 0 e imprime el mensaje de error
        p_existe := 0;
        DBMS_OUTPUT.PUT_LINE('Error en mesValidacionNotaMes: ' || SQLERRM);
        RAISE;
END mesValidacionNotaMes;
/

-----------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE obtenerUltimoIdFoto(
    p_idFoto OUT INT
) AS
    v_sql VARCHAR2(1000);
BEGIN
    -- Construcci�n del SQL din�mico
    v_sql := 'SELECT NVL(MAX(ID_FOTO), 0) FROM FOTOS';

    -- Ejecutar el SQL din�mico y obtener el resultado
    EXECUTE IMMEDIATE v_sql INTO p_idFoto;

EXCEPTION
    WHEN OTHERS THEN
        -- Manejo de errores
        p_idFoto := 0;
        DBMS_OUTPUT.PUT_LINE('Error en obtenerUltimoIdFoto: ' || SQLERRM);
        RAISE;
END obtenerUltimoIdFoto;
/

------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE INSERTAR_FOTO (
    p_mes IN VARCHAR2,
    p_anno IN VARCHAR2,
    p_rutaFoto IN VARCHAR2,
    p_idUsuario IN NUMBER
) AS
    v_count NUMBER;
    v_sql VARCHAR2(1000);
BEGIN
    -- SQL Din�mico para validar si el usuario existe
    v_sql := 'SELECT COUNT(*) FROM CPROYECTO.USUARIO WHERE ID_USUARIO = :1';
    EXECUTE IMMEDIATE v_sql INTO v_count USING p_idUsuario;
    IF v_count = 0 THEN
        -- El usuario no existe, lanzar una excepci�n
        RAISE_APPLICATION_ERROR(-20001, 'El usuario con ID ' || p_idUsuario || ' no existe.');
    END IF;
    -- SQL Din�mico para insertar la foto si el usuario existe
    v_sql := 'INSERT INTO CPROYECTO.FOTOS (mes, anno, ruta_foto, id_usuario) ' ||
             'VALUES (:1, :2, :3, :4)';
    EXECUTE IMMEDIATE v_sql USING p_mes, p_anno, p_rutaFoto, p_idUsuario;

EXCEPTION
    -- Manejo de excepciones
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error al insertar la foto: ' || SQLERRM);
END INSERTAR_FOTO;
/

------------------------------------------------------------------------------------------------
/*SELECT id_usuario
FROM usuario
WHERE id_usuario = 3;*/

CREATE OR REPLACE PROCEDURE crearNotaMes(
    p_notaMensual IN VARCHAR2,
    p_idFoto IN INT
) AS
    v_sql VARCHAR2(1000);
BEGIN
    -- SQL Din�mico para insertar la nota mensual
    v_sql := 'INSERT INTO NOTAMES (NOTA_MENSUAL, ID_FOTO) VALUES (:1, :2)';
    -- Ejecutar la consulta SQL din�mica
    EXECUTE IMMEDIATE v_sql USING p_notaMensual, p_idFoto;
EXCEPTION
    -- Manejo de excepciones
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error al insertar la nota mensual: ' || SQLERRM);
END crearNotaMes;
/

------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE obtenerFotos(
    p_idUsuario IN NUMBER,
    p_anno IN VARCHAR2,
    p_mes IN VARCHAR2,
    p_resultado OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_resultado FOR
    SELECT f.*, nm.*
    FROM fotos f
    LEFT JOIN notames nm ON f.id_foto = nm.id_foto
    WHERE f.mes = p_mes AND f.anno = p_anno AND f.id_usuario = p_idUsuario;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron fotos para los par�metros proporcionados.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurri� un error: ' || SQLERRM);
END obtenerFotos;
/
------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE eliminar_foto (
    p_id_foto IN INT
) AS
    v_sql_notames VARCHAR2(1000);
    v_sql_fotos VARCHAR2(1000);
BEGIN
    v_sql_notames := 'DELETE FROM notames WHERE id_foto = :id_foto';
    EXECUTE IMMEDIATE v_sql_notames USING p_id_foto;
    v_sql_fotos := 'DELETE FROM fotos WHERE id_foto = :id_foto';
    EXECUTE IMMEDIATE v_sql_fotos USING p_id_foto;
    -- Confirma las transacciones
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Manejo de errores
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al eliminar la foto: ' || SQLERRM);
        RAISE;
END eliminar_foto;
/

------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE UpdateNotaMes (
    p_idFoto IN NUMBER,
    p_nota IN VARCHAR2
) AS
    v_sql VARCHAR2(1000);
BEGIN
    -- Construcci�n de la consulta SQL din�mica
    v_sql := 'UPDATE notames SET NOTA_MENSUAL = :1 WHERE ID_FOTO = :2';
    -- Ejecutar la consulta SQL din�mica
    EXECUTE IMMEDIATE v_sql USING p_nota, p_idFoto;
    COMMIT;
EXCEPTION
    -- Manejo de excepciones para capturar cualquier error
    WHEN OTHERS THEN
        ROLLBACK;  
        RAISE_APPLICATION_ERROR(-20001, 'Error al actualizar la nota mensual: ' || SQLERRM);
END UpdateNotaMes;
/

------------------------------------------------------------------------------------------------
--PAQUETES DE CHECK-IN Y RELACIONADOS
------------------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE Check_Pkg AS
    PROCEDURE UpdateNotaMes(p_idFoto IN NUMBER, p_nota IN VARCHAR2);
    PROCEDURE crearNotaMes(p_notaMensual IN VARCHAR2, p_idFoto IN INT);
    PROCEDURE insertarFoto(p_mes IN VARCHAR2, p_anno IN VARCHAR2, p_rutaFoto IN VARCHAR2, p_idUsuario IN NUMBER);
    PROCEDURE obtenerUltimoIdFoto(p_idFoto OUT INT);
    PROCEDURE mesValidacionNotaMes(p_idUsuario IN INT, p_existe OUT INT);
    PROCEDURE obtenerFotos(p_idUsuario IN NUMBER, p_anno IN VARCHAR2, p_mes IN VARCHAR2, p_resultado OUT SYS_REFCURSOR);
    PROCEDURE eliminar_foto(p_id_foto IN INT);
END Check_Pkg;
/

--PACKAFE BODYS
CREATE OR REPLACE PACKAGE BODY Check_Pkg AS

    PROCEDURE UpdateNotaMes (
        p_idFoto IN NUMBER,
        p_nota IN VARCHAR2
    ) AS
        v_sql VARCHAR2(1000);
    BEGIN
        v_sql := 'UPDATE notames SET NOTA_MENSUAL = :1 WHERE ID_FOTO = :2';
        EXECUTE IMMEDIATE v_sql USING p_nota, p_idFoto;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20001, 'Error al actualizar la nota mensual: ' || SQLERRM);
    END UpdateNotaMes;

    PROCEDURE crearNotaMes (
        p_notaMensual IN VARCHAR2,
        p_idFoto IN INT
    ) AS
        v_sql VARCHAR2(1000);
    BEGIN
        v_sql := 'INSERT INTO NOTAMES (NOTA_MENSUAL, ID_FOTO) VALUES (:1, :2)';
        EXECUTE IMMEDIATE v_sql USING p_notaMensual, p_idFoto;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error al insertar la nota mensual: ' || SQLERRM);
    END crearNotaMes;

    PROCEDURE insertarFoto (
        p_mes IN VARCHAR2,
        p_anno IN VARCHAR2,
        p_rutaFoto IN VARCHAR2,
        p_idUsuario IN NUMBER
    ) AS
        v_count NUMBER;
        v_sql VARCHAR2(1000);
    BEGIN
        v_sql := 'SELECT COUNT(*) FROM CPROYECTO.USUARIO WHERE ID_USUARIO = :1';
        EXECUTE IMMEDIATE v_sql INTO v_count USING p_idUsuario;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'El usuario con ID ' || p_idUsuario || ' no existe.');
        END IF;
        v_sql := 'INSERT INTO CPROYECTO.FOTOS (mes, anno, ruta_foto, id_usuario) VALUES (:1, :2, :3, :4)';
        EXECUTE IMMEDIATE v_sql USING p_mes, p_anno, p_rutaFoto, p_idUsuario;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Error al insertar la foto: ' || SQLERRM);
    END insertarFoto;

    PROCEDURE obtenerUltimoIdFoto (
        p_idFoto OUT INT
    ) AS
        v_sql VARCHAR2(1000);
    BEGIN
        v_sql := 'SELECT NVL(MAX(ID_FOTO), 0) FROM FOTOS';
        EXECUTE IMMEDIATE v_sql INTO p_idFoto;
    EXCEPTION
        WHEN OTHERS THEN
            p_idFoto := 0;
            DBMS_OUTPUT.PUT_LINE('Error en obtenerUltimoIdFoto: ' || SQLERRM);
            RAISE;
    END obtenerUltimoIdFoto;

    PROCEDURE mesValidacionNotaMes (
        p_idUsuario IN INT,
        p_existe OUT INT
    ) AS
        v_sql VARCHAR2(1000);
        v_count INT;
    BEGIN
        v_sql := 'SELECT COUNT(*) FROM NOTAMES NM JOIN FOTOS F ON NM.ID_FOTO = F.ID_FOTO ' ||
                 'WHERE F.ID_USUARIO = :idUsuario ' ||
                 'AND F.MES = TO_CHAR(SYSDATE, ''Month'', ''NLS_DATE_LANGUAGE=SPANISH'') ' ||
                 'AND F.ANNO = TO_CHAR(SYSDATE, ''YYYY'')';
        EXECUTE IMMEDIATE v_sql INTO v_count USING p_idUsuario;
        IF v_count > 0 THEN
            p_existe := 1;
        ELSE
            p_existe := 0;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            p_existe := 0;
            DBMS_OUTPUT.PUT_LINE('Error en mesValidacionNotaMes: ' || SQLERRM);
            RAISE;
    END mesValidacionNotaMes;

    PROCEDURE obtenerFotos (
        p_idUsuario IN NUMBER,
        p_anno IN VARCHAR2,
        p_mes IN VARCHAR2,
        p_resultado OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_resultado FOR
        SELECT f.*, nm.*
        FROM fotos f
        LEFT JOIN notames nm ON f.id_foto = nm.id_foto
        WHERE f.mes = p_mes AND f.anno = p_anno AND f.id_usuario = p_idUsuario;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No se encontraron fotos para los par�metros proporcionados.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Ocurri� un error: ' || SQLERRM);
            RAISE;
    END obtenerFotos;

    PROCEDURE eliminar_foto (
        p_id_foto IN INT
    ) AS
        v_sql_notames VARCHAR2(1000);
        v_sql_fotos VARCHAR2(1000);
    BEGIN
        v_sql_notames := 'DELETE FROM notames WHERE id_foto = :id_foto';
        EXECUTE IMMEDIATE v_sql_notames USING p_id_foto;
        v_sql_fotos := 'DELETE FROM fotos WHERE id_foto = :id_foto';
        EXECUTE IMMEDIATE v_sql_fotos USING p_id_foto;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error al eliminar la foto: ' || SQLERRM);
            RAISE;
    END eliminar_foto;

END Check_Pkg;
/

--------------------------------------------------------------------------------
--FOTO
--------------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_dueno_foto AS
SELECT f.ID_FOTO, f.MES, f.ANNO, f.RUTA_FOTO, u.NOMBRE
FROM FOTOS f
JOIN USUARIO u ON f.ID_USUARIO = u.ID_USUARIO;
/

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

/*
--ALTER USER C##PROYECTO QUOTA UNLIMITED ON USERS;
INSERT INTO USUARIO(ID_USUARIO,NOMBRE,PRIMER_APELLIDO,SEGUNDO_APELLIDO,CORREO,TIPO_SUSCRIPCION,ID_ROL,PASSWORD)
VALUES(1,'admin','admin','admin','admin@gmail.com','basico',1,'admin');

*/
