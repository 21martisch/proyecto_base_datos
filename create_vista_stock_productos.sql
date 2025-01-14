CREATE VIEW vista_stock_productos AS
SELECT 
    p.producto_id,
    p.nombre AS producto_nombre,
    p.descripcion,
    p.categoria,
    p.stock,
    pr.nombre AS proveedor_nombre,
    pr.contacto
FROM 
    productos p
JOIN 
    proveedores pr ON p.proveedor_id = pr.proveedor_id;
