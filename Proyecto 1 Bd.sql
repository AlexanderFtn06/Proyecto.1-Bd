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
INSERT INTO categoria VALUES (5, 'Helados');

INSERT INTO proveedor VALUES (1, 'BACKUS', '987654321', 'contacto.back@backus.com');
INSERT INTO proveedor VALUES (2, 'Alicorp', '963258741', 'contacto.alic@alicorp.com');
INSERT INTO proveedor VALUES (3, 'Gloria S.A', '912345678', 'ventas.glo@gloria.com');
INSERT INTO proveedor VALUES (4, 'Donofrio', '990104821', 'ventas.dono@donofrio.com');

INSERT INTO producto VALUES (1, 'Coca-Cola 1L', 4.00, 100, 1, 1);
INSERT INTO producto VALUES (2, 'Papas Lays', 3.00, 200, 3, 2);
INSERT INTO producto VALUES (3, 'Leche Gloria ', 4.50, 150, 2, 3);
INSERT INTO producto VALUES (4, 'Oreo', 1.50, 80, 4, 2);


INSERT INTO producto VALUES (7, 'Inka kola 1L', 4.00, 80, 1, 1);
INSERT INTO producto VALUES (8, 'Fanta 500ml', 2.20, 100, 1, 1);
INSERT INTO producto VALUES (9, 'Sprite 500ml', 2.20, 100, 1, 1);
INSERT INTO producto VALUES (10, 'Yogurt 1L', 2.20, 90, 2, 3);
INSERT INTO producto VALUES (11, 'Mantequilla en barra', 6.00, 80, 2, 3);
INSERT INTO producto VALUES (12, 'Minisublime', 1.50, 80, 5, 4);
INSERT INTO producto VALUES (13, 'Sin parar', 4.50, 80, 5, 4);
INSERT INTO producto VALUES (14, 'Frio Rico', 5.00, 110, 5, 4);
Commit;
--Para ingresar nuevos datos desde sql developer realizar un commit al final
--para que en el intellij tambien se actualize

INSERT INTO cliente VALUES (1, 'Alexander Faustino', 'alexander.faustino@tecsup.edu.pe');
INSERT INTO cliente VALUES (2, 'Alexander Canari', 'alexander.canari@tecsup.edu.pe');
INSERT INTO cliente VALUES (3, 'Jeff Amaro', 'jeff.amaro@tecsup.edu.pe');


INSERT INTO venta VALUES (1, SYSDATE, 12.50, 1);
INSERT INTO venta VALUES (2, SYSDATE, 24.00, 2);

INSERT INTO detalle_venta VALUES (1, 1, 1, 1, 4.00, 4.00);
INSERT INTO detalle_venta VALUES (2, 1, 3, 1, 8.50, 8.50);

INSERT INTO detalle_venta VALUES (3, 2, 2, 2, 6.00, 12.00);
INSERT INTO detalle_venta VALUES (4, 2, 4, 1, 12.00, 12.00);

-- Venta 3: Jeff (cliente 3) → 5× Oreo (ID 4, S/1.50 c/u)
INSERT INTO venta (id_venta, fecha, total, id_cliente) VALUES (3, SYSDATE, 7.50, 3);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (5, 3, 4, 5, 1.50, 7.50);

-- Venta 4: Alexander F. (cliente 1) → 3× Papas Lays (ID 2, S/3.00)
INSERT INTO venta (id_venta, fecha, total, id_cliente) VALUES (4, SYSDATE, 9.00, 1);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (6, 4, 2, 3, 3.00, 9.00);

-- Venta 5: Alexander C. (cliente 2) → 3× Leche Gloria (ID 3, S/4.50)
INSERT INTO venta (id_venta, fecha, total, id_cliente) VALUES (5, SYSDATE, 13.50, 2);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (7, 5, 3, 3, 4.50, 13.50);

-- Venta 6: Jeff (cliente 3) → 2× Coca-Cola 1L (ID 1, S/4.00)
INSERT INTO venta (id_venta, fecha, total, id_cliente) VALUES (6, SYSDATE, 8.00, 3);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (8, 6, 1, 2, 4.00, 8.00);

