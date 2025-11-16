ALTER TABLE categoria
ADD CONSTRAINT uq_cat_nombre UNIQUE (nombre_cat);

ALTER TABLE proveedor
ADD CONSTRAINT uq_prove_correo UNIQUE (correo_prove);

ALTER TABLE producto
ADD CONSTRAINT ck_precio_prod CHECK (precio_prod > 0);

ALTER TABLE producto
ADD CONSTRAINT CK_stock CHECK (stock >= 0);


ALTER TABLE cliente
ADD CONSTRAINT uq_cli_email UNIQUE (email_cli);

ALTER TABLE cliente
ADD CONSTRAINT CK_email_cli CHECK (email_cli LIKE '%@%.%');


ALTER TABLE venta
ADD CONSTRAINT CK_total CHECK (total >= 0);

ALTER TABLE detalle_venta
ADD CONSTRAINT CK_cantidad CHECK (cantidad > 0);

ALTER TABLE detalle_venta
ADD CONSTRAINT CK_precio CHECK (precio >= 0);

ALTER TABLE detalle_venta
ADD CONSTRAINT CK_subtotal CHECK (subtotal >= 0);

--Consultas:
SELECT avg(precio_prod) as Promedio from producto;

SELECT c.nombre_cat AS categoria,
COUNT(p.id_producto) AS cantidad_productos
FROM categoria c
LEFT JOIN producto p 
ON c.id_categoria = p.id_categoria
GROUP BY c.nombre_cat;

SELECT c.nombre_cat AS categoria,
SUM(p.precio_prod) AS Suma_precios
FROM categoria c LEFT JOIN producto p 
ON c.id_categoria = p.id_categoria
GROUP BY c.nombre_cat;

SELECT p.nombre_prod,c.nombre_cat AS categoria,
pr.nombre_prove AS proveedor,p.precio_prod,p.stock
FROM producto p JOIN categoria c ON p.id_categoria = c.id_categoria
JOIN proveedor pr ON p.id_proveedor = pr.id_proveedor;

SELECT v.id_venta, c.nombre_cli, v.fecha, v.total
FROM venta v JOIN cliente c ON v.id_cliente = c.id_cliente;

SELECT p.nombre_prod, SUM(dv.cantidad) AS total_vendido
FROM detalle_venta dv
JOIN producto p ON dv.id_producto = p.id_producto
GROUP BY p.nombre_prod
ORDER BY total_vendido DESC;

SELECT v.id_venta, v.fecha,v.total,
c.nombre_cli AS cliente
FROM venta v
JOIN cliente c ON v.id_cliente = c.id_cliente
WHERE v.total > (SELECT AVG(total) FROM venta);

SELECT p.nombre_prod, p.precio_prod, c.nombre_cat
FROM producto p JOIN categoria c ON p.id_categoria = c.id_categoria
WHERE p.precio_prod > (SELECT AVG(p2.precio_prod)
                       FROM producto p2
                       WHERE p2.id_categoria = p.id_categoria);

--Índices 

CREATE INDEX idx_producto_nombre ON producto(nombre_prod);
CREATE INDEX idx_producto_categoria ON producto(id_categoria);
CREATE INDEX idx_producto_proveedor ON producto(id_proveedor);

CREATE INDEX idx_cliente_email ON cliente(email_cli);
CREATE INDEX idx_cliente_nombre ON cliente(nombre_cli);

CREATE INDEX idx_venta_fecha ON venta(fecha);
CREATE INDEX idx_venta_cliente ON venta(id_cliente);

CREATE INDEX idx_detalle_venta_venta ON detalle_venta(id_venta);
CREATE INDEX idx_detalle_venta_producto ON detalle_venta(id_producto);















