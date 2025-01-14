CREATE VIEW vista_ingresos_reservas AS
SELECT 
    r.reserva_id,
    c.nombre AS cliente_nombre,
    r.fecha_hora,
    p.monto AS pago_monto,
    p.metodo_pago
FROM 
    reservas r
JOIN 
    clientes c ON r.cliente_id = c.cliente_id
JOIN 
    pagos p ON r.reserva_id = p.reserva_id;