-- Venta 7: Alexander F. (cliente 1) → 2× Sin parar (ID 13, S/4.50) + 1× Oreo (ID 4, S/1.50)
INSERT INTO venta (id_venta, fecha, total, id_cliente) VALUES (7, SYSDATE, 10.50, 1);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (9, 7, 13, 2, 4.50, 9.00);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (10, 7, 4, 1, 1.50, 1.50);

-- Venta 8: Alexander C. (cliente 2) → 10× Yogurt 1L (ID 10, S/2.20)
INSERT INTO venta (id_venta, fecha, total, id_cliente) VALUES (8, SYSDATE, 22.00, 2);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (11, 8, 10, 10, 2.20, 22.00);

-- Venta 9: Jeff (cliente 3) → 6× Papas Lays (ID 2, S/3.00)
INSERT INTO venta (id_venta, fecha, total, id_cliente) VALUES (9, SYSDATE, 18.00, 3);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (12, 9, 2, 6, 3.00, 18.00);

-- Venta 10: Alexander F. (cliente 1) → 4× Frio Rico (ID 14, S/5.00)
INSERT INTO venta (id_venta, fecha, total, id_cliente) VALUES (10, SYSDATE, 20.00, 1);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (13, 10, 14, 4, 5.00, 20.00);

-- Venta 11: Alexander C. (cliente 2) → 3× Sprite 500ml (ID 9, S/2.20)
INSERT INTO venta (id_venta, fecha, total, id_cliente) VALUES (11, SYSDATE, 6.60, 2);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (14, 11, 9, 3, 2.20, 6.60);

-- Venta 12: Jeff (cliente 3) → 2× Mantequilla (ID 11, S/6.00)
INSERT INTO venta (id_venta, fecha, total, id_cliente) VALUES (12, SYSDATE, 12.00, 3);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (15, 12, 11, 2, 6.00, 12.00);

-- Venta 13: Alexander F. (cliente 1) → 2× Papas Lays (ID 2, S/3.00)
INSERT INTO venta (id_venta, fecha, total, id_cliente) VALUES (13, SYSDATE, 6.00, 1);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (16, 13, 2, 2, 3.00, 6.00);

-- Venta 14: Alexander C. (cliente 2) → 6× Minisublime (ID 12, S/1.50)
INSERT INTO venta (id_venta, fecha, total, id_cliente) VALUES (14, SYSDATE, 9.00, 2);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (17, 14, 12, 6, 1.50, 9.00);

-- Venta 15: Jeff (cliente 3) → 1× Leche Gloria (4.50) + 2× Papas Lays (6.00) + 1× Oreo (1.50) = 12.00
INSERT INTO venta (id_venta, fecha, total, id_cliente) VALUES (15, SYSDATE, 12.00, 3);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (18, 15, 3, 1, 4.50, 4.50);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (19, 15, 2, 2, 3.00, 6.00);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (20, 15, 4, 1, 1.50, 1.50);

-- Venta 16: Alexander F. (cliente 1) → 1× Coca (4.00) + 1× Leche (4.50) + 2× Papas (6.00) + 1× Oreo (1.50) = 16.00
INSERT INTO venta (id_venta, fecha, total, id_cliente) VALUES (16, SYSDATE, 16.00, 1);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (21, 16, 1, 1, 4.00, 4.00);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (22, 16, 3, 1, 4.50, 4.50);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (23, 16, 2, 2, 3.00, 6.00);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (24, 16, 4, 1, 1.50, 1.50);

-- Venta 17: Alexander C. (cliente 2) → 2× Fanta (ID 8) + 2× Sprite (ID 9) = 2×2.20 + 2×2.20 = 8.80
INSERT INTO venta (id_venta, fecha, total, id_cliente) VALUES (17, SYSDATE, 8.80, 2);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (25, 17, 8, 2, 2.20, 4.40);
INSERT INTO detalle_venta (id_detalle, id_venta, id_producto, cantidad, precio, subtotal) VALUES (26, 17, 9, 2, 2.20, 4.40);
