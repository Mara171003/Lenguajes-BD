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
    ID_USUARIO INT
);

CREATE TABLE FOTOS (
    ID_FOTO INT NOT NULL,
    MES VARCHAR2(50) NOT NULL,
    ANNO VARCHAR2(50) NOT NULL,
    RUTA_FOTO VARCHAR2(250),
    ID_USUARIO INT
);

CREATE TABLE ADMINISTRACION (
    ID_CLIENTE INT NOT NULL,
    PAGO VARCHAR2(20),
    MONTO DECIMAL(10, 2),
    ID_USUARIO INT
);

CREATE TABLE PAGOS (
    ID_PAGO INT NOT NULL,
    MONTO NUMERIC(10, 2),
    DIA_PAGO VARCHAR2(20),
    ESTADO VARCHAR2(20),
    ID_USUARIO INT
);

-- constraints PK

ALTER TABLE ROLES ADD CONSTRAINT pk_roles PRIMARY KEY (ID_ROL);

ALTER TABLE USUARIO ADD CONSTRAINT pk_usuario PRIMARY KEY (ID_USUARIO);

ALTER TABLE DETALLES_USUARIO ADD CONSTRAINT pk_detalles_usuario PRIMARY KEY (ID_DETALLE);

ALTER TABLE RUTINA ADD CONSTRAINT pk_rutina PRIMARY KEY (ID_RUTINA);

ALTER TABLE EJERCICIO ADD CONSTRAINT pk_ejercicio PRIMARY KEY (ID_EJERCICIO);

ALTER TABLE NOTAMES ADD CONSTRAINT pk_notaMes PRIMARY KEY (ID_CHECK);

ALTER TABLE FOTOS ADD CONSTRAINT pk_fotos PRIMARY KEY (ID_FOTO);

ALTER TABLE ADMINISTRACION ADD CONSTRAINT pk_administracion PRIMARY KEY (ID_CLIENTE);

ALTER TABLE PAGOS ADD CONSTRAINT pk_pagos PRIMARY KEY (ID_PAGO);

--constraints FK

ALTER TABLE USUARIO ADD CONSTRAINT fk_usuario_roles FOREIGN KEY (ID_ROL) REFERENCES ROLES (ID_ROL);

ALTER TABLE DETALLES_USUARIO ADD CONSTRAINT fk_detalles_usuario_usuario FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO (ID_USUARIO);

ALTER TABLE RUTINA ADD CONSTRAINT fk_rutina_usuario FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO (ID_USUARIO);

ALTER TABLE EJERCICIO ADD CONSTRAINT fk_ejercicio_rutina FOREIGN KEY (ID_RUTINA) REFERENCES RUTINA (ID_RUTINA);

ALTER TABLE NOTAMES ADD CONSTRAINT fk_notaMes_usuario FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO (ID_USUARIO);

ALTER TABLE FOTOS ADD CONSTRAINT fk_fotos_usuario FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO (ID_USUARIO);

ALTER TABLE ADMINISTRACION ADD CONSTRAINT fk_administracion_usuario FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO (ID_USUARIO);

ALTER TABLE PAGOS ADD CONSTRAINT fk_pagos_usuario FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO (ID_USUARIO);

--auto increment
CREATE SEQUENCE seq_usuario_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_detalle_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_rutina_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ejercicio_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_notaMes_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_foto_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_administracion_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_pagos_id START WITH 1 INCREMENT BY 1;

-- triggers para el auto-increment
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

CREATE OR REPLACE TRIGGER trg_administracion_id
BEFORE INSERT ON ADMINISTRACION
FOR EACH ROW
BEGIN
    SELECT seq_administracion_id.NEXTVAL
    INTO :new.ID_CLIENTE
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

