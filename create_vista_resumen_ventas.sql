CREATE VIEW vista_resumen_ventas AS
SELECT 
    v.venta_id,
    c.nombre AS cliente_nombre,
    v.fecha_venta,
    dv.producto_id,
    p.nombre AS producto_nombre,
    dv.cantidad,
    dv.precio_unitario,
    (dv.cantidad * dv.precio_unitario) AS subtotal,
    v.total_venta AS total
FROM 
    ventas v
JOIN 
    clientes c ON v.cliente_id = c.cliente_id
JOIN 
    detalle_ventas dv ON v.venta_id = dv.venta_id
JOIN 
    productos p ON dv.producto_id = p.producto_id;
