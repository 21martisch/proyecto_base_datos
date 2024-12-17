CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `complejo_padel`.`vista_ventas_productos` AS
    SELECT 
        `v`.`venta_id` AS `venta_id`,
        `v`.`fecha_venta` AS `fecha_venta`,
        `c`.`nombre` AS `cliente_nombre`,
        `dv`.`producto_id` AS `producto_id`,
        `p`.`nombre` AS `producto_nombre`,
        `dv`.`cantidad` AS `cantidad`,
        `dv`.`precio_unitario` AS `precio_unitario`,
        (`dv`.`cantidad` * `dv`.`precio_unitario`) AS `subtotal`
    FROM
        (((`complejo_padel`.`ventas` `v`
        JOIN `complejo_padel`.`detalle_ventas` `dv` ON ((`v`.`venta_id` = `dv`.`venta_id`)))
        JOIN `complejo_padel`.`productos` `p` ON ((`dv`.`producto_id` = `p`.`producto_id`)))
        JOIN `complejo_padel`.`clientes` `c` ON ((`v`.`cliente_id` = `c`.`cliente_id`)))