CREATE TABLE producto (
    id_producto NUMBER,
    nombre_prod VARCHAR2(200) NOT NULL,
    precio_prod NUMBER(10,2) NOT NULL,
    stock NUMBER NOT NULL,
    id_categoria NUMBER NOT NULL,
    id_proveedor NUMBER NOT NULL,
    CONSTRAINT PK_producto PRIMARY KEY (id_producto),
    CONSTRAINT FK_producto_categoria FOREIGN KEY (id_categoria)
        REFERENCES categoria(id_categoria),
    CONSTRAINT FK_producto_proveedor FOREIGN KEY (id_proveedor)
        REFERENCES proveedor(id_proveedor)
);


CREATE TABLE categoria (
    id_categoria NUMBER,
    nombre_cat VARCHAR2(100) NOT NULL,
    CONSTRAINT PK_categoria PRIMARY KEY (id_categoria)
);


CREATE TABLE proveedor (
    id_proveedor NUMBER,
    nombre_prove VARCHAR2(200) NOT NULL,
    telefono_prove VARCHAR2(20),
    correo_prove VARCHAR2(200),
    CONSTRAINT PK_proveedor PRIMARY KEY (id_proveedor)
);


CREATE TABLE cliente (
    id_cliente NUMBER,
    nombre_cli VARCHAR2(200) NOT NULL,
    email_cli VARCHAR2(200),
    CONSTRAINT PK_cliente PRIMARY KEY (id_cliente)
);


CREATE TABLE venta (
    id_venta NUMBER,
    fecha DATE DEFAULT SYSDATE,
    total NUMBER(10,2),
    id_cliente NUMBER,
    CONSTRAINT PK_venta PRIMARY KEY (id_venta),
    CONSTRAINT FK_venta_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente)
);


CREATE TABLE detalle_venta (
    id_detalle NUMBER,
    id_venta NUMBER NOT NULL,
    id_producto NUMBER NOT NULL,
    cantidad NUMBER NOT NULL,
    precio NUMBER(10,2) NOT NULL,
    subtotal NUMBER(10,2),
    CONSTRAINT PK_detalle_venta PRIMARY KEY (id_detalle),
    CONSTRAINT FK_detalle_venta_venta FOREIGN KEY (id_venta)
        REFERENCES venta(id_venta),
    CONSTRAINT FK_detalle_venta_producto FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto)
);

INSERT INTO categoria VALUES (1, 'Bebidas');
INSERT INTO categoria VALUES (2, 'Lácteos');
INSERT INTO categoria VALUES (3, 'Snacks');
INSERT INTO categoria VALUES (4, 'Galletas');
INSERT INTO categoria VALUES (5, 'Helados'); --Nuevo

INSERT INTO proveedor VALUES (1, 'BACKUS', '987654321', 'contacto.back@backus.com');
INSERT INTO proveedor VALUES (2, 'Alicorp', '963258741', 'contacto.alic@alicorp.com');
INSERT INTO proveedor VALUES (3, 'Gloria S.A', '912345678', 'ventas.glo@gloria.com');
INSERT INTO proveedor VALUES (4, 'Donofrio', '990104821', 'ventas.dono@donofrio.com'); --Nuevo

INSERT INTO producto VALUES (1, 'Coca-Cola 1L', 4.00, 100, 1, 1);
INSERT INTO producto VALUES (2, 'Papas Lays', 3.00, 200, 3, 2);
INSERT INTO producto VALUES (3, 'Leche Gloria ', 4.50, 150, 2, 3);
INSERT INTO producto VALUES (4, 'Oreo', 1.50, 80, 4, 2);

--Nuevo
INSERT INTO producto VALUES (7, 'Inka kola 1L', 4.00, 80, 1, 1);
INSERT INTO producto VALUES (8, 'Fanta 500ml', 2.20, 100, 1, 1);
INSERT INTO producto VALUES (9, 'Sprite 500ml', 2.20, 100, 1, 1);
INSERT INTO producto VALUES (10, 'Yogurt 1L', 2.20, 90, 2, 3);
INSERT INTO producto VALUES (11, 'Mantequilla en barra', 6.00, 80, 2, 3);
INSERT INTO producto VALUES (12, 'Minisublime', 1.50, 80, 5, 4);
INSERT INTO producto VALUES (13, 'Sin parar', 4.50, 80, 5, 4);
INSERT INTO producto VALUES (14, 'Frio Rico', 5.00, 110, 5, 4);
Commit;


INSERT INTO cliente VALUES (1, 'Alexander Faustino', 'alexander.faustino@tecsup.edu.pe');
INSERT INTO cliente VALUES (2, 'Alexander Canari', 'alexander.canari@tecsup.edu.pe');
INSERT INTO cliente VALUES (3, 'Jeff Amaro', 'jeff.amaro@tecsup.edu.pe');


INSERT INTO venta VALUES (1, SYSDATE, 12.50, 1);
INSERT INTO venta VALUES (2, SYSDATE, 24.00, 2);

INSERT INTO detalle_venta VALUES (1, 1, 1, 1, 4.00, 4.00);
INSERT INTO detalle_venta VALUES (2, 1, 3, 1, 8.50, 8.50);

INSERT INTO detalle_venta VALUES (3, 2, 2, 2, 6.00, 12.00);
INSERT INTO detalle_venta VALUES (4, 2, 4, 1, 12.00, 12.00);



