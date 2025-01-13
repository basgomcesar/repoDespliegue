DROP DATABASE food_now; 

CREATE DATABASE food_now; 

 

SELECT * FROM usuarios; 

SELECT * FROM tipoUsuario; 

SELECT * FROM productos; 

SELECT * FROM pedidos; 

USE food_now; 

-- tipoUsuario Vendedor Clientes 

CREATE TABLE tipoUsuario( 

idTipoUsuario INT AUTO_INCREMENT PRIMARY KEY,  

    tipoUsuario VARCHAR(45) 

); 

 

-- usuarios 

CREATE TABLE usuarios ( 

    idUsuario INT AUTO_INCREMENT PRIMARY KEY,                 

    nombre VARCHAR(100), 

    correo VARCHAR(100), 

    contrasenia VARCHAR(100), 

    disponibilidad BOOLEAN,                

    foto LONGBLOB, 

    ubicacion TEXT, 

     

    idTipoUsuario INT,     

    FOREIGN KEY (idTipoUsuario) REFERENCES tipoUsuario(idTipoUsuario) ON DELETE CASCADE 

); 

 

-- categoriaProducto Comida Dulce Bebida Botana Postre 

CREATE TABLE categoriaProducto( 

idcategoriaProducto INT AUTO_INCREMENT PRIMARY KEY,  

    categoriaProducto VARCHAR(45) 

); 

-- productos 

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

 

-- estadoPedido activo entregado cancelado 

CREATE TABLE estadoPedido( 

idEstadoPedido INT AUTO_INCREMENT PRIMARY KEY,  

    estadoPedido VARCHAR(45) 

); 

 

-- pedidos 

CREATE TABLE pedidos ( 

    idPedido INT AUTO_INCREMENT PRIMARY KEY,                                        

    fechaPedido DATETIME NOT NULL, 

     

    idCliente INT,  

    FOREIGN KEY (idCliente) REFERENCES usuarios(idUsuario) ON DELETE CASCADE,  

    idProducto INT,           

    FOREIGN KEY (idProducto) REFERENCES productos(idProducto) ON DELETE CASCADE, 

    idEstadoPedido INT,           

    FOREIGN KEY (idEstadoPedido) REFERENCES estadoPedido(idEstadoPedido) ON DELETE CASCADE 

); 

 

 

-- Insertar datos en tipoUsuario 

INSERT INTO tipoUsuario (tipoUsuario) 

VALUES  

('Vendedor'), 

('Cliente'); 

 

-- Insertar datos en usuarios 

INSERT INTO usuarios (nombre, correo, contrasenia, disponibilidad, foto, ubicacion, idTipoUsuario) 

VALUES  

('Juan Pérez', 'juan.perez@example.com', 'juan123', TRUE, NULL, 'Ubicacion A', 1), -- Vendedor 

('María López', 'maria.lopez@example.com', 'maria123', TRUE, NULL, 'U B', 2); -- Cliente 

 

-- Insertar datos en categoriaProducto Comida Dulce Bebida Botana Postre 

INSERT INTO categoriaProducto (categoriaProducto) 

VALUES  

('Comida'), 

('Dulce'), 

('Bebida'), 

('Botana'), 

('Postre'); 

 

-- Insertar datos en productos 

INSERT INTO productos (nombre, descripcion, precio, cantidadDisponible, disponible, foto, idcategoriaProducto, idVendedor) 

VALUES  

('Pizza Margarita', 'Pizza con queso y tomate', 150.00, 10, TRUE, NULL, 1, 1), -- Vendido por Juan Pérez 

('Refresco Cola', 'Refresco de cola de 500ml', 20.00, 50, TRUE, NULL, 3, 1),   -- Vendido por Juan Pérez 

('Pastel de Chocolate', 'Delicioso pastel de chocolate', 300.00, 5, TRUE, NULL, 5, 1); -- Vendido por Juan Pérez 

 

-- Insertar datos en estadoPedido 

INSERT INTO estadoPedido (estadoPedido) 

VALUES  

('Activo'), 

('Entregado'), 

('Cancelado'); 

 

-- Insertar datos en pedidos 

INSERT INTO pedidos (fechaPedido, idCliente, idProducto) 

VALUES  

('2024-12-11 10:00:00', 2, 1), -- Pedido por María López, producto: Pizza Margarita 

('2024-12-11 12:00:00', 2, 2), -- Pedido por María López, producto: Refresco Cola 

('2024-12-11 14:00:00', 2, 3); -- Pedido por María López, producto: Pastel de Chocolate 

 