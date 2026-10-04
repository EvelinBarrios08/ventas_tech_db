-- ══════════════════════════════════════════
-- TechStore — Script de Ventas
-- Autora: Barrios Evelin Eliana
-- ══════════════════════════════════════════

IF DB_ID ('Ventas_Tech_DB') IS NULL
BEGIN
CREATE DATABASE Ventas_Tech_DB;
END;

USE Ventas_Tech_DB;

-- ══════════════════════════════════════════
-- PASO 1: DROP TABLES 
-- Eliminamos las tablas en orden inverso a sus dependencias para evitar conflictos con las FK.
-- ══════════════════════════════════════════
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;

-- ══════════════════════════════════════════
-- PASO 2: CREATE TABLES
-- Creamos primero las tablas independientes y luego las tablas que dependen de ellas mediante FK
-- ══════════════════════════════════════════

-- Tabla Categorias --> tabla independiente
-- Contiene las categorías de productos para evitar repetir la descripción de cada categoría.
CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY ,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);

-- Tabla Clientes --> tabla independiente
-- Contiene los datos principales de los clientes.
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    ciudad VARCHAR(50),
    fecha_registro DATE NOT NULL
);

-- Tabla Productos --> depende de categorias
-- Relaciona cada producto con una categoría mediante una Foreign Key.
CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    
    id_categoria INT 
    FOREIGN KEY REFERENCES categorias(id_categoria),
    
    precio DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    activo BIT DEFAULT 1
);


-- Tabla Ventas --> depende de clientes y productos
-- Tabla de hechos que relaciona clientes y productos mediante Foreign Keys.
CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    id_cliente INT
        FOREIGN KEY REFERENCES clientes(id_cliente),
    id_producto INT
        FOREIGN KEY REFERENCES productos(id_producto),
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    fecha_venta DATE NOT NULL
);


-- ══════════════════════════════════════════
-- PASO 3: INSERT
-- Cargamos los registros respetando el orden de dependencias: categorias, clientes, productos y ventas.
-- ══════════════════════════════════════════

-- categorias — 4 registros
INSERT INTO categorias 
    (id_categoria, nombre_categoria, descripcion) 
VALUES
    (1, 'Computación','Laptops, PCs y monitores'),
    (2, 'Accesorios','Periféricos y complementos'),
    (3, 'Audio','Auriculares y parlantes'),
    (4, 'Almacenamiento','Discos y memorias');


-- clientes — 5 registros
INSERT INTO clientes 
    (id_cliente, nombre, email, ciudad, fecha_registro) 
VALUES
  (1, 'María López','maria@mail.com', 'Buenos Aires','2024-01-05'),
  (2, 'Carlos Ruiz','carlos@mail.com', 'Córdoba', '2024-01-10'),
  (3, 'Ana Gómez','ana@mail.com', 'Rosario', '2024-02-01'),
  (4, 'Pedro Sanz','pedro@mail.com','Mendoza', '2024-02-15'),
  (5, 'Laura Torres','laura@mail.com','Tucumán', '2024-03-01');


-- productos — 6 registros
INSERT INTO productos 
(id_producto, nombre_producto, id_categoria, precio, stock, activo) 
VALUES
  (1, 'Laptop Pro 15',      1, 1200.00, 15, 1),
  (2, 'Mouse Inalámbrico',  2,   28.00, 80, 1),
  (3, 'Monitor 4K 27',      1,  450.00, 12, 1),
  (4, 'Auriculares BT Pro', 3,  120.00, 35, 1),
  (5, 'SSD Externo 1TB',    4,  130.00, 18, 1),
  (6, 'Teclado Mecánico',   2,   95.00, 40, 1);

-- ventas — 10 registros
INSERT INTO ventas 
(id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) 
VALUES
  ( 1, 1, 1, 2, 1200.00, '2024-03-05'),
  ( 2, 2, 2, 5,   28.00, '2024-03-06'),
  ( 3, 3, 3, 1,  450.00, '2024-03-07'),
  ( 4, 1, 4, 2,  120.00, '2024-03-08'),
  ( 5, 4, 5, 3,  130.00, '2024-03-10'),
  ( 6, 2, 6, 4,   95.00, '2024-03-11'),
  ( 7, 5, 1, 1, 1200.00, '2024-03-12'),
  ( 8, 3, 2, 8,   28.00, '2024-03-13'),
  ( 9, 4, 4, 1,  120.00, '2024-03-14'),
  (10, 5, 3, 2,  450.00, '2024-03-15');


-- ══════════════════════════════════════════
-- PASO 4: VALIDACION: Se verifica que las cuatro tablas hayan sido
-- creadas correctamente y contengan la cantidad de registros solicitada en el enunciado.
-- ══════════════════════════════════════════
SELECT * FROM categorias;   -- esperado: 4 filas
SELECT * FROM clientes;     -- esperado: 5 filas
SELECT * FROM productos;    -- esperado: 6 filas
SELECT * FROM ventas;       -- esperado: 10 filas
