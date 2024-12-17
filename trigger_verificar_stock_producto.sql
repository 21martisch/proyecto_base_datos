USE complejo_padel;
DELIMITER $$

CREATE TRIGGER verificar_stock_producto
BEFORE INSERT ON detalle_ventas
FOR EACH ROW
BEGIN
    DECLARE stock_disponible INT;

    -- Obtenemos el stock disponible
    SELECT stock
    INTO stock_disponible
    FROM productos
    WHERE producto_id = NEW.producto_id;

    -- Verificamos si hay suficiente stock
    IF stock_disponible < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay suficiente stock para este producto.';
    END IF;
END $$

DELIMITER ;

INSERT INTO productos (nombre, descripcion, categoria, precio, stock, proveedor_id)
VALUES ('Paleta Pro Adidas', 'Paleta profesional de pádel', 'Paletas', 120000, 5, 1);

INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario)
VALUES (1, 3, 10, 1000);
