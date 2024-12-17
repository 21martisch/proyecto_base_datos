CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_detalle_venta`(
    IN venta_id_param INT, 
    IN producto_id_param INT, 
    IN cantidad_param INT, 
    IN precio_unitario_param DECIMAL(10,2)
)
BEGIN
    INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario)
    VALUES (venta_id_param, producto_id_param, cantidad_param, precio_unitario_param);

    -- Actualizar el stock del producto
    UPDATE productos
    SET stock = stock - cantidad_param
    WHERE producto_id = producto_id_param;
END