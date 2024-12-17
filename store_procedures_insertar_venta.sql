CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_venta`(
    IN cliente_id_param INT, 
    IN fecha_venta_param DATETIME, 
    IN metodo_pago_param ENUM('Efectivo', 'Tarjeta', 'Transferencia'), 
    IN total_param DECIMAL(10,2)
)
BEGIN
    INSERT INTO ventas (cliente_id, fecha_venta, metodo_pago, total_venta)
    VALUES (cliente_id_param, fecha_venta_param, metodo_pago_param, total_param);
END