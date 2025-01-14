-- =========================================================
-- INSERCIÓN DE DATOS
-- =========================================================
USE complejo_padel;
-- Insertar Clientes
INSERT INTO clientes (nombre, email, telefono)
VALUES 
('Martina Pérez', 'martina@mail.com', 123456789),
('Juan González', 'juan@mail.com', 987654321);

select * from clientes;
-- Insertar Proveedores
INSERT INTO proveedores (nombre, contacto, telefono, direccion)
VALUES
('Proveedor A', 'Juan Pérez', '111222333', 'Calle 123'),
('Proveedor B', 'Ana López', '444555666', 'Avenida 456');

-- Insertar Productos
INSERT INTO productos (nombre, descripcion, categoria, precio, stock, proveedor_id)
VALUES
('Paleta Pro', 'Paleta profesional de pádel', 'Paletas', 20000.00, 10, 1),
('Zapatillas Pádel', 'Zapatillas de alta resistencia', 'Zapatillas', 15000.00, 20, 2);

-- Insertar Canchas
INSERT INTO canchas (nombre, tipo, estado)
VALUES
('Cancha 1', 'cesped', 'Disponible'),
('Cancha 2', 'cemento', 'Mantenimiento');

-- Insertar Ventas
INSERT INTO ventas (cliente_id, fecha_venta, total_venta, metodo_pago)
VALUES
(1, NOW(), 20000.00, 'Tarjeta');

-- Insertar Detalles de Ventas
INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario)
VALUES
(1, 1, 1, 20000.00);

-- Insertar Reservas
INSERT INTO reservas (cliente_id, cancha_id, fecha_hora)
VALUES
(1, 1, '2024-12-20 15:00:00');

-- Insertar Pagos
INSERT INTO pagos (reserva_id, monto, fecha_pago, metodo_pago)
VALUES
(1, 5000.00, NOW(), 'Efectivo');

select * from pagos;
-- Insertar una reserva en la tabla de hechos
INSERT INTO hechos_transacciones (cliente_id, tipo_transaccion, transaccion_id, fecha, monto)
SELECT cliente_id, 'reserva', reserva_id, fecha_hora, 5000.00
FROM reservas
WHERE reserva_id = 1;

INSERT INTO hechos_transacciones (cliente_id, tipo_transaccion, transaccion_id, fecha, monto)
SELECT cliente_id, 'reserva', reserva_id, fecha_hora, 5000.00
FROM reservas
WHERE reserva_id = 2;
select * from hechos_transacciones;
-- Insertar una venta en la tabla de hechos
INSERT INTO hechos_transacciones (cliente_id, tipo_transaccion, transaccion_id, fecha, monto)
SELECT cliente_id, 'venta', venta_id, fecha_venta, total_venta
FROM ventas
WHERE venta_id = 1;
-- Insertar datos en transacciones_reservas
INSERT INTO transacciones_reservas (reserva_id, cliente_id, cancha_id, estado_reserva)
VALUES (1, 1, 1, 'confirmada');
select * from transacciones_reservas;
-- Insertar datos en transacciones_ventas
INSERT INTO transacciones_ventas (venta_id, producto_id, cantidad, precio_unitario)
VALUES (1, 1, 1, 20000.00);
select * from transacciones_ventas;
