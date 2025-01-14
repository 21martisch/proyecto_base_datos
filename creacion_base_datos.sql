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

