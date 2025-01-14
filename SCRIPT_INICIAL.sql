CREATE DATABASE IF NOT EXISTS complejo_padel;
USE complejo_padel;

-- Crear tabla clientes
CREATE TABLE clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono INT NOT NULL
);

-- Crear tabla canchas
CREATE TABLE canchas (
    cancha_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    tipo ENUM('cesped', 'cemento', 'sintetico') NOT NULL,
    estado ENUM('disponible', 'mantenimiento', 'ocupada') NOT NULL
);

-- Crear tabla horarios
CREATE TABLE horarios (
    horario_id INT AUTO_INCREMENT PRIMARY KEY,
    cancha_id INT NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    FOREIGN KEY (cancha_id) REFERENCES canchas (cancha_id),
    CONSTRAINT chk_horarios CHECK (hora_fin > hora_inicio)
);

-- Crear tabla reservas
CREATE TABLE reservas (
    reserva_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    cancha_id INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes (cliente_id),
    FOREIGN KEY (cancha_id) REFERENCES canchas (cancha_id)
);

-- Crear tabla pagos
CREATE TABLE pagos (
    pago_id INT AUTO_INCREMENT PRIMARY KEY,
    reserva_id INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    metodo_pago ENUM('efectivo', 'tarjeta', 'transferencia') NOT NULL,
    FOREIGN KEY (reserva_id) REFERENCES reservas (reserva_id)
);
-- Crear tabla proveedores
CREATE TABLE proveedores (
    proveedor_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL,
    contacto VARCHAR(45),
    telefono VARCHAR(15),
    direccion VARCHAR(100)
);
-- Crear tabla productos
CREATE TABLE productos (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL,
    descripcion VARCHAR(255),
    categoria ENUM('paletas', 'ropa', 'zapatillas', 'accesorios') NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    proveedor_id INT NOT NULL,
    FOREIGN KEY (proveedor_id) REFERENCES proveedores (proveedor_id),
    CONSTRAINT chk_stock CHECK (stock >= 0)
);

-- Crear tabla ventas
CREATE TABLE ventas (
    venta_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_venta DECIMAL(10,2) NOT NULL,
    metodo_pago ENUM('efectivo', 'tarjeta', 'transferencia') NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes (cliente_id)
);

-- Crear tabla detalle_ventas
CREATE TABLE detalle_ventas (
    detalle_id INT AUTO_INCREMENT PRIMARY KEY,
    venta_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (venta_id) REFERENCES ventas (venta_id),
    FOREIGN KEY (producto_id) REFERENCES productos (producto_id)
);
-- Tabla de hechos para análisis de ventas y reservas
CREATE TABLE hechos_transacciones (
    hecho_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    tipo_transaccion ENUM('reserva', 'venta') NOT NULL,
    transaccion_id INT NOT NULL,
    fecha DATETIME NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

	-- Tabla transaccionales 

CREATE TABLE transacciones_reservas (
    transaccion_id INT AUTO_INCREMENT PRIMARY KEY,
    reserva_id INT NOT NULL,
    cliente_id INT NOT NULL,
    cancha_id INT NOT NULL,
    estado_reserva ENUM('pendiente', 'confirmada', 'cancelada') NOT NULL,
    FOREIGN KEY (reserva_id) REFERENCES reservas(reserva_id),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
    FOREIGN KEY (cancha_id) REFERENCES canchas(cancha_id)
);
CREATE TABLE transacciones_ventas (
    transaccion_id INT AUTO_INCREMENT PRIMARY KEY,
    venta_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,
    FOREIGN KEY (venta_id) REFERENCES ventas(venta_id),
    FOREIGN KEY (producto_id) REFERENCES productos(producto_id)
);

	-- Vista del stock de productos
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

	-- Vista de resumen de ventas
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

	-- Vista de ingresos de reservas
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
    
	-- Vista de ventas de productos
    
CREATE VIEW complejo_padel.vista_ventas_productos AS
    SELECT 
		v.venta_id AS venta_id,
        v.fecha_venta AS fecha_venta,
        c.nombre AS cliente_nombre,
        dv.producto_id AS producto_id,
        p.nombre AS producto_nombre,
        dv.cantidad AS cantidad,
        dv.precio_unitario AS precio_unitario,
        (dv.cantidad * dv.precio_unitario) AS subtotal
    FROM
        (((complejo_padel.ventas v
        JOIN complejo_padel.detalle_ventas dv ON ((v.venta_id = dv .venta_id)))
        JOIN complejo_padel.productos p ON ((dv.producto_id = p.producto_id)))
        JOIN complejo_padel.clientes c ON ((v.cliente_id = c.cliente_id)));
        
        -- Vista de reserva clientes
	CREATE VIEW complejo_padel.vista_reservas_clientes AS
    SELECT 
        r.reserva_id AS reserva_id,
        c.nombre AS cliente_nombre,
        r.fecha_hora AS fecha_hora,
        ca.nombre AS cancha_nombre,
        ca.tipo AS cancha_tipo
    FROM
        ((complejo_padel.reservas r
        JOIN complejo_padel.clientes c ON ((r.cliente_id = c.cliente_id)))
        JOIN complejo_padel.canchas ca ON ((r.cancha_id = ca.cancha_id)));
    DELIMITER $$

-- Función para calcular el total de la venta
CREATE DEFINER=`root`@`localhost` FUNCTION `calcular_total_venta`(venta_id_param INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT SUM(cantidad * precio_unitario)
    INTO total
    FROM detalle_ventas
    WHERE venta_id = venta_id_param;

    RETURN total;
END $$

-- Función para consultar el stock
CREATE DEFINER=`root`@`localhost` FUNCTION `consultar_stock`(producto_id_param INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE stock_actual INT;

    SELECT stock 
    INTO stock_actual
    FROM productos
    WHERE producto_id = producto_id_param;

    RETURN stock_actual;
END $$

-- Procedimiento para insertar una venta
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_venta`(
    IN cliente_id_param INT, 
    IN fecha_venta_param DATETIME, 
    IN metodo_pago_param ENUM('Efectivo', 'Tarjeta', 'Transferencia'), 
    IN total_param DECIMAL(10,2)
)
BEGIN
    INSERT INTO ventas (cliente_id, fecha_venta, metodo_pago, total_venta)
    VALUES (cliente_id_param, fecha_venta_param, metodo_pago_param, total_param);
END $$

-- Procedimiento para insertar el detalle de una venta
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
END $$

DELIMITER ;

    
    -- Trigger para verificar el stock de un producto
    DELIMITER $$

	CREATE TRIGGER verificar_stock_producto
	BEFORE INSERT ON detalle_ventas
	FOR EACH ROW
	BEGIN
		DECLARE stock_disponible INT;

		-- Obtenemos el stock disponible
		SELECT stock
		INTO stock_disponible
		FROM productos
		WHERE producto_id = NEW.producto_id;

		-- Verificamos si hay suficiente stock
		IF stock_disponible < NEW.cantidad THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay suficiente stock para este producto.';
		END IF;
	END $$

	DELIMITER ;

	INSERT INTO productos (nombre, descripcion, categoria, precio, stock, proveedor_id)
	VALUES ('Paleta Pro Adidas', 'Paleta profesional de pádel', 'Paletas', 120000, 5, 1);

	INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario)
	VALUES (1, 3, 10, 1000);



