CREATE DEFINER=`root`@`localhost` FUNCTION `consultar_stock`(producto_id_param INT) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE stock_actual INT;

    SELECT stock INTO stock_actual
    FROM productos
    WHERE producto_id = producto_id_param;

    RETURN stock_actual;
END