DROP DATABASE food_now;
CREATE DATABASE food_now;
USE food_now;

-- Tabla tipoUsuario (Vendedor, Cliente)
CREATE TABLE tipousuario (
    idTipoUsuario INT AUTO_INCREMENT PRIMARY KEY,
    tipoUsuario VARCHAR(45)
);

-- Tabla usuarios
CREATE TABLE usuarios (
    idUsuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    correo VARCHAR(100),
    contrasenia VARCHAR(100),
    disponibilidad BOOLEAN,
    foto LONGBLOB,
    ubicacion TEXT,
    idTipoUsuario INT,
    FOREIGN KEY (idTipoUsuario) REFERENCES tipousuario(idTipoUsuario) ON DELETE CASCADE
);

-- Tabla categoriaProducto (Comida, Dulce, Bebida, Botana, Postre)
CREATE TABLE categoriaProducto (
    idcategoriaProducto INT AUTO_INCREMENT PRIMARY KEY,
    categoriaProducto VARCHAR(45)
);

-- Tabla productos
CREATE TABLE productos (
    idProducto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT,
    precio DECIMAL(10, 2),
    cantidadDisponible INT,
    disponible BOOLEAN,
    foto LONGBLOB,
    idcategoriaProducto INT,
    FOREIGN KEY (idcategoriaProducto) REFERENCES categoriaProducto(idcategoriaProducto) ON DELETE CASCADE,
    idVendedor INT,
    FOREIGN KEY (idVendedor) REFERENCES usuarios(idUsuario) ON DELETE CASCADE
);

-- Crear trigger para actualizar disponibilidad
DELIMITER $$
CREATE TRIGGER actualizar_disponibilidad
BEFORE UPDATE ON productos
FOR EACH ROW
BEGIN
    IF NEW.cantidadDisponible = 0 THEN
        SET NEW.disponible = FALSE;
    ELSE
        SET NEW.disponible = TRUE;
    END IF;
END$$
DELIMITER ;

-- Tabla estadoPedido (Activo, Entregado, Cancelado)
CREATE TABLE estadoPedido (
    idEstadoPedido INT AUTO_INCREMENT PRIMARY KEY,
    estadoPedido VARCHAR(45)
);

-- Tabla pedidos
CREATE TABLE pedidos (
    idPedido INT AUTO_INCREMENT PRIMARY KEY,
    fechaPedido DATETIME NOT NULL,
    cantidad INT,
    idCliente INT,
    FOREIGN KEY (idCliente) REFERENCES usuarios(idUsuario) ON DELETE CASCADE,
    idProducto INT,
    FOREIGN KEY (idProducto) REFERENCES productos(idProducto) ON DELETE CASCADE,
    idEstadoPedido INT,
    FOREIGN KEY (idEstadoPedido) REFERENCES estadoPedido(idEstadoPedido) ON DELETE CASCADE,
    idVendedor INT,
    FOREIGN KEY (idVendedor) REFERENCES usuarios(idUsuario) ON DELETE CASCADE
);

-- Crear trigger para actualizar cantidad de producto al cancelar pedido
DELIMITER $$
CREATE TRIGGER actualizar_cantidad_producto_al_cancelar
AFTER UPDATE ON pedidos
FOR EACH ROW
BEGIN
    IF NEW.idEstadoPedido = (SELECT idEstadoPedido FROM estadoPedido WHERE estadoPedido = 'Cancelado') THEN
        UPDATE productos
        SET cantidadDisponible = cantidadDisponible + OLD.cantidad
        WHERE idProducto = OLD.idProducto;
    END IF;
END$$
DELIMITER ;

-- Insertar datos en tipoUsuario
INSERT INTO tipousuario (tipoUsuario) VALUES ('Vendedor'), ('Cliente');

-- Insertar datos en usuarios
INSERT INTO usuarios (nombre, correo, contrasenia, disponibilidad, foto, ubicacion, idTipoUsuario) VALUES
('Juan Pérez', 'juan.perez@example.com', 'juan123', TRUE, NULL, 'Ubicacion A', 1),
('María López', 'maria.lopez@example.com', 'maria123', TRUE, NULL, 'Ubicacion B', 2);

-- Insertar datos en categoriaProducto
INSERT INTO categoriaProducto (categoriaProducto) VALUES ('Comida'), ('Dulce'), ('Bebida'), ('Botana'), ('Postre');

-- Insertar datos en productos
INSERT INTO productos (nombre, descripcion, precio, cantidadDisponible, disponible, foto, idcategoriaProducto, idVendedor) VALUES
('Pizza Margarita', 'Pizza con queso y tomate', 150.00, 10, TRUE, NULL, 1, 1),
('Refresco Cola', 'Refresco de cola de 500ml', 20.00, 50, TRUE, NULL, 3, 1),
('Pastel de Chocolate', 'Delicioso pastel de chocolate', 300.00, 5, TRUE, NULL, 5, 1);

-- Insertar datos en estadoPedido
INSERT INTO estadoPedido (estadoPedido) VALUES ('Activo'), ('Entregado'), ('Cancelado');

-- Insertar datos en pedidos
INSERT INTO pedidos (fechaPedido, cantidad, idCliente, idProducto, idVendedor, idEstadoPedido) VALUES
('2024-12-11 10:00:00', 1, 2, 1, 1, 1),
('2024-12-11 12:00:00', 1, 2, 2, 1, 1),
('2024-12-11 14:00:00', 1, 2, 3, 1, 1);
