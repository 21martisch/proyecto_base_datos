CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `complejo_padel`.`vista_reservas_clientes` AS
    SELECT 
        `r`.`reserva_id` AS `reserva_id`,
        `c`.`nombre` AS `cliente_nombre`,
        `r`.`fecha_hora` AS `fecha_hora`,
        `ca`.`nombre` AS `cancha_nombre`,
        `ca`.`tipo` AS `cancha_tipo`
    FROM
        ((`complejo_padel`.`reservas` `r`
        JOIN `complejo_padel`.`clientes` `c` ON ((`r`.`cliente_id` = `c`.`cliente_id`)))
        JOIN `complejo_padel`.`canchas` `ca` ON ((`r`.`cancha_id` = `ca`.`cancha_id`)))