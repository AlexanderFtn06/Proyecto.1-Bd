--Procedimientos
--Para registrar una venta
CREATE OR REPLACE PROCEDURE registrar_venta (
    p_id_venta     IN NUMBER,
    p_id_cliente   IN NUMBER
) AS
BEGIN
    INSERT INTO venta (id_venta, fecha, total, id_cliente)
    VALUES (p_id_venta, SYSDATE, 0, p_id_cliente);

    DBMS_OUTPUT.PUT_LINE('Venta registrada con ID: ' || p_id_venta);
    COMMIT;
END;
/
EXEC registrar_venta(50, 1);

--Para agregar detalle venta
CREATE OR REPLACE PROCEDURE agregar_detalle_venta (
    p_id_detalle   IN NUMBER,
    p_id_venta     IN NUMBER,
    p_id_producto  IN NUMBER,
    p_cantidad     IN NUMBER
) AS
    v_precio NUMBER;
    v_subtotal NUMBER;
BEGIN
    SELECT precio_prod INTO v_precio
    FROM producto
    WHERE id_producto = p_id_producto;

    v_subtotal := v_precio * p_cantidad;

    INSERT INTO detalle_venta
        (id_detalle, id_venta, id_producto, cantidad, precio, subtotal)
    VALUES
        (p_id_detalle, p_id_venta, p_id_producto, p_cantidad, v_precio, v_subtotal);

    UPDATE venta
    SET total = total + v_subtotal
    WHERE id_venta = p_id_venta;

    UPDATE producto
    SET stock = stock - p_cantidad
    WHERE id_producto = p_id_producto;

    COMMIT;
END;
/

--Actualizar venta
CREATE OR REPLACE PROCEDURE actualizar_venta (
    p_id_venta   IN NUMBER,
    p_id_cliente IN NUMBER
) AS
BEGIN
    UPDATE venta
    SET id_cliente = p_id_cliente,
        fecha = SYSDATE
    WHERE id_venta = p_id_venta;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No existe la venta con ID: ' || p_id_venta);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Venta actualizada correctamente: ID_VENTA=' || p_id_venta);
        DBMS_OUTPUT.PUT_LINE('Nuevo cliente asignado: ' || p_id_cliente);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al actualizar venta: ' || SQLERRM);
END;
/
EXEC actualizar_venta(50, 3);

--Eliminar venta junto a sus detalles venta
CREATE OR REPLACE PROCEDURE eliminar_venta (
    p_id_venta IN NUMBER
) AS
    v_existe   NUMBER;
    v_detalles NUMBER;
BEGIN
    -- Verificar si existe la venta
    SELECT COUNT(*) INTO v_existe
    FROM venta
    WHERE id_venta = p_id_venta;

    IF v_existe = 0 THEN
        DBMS_OUTPUT.PUT_LINE('La venta con ID ' || p_id_venta || ' no existe.');
        RETURN;
    END IF;

    -- Contar detalles (informativo)
    SELECT COUNT(*) INTO v_detalles
    FROM detalle_venta
    WHERE id_venta = p_id_venta;

    -- Devolver stock: para cada producto en los detalles, sumar la cantidad al stock
    FOR rec IN (
        SELECT id_producto, cantidad
        FROM detalle_venta
        WHERE id_venta = p_id_venta
    ) LOOP
        UPDATE producto
        SET stock = stock + rec.cantidad
        WHERE id_producto = rec.id_producto;
    END LOOP;

    -- Eliminar detalles
    DELETE FROM detalle_venta
    WHERE id_venta = p_id_venta;

    -- Eliminar venta
    DELETE FROM venta
    WHERE id_venta = p_id_venta;

    DBMS_OUTPUT.PUT_LINE('Venta con ID ' || p_id_venta || ' eliminada correctamente.');
    DBMS_OUTPUT.PUT_LINE(' Detalles eliminados: ' || v_detalles);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al eliminar la venta: ' || SQLERRM);
END;
/

EXEC eliminar_venta(50);


--Triggers basicos
--Para evitar stock negativo al actualizar manualmente productos
CREATE OR REPLACE TRIGGER trg_no_stock_negativo
BEFORE UPDATE OF stock ON producto
FOR EACH ROW
BEGIN
    IF :NEW.stock < 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'El stock no puede ser negativo.');
    END IF;
END;
/

--Para evitar que se eliminen proveedores con productos asociados
CREATE OR REPLACE TRIGGER trg_no_eliminar_proveedor_usado
BEFORE DELETE ON proveedor
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM producto
    WHERE id_proveedor = :OLD.id_proveedor;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20020,
        'No se puede eliminar el proveedor porque tiene productos registrados.');
    END IF;
END;
/


--Para calcular subtotal automáticamente
CREATE OR REPLACE TRIGGER tr_calcular_subtotal
BEFORE INSERT OR UPDATE ON detalle_venta
FOR EACH ROW
BEGIN
    :NEW.subtotal := :NEW.cantidad * :NEW.precio;
END;
/

--Para evitar nombres vacios en la tabla clientes
CREATE OR REPLACE TRIGGER tr_validar_nombre_cliente
BEFORE INSERT OR UPDATE ON cliente
FOR EACH ROW
BEGIN
    IF :NEW.nombre_cli IS NULL OR TRIM(:NEW.nombre_cli) = '' THEN
        RAISE_APPLICATION_ERROR(-20002, 'El nombre del cliente no puede estar vacío.');
    END IF;
END;
/

--Vistas 
--Productos con categorías y proveedores
CREATE OR REPLACE VIEW vts_productos_detalle AS
SELECT p.id_producto, p.nombre_prod, p.precio_prod, p.stock,
       c.nombre_cat AS categoria,
       pr.nombre_prove AS proveedor
FROM producto p
JOIN categoria c ON p.id_categoria = c.id_categoria
JOIN proveedor pr ON p.id_proveedor = pr.id_proveedor;

SELECT * FROM vts_productos_detalle;

--Ventas con detalle
CREATE OR REPLACE VIEW vts_ventas_detalle AS
SELECT v.id_venta, v.fecha, v.total,
       c.nombre_cli,
       d.id_producto, d.cantidad, d.precio, d.subtotal
FROM venta v
JOIN cliente c ON v.id_cliente = c.id_cliente
JOIN detalle_venta d ON v.id_venta = d.id_venta;

SELECT * FROM vts_ventas_detalle;

--Productos con stock bajo
CREATE OR REPLACE VIEW vts_productos_stock_bajo AS
SELECT
    id_producto,
    nombre_prod,
    precio_prod,
    stock,
    id_categoria,
    id_proveedor
FROM producto
WHERE stock <= 15;

SELECT * FROM vts_productos_stock_bajo;

--Ventas mayores
CREATE OR REPLACE VIEW vts_top3_ventas_detalle AS
SELECT 
    v.id_venta,
    v.fecha,
    v.total,
    c.nombre_cli
FROM venta v
JOIN cliente c ON v.id_cliente = c.id_cliente
ORDER BY v.total DESC
FETCH FIRST 3 ROWS ONLY;

SELECT * FROM vts_top3_ventas_detalle;








