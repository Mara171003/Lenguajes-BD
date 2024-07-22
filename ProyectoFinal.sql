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
    OBJETIVOS CLOB,
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
    OBSERVACIONES CLOB,
    ID_RUTINA INT
);

CREATE TABLE NOTAMES (
    ID_CHECK INT NOT NULL,
    NOTA_MENSUAL CLOB,
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

ALTER TABLE DETALLES_USUARIO ADD CONSTRAINT fk_detalles_usuario_usuario FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO (ID_USUARIO);

ALTER TABLE RUTINA ADD CONSTRAINT fk_rutina_usuario FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO (ID_USUARIO);

ALTER TABLE EJERCICIO ADD CONSTRAINT fk_ejercicio_rutina FOREIGN KEY (ID_RUTINA) REFERENCES RUTINA (ID_RUTINA);

ALTER TABLE NOTAMES ADD CONSTRAINT fk_notaMes_fotos FOREIGN KEY (ID_FOTO) REFERENCES FOTOS (ID_FOTO);

ALTER TABLE FOTOS ADD CONSTRAINT fk_fotos_usuario FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO (ID_USUARIO);

ALTER TABLE PAGOS ADD CONSTRAINT fk_pagos_usuario FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO (ID_USUARIO);

--Auto increment
CREATE SEQUENCE seq_usuario_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_detalle_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_rutina_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ejercicio_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_notaMes_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_foto_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_pagos_id START WITH 1 INCREMENT BY 1;

-- Triggers para el auto-increment
CREATE OR REPLACE TRIGGER trg_usuario_id
BEFORE INSERT ON USUARIO
FOR EACH ROW
BEGIN
    SELECT seq_usuario_id.NEXTVAL
    INTO :new.ID_USUARIO
    FROM dual;
END;
/

CREATE OR REPLACE TRIGGER trg_detalle_id
BEFORE INSERT ON DETALLES_USUARIO
FOR EACH ROW
BEGIN
    SELECT seq_detalle_id.NEXTVAL
    INTO :new.ID_DETALLE
    FROM dual;
END;
/

CREATE OR REPLACE TRIGGER trg_rutina_id
BEFORE INSERT ON RUTINA
FOR EACH ROW
BEGIN
    SELECT seq_rutina_id.NEXTVAL
    INTO :new.ID_RUTINA
    FROM dual;
END;
/

CREATE OR REPLACE TRIGGER trg_ejercicio_id
BEFORE INSERT ON EJERCICIO
FOR EACH ROW
BEGIN
    SELECT seq_ejercicio_id.NEXTVAL
    INTO :new.ID_EJERCICIO
    FROM dual;
END;
/

CREATE OR REPLACE TRIGGER trg_notaMes_id
BEFORE INSERT ON NOTAMES
FOR EACH ROW
BEGIN
    SELECT seq_notaMes_id.NEXTVAL
    INTO :new.ID_CHECK
    FROM dual;
END;
/

CREATE OR REPLACE TRIGGER trg_foto_id
BEFORE INSERT ON FOTOS
FOR EACH ROW
BEGIN
    SELECT seq_foto_id.NEXTVAL
    INTO :new.ID_FOTO
    FROM dual;
END;
/

CREATE OR REPLACE TRIGGER trg_pagos_id
BEFORE INSERT ON PAGOS
FOR EACH ROW
BEGIN
    SELECT seq_pagos_id.NEXTVAL
    INTO :new.ID_PAGO
    FROM dual;
END;
/

--------------------------------------------------------------------------------
-- Procedimientos almacenados 
/*set serveroutput on;*/
--------------------------------------------------------------------------------
--NOTA MES
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE insert_notames (
    p_id_check IN NUMBER,
    p_nota_mensual IN CLOB,
    p_id_foto IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
-- Inserta un nuevo registro en la tabla NOTAMES
    INSERT INTO NOTAMES (ID_CHECK, NOTA_MENSUAL, ID_FOTO)
    VALUES (p_id_check, p_nota_mensual, p_id_foto);
    
    p_result := 'Insertado correctamente';
EXCEPTION
-- Captura cualquier error que ocurra durante la inserción
    WHEN OTHERS THEN
        p_result := SQLERRM;
END;
/

--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE update_notames (
    p_id_check IN NUMBER,
    p_nota_mensual IN CLOB,
    p_id_foto IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
-- Actualiza el registro en la tabla NOTAMES
    UPDATE NOTAMES
    SET NOTA_MENSUAL = p_nota_mensual,
        ID_FOTO = p_id_foto
    WHERE ID_CHECK = p_id_check;
    
    p_result := 'Actualizado correctamente';
EXCEPTION
-- Captura cualquier error que ocurra durante la actualización
    WHEN OTHERS THEN
        p_result := SQLERRM;
END;
/

--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE delete_notames (
    p_id_check IN NUMBER,
    p_result OUT VARCHAR2
) AS
BEGIN
 -- Elimina el registro de la tabla NOTAMES
    DELETE FROM NOTAMES
    WHERE ID_CHECK = p_id_check;
    
    p_result := 'Eliminado correctamente';
EXCEPTION
-- Captura cualquier error que ocurra durante la eliminación
    WHEN OTHERS THEN
        p_result := SQLERRM;
END;
/

--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE get_notames (
    p_id_check IN NUMBER
) AS
    CURSOR notames_cursor IS
        SELECT ID_CHECK, NOTA_MENSUAL, ID_FOTO
        FROM NOTAMES
        WHERE ID_CHECK = p_id_check;
    
-- Variables para almacenar el resultado
    v_id_check NUMBER;
    v_nota_mensual CLOB;
    v_id_foto NUMBER;
BEGIN
-- Abre el cursor
    OPEN notames_cursor;
    
    LOOP
        FETCH notames_cursor INTO v_id_check, v_nota_mensual, v_id_foto;
        EXIT WHEN notames_cursor%NOTFOUND;
--resultados

        DBMS_OUTPUT.PUT_LINE('ID_CHECK: ' || v_id_check || ', NOTA_MENSUAL: ' || v_nota_mensual || ', ID_FOTO: ' || v_id_foto);
    END LOOP;
    
    CLOSE notames_cursor;
EXCEPTION
    WHEN OTHERS THEN
--Obtener el msj de error
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


--------------------------------------------------------------------------------
--FOTOS
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE insert_fotos (
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
-- Captura cualquier error que ocurra durante la inserción
    WHEN OTHERS THEN
        p_result := SQLERRM;
END;
/

--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE update_fotos (
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

--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE delete_fotos (
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

--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE get_fotos (
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
-- Vistas
--------------------------------------------------------------------------------
--FOTO
--------------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_dueño_foto AS
SELECT f.ID_FOTO, f.MES, f.ANNO, f.RUTA_FOTO, u.NOMBRE
FROM FOTOS f
JOIN USUARIO u ON f.ID_USUARIO = u.ID_USUARIO;
/
 
--------------------------------------------------------------------------------
-- Funciones
--------------------------------------------------------------------------------
--FOTO
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_dueño_foto(
p_id_foto IN NUMBER
)
RETURN VARCHAR2
IS
    v_nombre_usuario VARCHAR2(100);
BEGIN
    SELECT u.NOMBRE
    INTO v_nombre_usuario
    FROM FOTOS f
    JOIN USUARIOS u ON f.ID_USUARIO= u.ID_USUARIO
    WHERE f.ID_FOTO = p_id_foto;

    RETURN v_nombre_usuario;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error: ' || SQLERRM;
END;
/

CREATE OR REPLACE FUNCTION obtener_nota_foto(p_id_foto INT) 
RETURN CLOB 
IS
    v_nota CLOB;
BEGIN
    SELECT nm.nota_mensual
    INTO v_nota
    FROM notames nm
    WHERE nm.id_foto = p_id_foto;

    RETURN v_nota;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Ocurrió un error al obtener la nota de la foto.';
END;
/


-- Paquetes

-- Cursores
