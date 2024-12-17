CREATE DEFINER=`root`@`localhost` FUNCTION `calcular_total_venta`(venta_id_param INT) RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT SUM(cantidad * precio_unitario)
    INTO total
    FROM detalle_ventas
    WHERE venta_id = venta_id_param;

    RETURN total;
END