-- =========================================================
--  CRM XTART - Estructura Base de Datos (MySQL 8)
-- =========================================================
--  Características:
--  * Motor InnoDB (soporte de FK y transacciones)
--  * Codificación utf8mb4 (Unicode completo)
--  * Integridad referencial garantizada
--  * Índices en campos de búsqueda y relaciones
-- =========================================================

CREATE DATABASE IF NOT EXISTS crm_xtart
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

USE crm_xtart;

-- =========================================================
--  1. Tabla: roles_empleado
-- =========================================================
CREATE TABLE roles_empleado (
  id_rol INT AUTO_INCREMENT PRIMARY KEY,
  nombre_rol VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =========================================================
--  2. Tabla: empleados
-- =========================================================
CREATE TABLE empleados (
  id_empleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  telefono VARCHAR(20),
  password VARCHAR(255) NOT NULL,
  id_rol INT NOT NULL,
  fecha_ingreso DATE,
  estado VARCHAR(50) DEFAULT 'activo',
  CONSTRAINT fk_empleado_rol FOREIGN KEY (id_rol)
    REFERENCES roles_empleado(id_rol)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE INDEX idx_empleados_email ON empleados(email);

-- =========================================================
--  3. Tabla: clientes
-- =========================================================
CREATE TABLE clientes (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  email VARCHAR(150) UNIQUE,
  telefono VARCHAR(20),
  tipo_cliente VARCHAR(50), -- persona o empresa
  password VARCHAR(255) NOT NULL,
  fecha_alta DATE,
  id_empleado_responsable INT,
  CONSTRAINT fk_cliente_empleado FOREIGN KEY (id_empleado_responsable)
    REFERENCES empleados(id_empleado)
    ON UPDATE CASCADE
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE INDEX idx_clientes_email ON clientes(email);
CREATE INDEX idx_clientes_tipo ON clientes(tipo_cliente);

-- =========================================================
--  4. Tabla: productos
-- =========================================================
CREATE TABLE productos (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  descripcion TEXT,
  categoria VARCHAR(50) NOT NULL, -- ciclo_formativo o formacion_complementaria
  precio DECIMAL(10,2) NOT NULL,
  activo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE INDEX idx_productos_categoria ON productos(categoria);

-- =========================================================
--  5. Tabla: presupuestos
-- =========================================================
CREATE TABLE presupuestos (
  id_presupuesto INT AUTO_INCREMENT PRIMARY KEY,
  id_empleado INT NOT NULL,
  id_cliente_pagador INT NOT NULL,
  id_cliente_beneficiario INT NOT NULL,
  id_producto INT NOT NULL,
  presupuesto DECIMAL(10,2) NOT NULL,
  estado VARCHAR(50) DEFAULT 'nuevo', -- nuevo, en_proceso, aceptado, cerrado, rechazado
  fecha_apertura DATE,
  fecha_cierre DATE,
  CONSTRAINT fk_presupuesto_empleado FOREIGN KEY (id_empleado)
    REFERENCES empleados(id_empleado)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_presupuesto_pagador FOREIGN KEY (id_cliente_pagador)
    REFERENCES clientes(id_cliente)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_presupuesto_beneficiario FOREIGN KEY (id_cliente_beneficiario)
    REFERENCES clientes(id_cliente)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_presupuesto_producto FOREIGN KEY (id_producto)
    REFERENCES productos(id_producto)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE INDEX idx_presupuestos_estado ON presupuestos(estado);
CREATE INDEX idx_presupuestos_fecha_apertura ON presupuestos(fecha_apertura);

-- =========================================================
--  6. Tabla: facturas
-- =========================================================
CREATE TABLE facturas (
  id_factura INT AUTO_INCREMENT PRIMARY KEY,
  num_factura VARCHAR(50) NOT NULL UNIQUE,
  id_cliente_pagador INT NOT NULL,
  id_empleado INT,
  fecha_emision DATE NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  estado VARCHAR(50) DEFAULT 'borrador', -- borrador, emitida, pagada, vencida
  notas TEXT,
  CONSTRAINT fk_factura_pagador FOREIGN KEY (id_cliente_pagador)
    REFERENCES clientes(id_cliente)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_factura_empleado FOREIGN KEY (id_empleado)
    REFERENCES empleados(id_empleado)
    ON UPDATE CASCADE
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE INDEX idx_facturas_estado ON facturas(estado);
CREATE INDEX idx_facturas_fecha ON facturas(fecha_emision);

-- =========================================================
--  7. Tabla: factura_productos
-- =========================================================
CREATE TABLE factura_productos (
  id_factura_producto INT AUTO_INCREMENT PRIMARY KEY,
  id_factura INT NOT NULL,
  id_producto INT NOT NULL,
  id_cliente_beneficiario INT NOT NULL,
  cantidad INT DEFAULT 1,
  precio_unitario DECIMAL(10,2),
  subtotal DECIMAL(10,2),
  CONSTRAINT fk_factura_producto_factura FOREIGN KEY (id_factura)
    REFERENCES facturas(id_factura)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_factura_producto_producto FOREIGN KEY (id_producto)
    REFERENCES productos(id_producto)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_factura_producto_beneficiario FOREIGN KEY (id_cliente_beneficiario)
    REFERENCES clientes(id_cliente)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE INDEX idx_factura_productos_factura ON factura_productos(id_factura);
CREATE INDEX idx_factura_productos_beneficiario ON factura_productos(id_cliente_beneficiario);

-- =========================================================
--  8. Tabla: pagos
-- =========================================================
CREATE TABLE pagos (
  id_pago INT AUTO_INCREMENT PRIMARY KEY,
  id_factura INT NOT NULL,
  fecha_pago DATE,
  importe DECIMAL(10,2),
  metodo_pago VARCHAR(50), -- transferencia, tarjeta, efectivo
  estado VARCHAR(50) DEFAULT 'pendiente', -- pendiente, confirmado, fallido
  CONSTRAINT fk_pago_factura FOREIGN KEY (id_factura)
    REFERENCES facturas(id_factura)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE INDEX idx_pagos_estado ON pagos(estado);
CREATE INDEX idx_pagos_fecha ON pagos(fecha_pago);

-- =========================================================
-- FIN DEL SCRIPT CORREGIDO
-- =========================================================

USE crm_xtart;

-- =========================================================
-- ROLES DE EMPLEADOS
-- =========================================================
INSERT INTO roles_empleado (nombre_rol)
VALUES 
  ('admin'),
  ('comercial'),
  ('gestor'),
  ('direccion');

-- =========================================================
-- EMPLEADOS
-- =========================================================
INSERT INTO empleados (nombre, email, telefono, password, id_rol, fecha_ingreso, estado)
VALUES
  ('Laura Martínez', 'laura.martinez@xtart.es', '600123456', 'com123', 2, '2021-09-01', 'activo'),
  ('Carlos Gómez', 'carlos.gomez@xtart.es', '600234567', 'com123', 2, '2022-01-10', 'activo'),
  ('María López', 'maria.lopez@xtart.es', '600345678', 'gestor123', 3, '2020-06-15', 'activo'),
  ('Javier Ruiz', 'javier.ruiz@xtart.es', '600456789', 'admin123', 1, '2019-03-20', 'activo'),
  ('Ana Torres', 'ana.torres@xtart.es', '600567890', 'dir123', 4, '2020-11-10', 'activo');

-- =========================================================
-- CLIENTES (pagadores y beneficiarios)
-- =========================================================
INSERT INTO clientes (nombre, email, telefono, tipo_cliente, password, fecha_alta, id_empleado_responsable)
VALUES
  ('Juan Pérez', 'juan.perez@gmail.com', '611111111', 'persona', 'cliente123', '2023-09-01', 1),
  ('María Sánchez', 'maria.sanchez@gmail.com', '622222222', 'persona', 'cliente123', '2023-10-10', 2),
  ('Pedro Romero', 'pedro.romero@gmail.com', '633333333', 'persona', 'cliente123', '2023-08-20', 1),
  ('Lucía Fernández', 'lucia.fernandez@gmail.com', '644444444', 'persona', 'cliente123', '2023-07-05', 2),
  ('Academia TechPro', 'contacto@techpro.com', '955000111', 'empresa', 'cliente123', '2023-04-01', 1),
  ('Colegio Innovar', 'info@innovar.edu', '955000222', 'empresa', 'cliente123', '2023-05-01', 2),
  ('José Ramírez', 'jose.ramirez@gmail.com', '655555555', 'persona', 'cliente123', '2024-01-12', 2),
  ('Claudia Núñez', 'claudia.nunez@gmail.com', '666666666', 'persona', 'cliente123', '2024-02-05', 1),
  ('Esteban Mora', 'esteban.mora@gmail.com', '677777777', 'persona', 'cliente123', '2024-03-10', 2),
  ('Empresa FormarPlus', 'info@formarplus.com', '688888888', 'empresa', 'cliente123', '2023-09-20', 1);

-- =========================================================
-- PRODUCTOS (cursos y formaciones)
-- =========================================================
INSERT INTO productos (nombre, descripcion, categoria, precio, activo)
VALUES
  ('Ciclo Formativo DAM', 'Desarrollo de Aplicaciones Multiplataforma', 'ciclo_formativo', 3200.00, TRUE),
  ('Ciclo Formativo DAW', 'Desarrollo de Aplicaciones Web', 'ciclo_formativo', 3100.00, TRUE),
  ('Curso Python Avanzado', 'Formación complementaria en Python', 'formacion_complementaria', 350.00, TRUE),
  ('Curso Ciberseguridad', 'Técnicas y buenas prácticas de seguridad informática', 'formacion_complementaria', 400.00, TRUE),
  ('Curso Diseño UX/UI', 'Diseño centrado en el usuario para aplicaciones', 'formacion_complementaria', 300.00, TRUE),
  ('Ciclo Formativo Marketing Digital', 'Formación avanzada en marketing digital', 'ciclo_formativo', 2800.00, TRUE),
  ('Curso Inglés Técnico', 'Mejora del inglés profesional', 'formacion_complementaria', 250.00, TRUE);

-- =========================================================
-- PRESUPUESTOS
-- =========================================================
INSERT INTO presupuestos (id_empleado, id_cliente_pagador, id_cliente_beneficiario, id_producto, presupuesto, estado, fecha_apertura, fecha_cierre)
VALUES
  (1, 1, 1, 1, 3200.00, 'cerrado', '2023-09-10', '2023-09-20'),
  (2, 2, 2, 2, 3100.00, 'aceptado', '2023-10-15', NULL),
  (1, 5, 3, 1, 3200.00, 'cerrado', '2023-08-01', '2023-08-15'),
  (2, 6, 4, 6, 2800.00, 'cerrado', '2023-06-01', '2023-06-20'),
  (1, 1, 1, 3, 350.00, 'cerrado', '2023-11-01', '2023-11-05'),
  (2, 2, 2, 4, 400.00, 'cerrado', '2023-12-01', '2023-12-05'),
  (1, 5, 7, 1, 3200.00, 'nuevo', '2024-01-15', NULL),
  (2, 10, 8, 6, 2800.00, 'en_proceso', '2024-02-01', NULL),
  (1, 10, 9, 5, 300.00, 'aceptado', '2024-03-01', NULL);

-- =========================================================
-- FACTURAS
-- =========================================================
INSERT INTO facturas (num_factura, id_cliente_pagador, id_empleado, fecha_emision, total, estado, notas)
VALUES
  ('F-2023-001', 1, 1, '2023-09-21', 3550.00, 'pagada', 'Incluye DAM + curso Python'),
  ('F-2023-002', 5, 1, '2023-08-16', 3200.00, 'emitida', 'Formación de Pedro Romero'),
  ('F-2023-003', 6, 2, '2023-06-22', 2800.00, 'pagada', 'Formación de Lucía Fernández'),
  ('F-2023-004', 2, 2, '2023-12-06', 3500.00, 'pagada', 'DAW + Ciberseguridad'),
  ('F-2024-001', 10, 1, '2024-03-10', 3100.00, 'emitida', 'Marketing Digital + UX/UI');

-- =========================================================
-- FACTURA_PRODUCTOS
-- =========================================================
INSERT INTO factura_productos (id_factura, id_producto, id_cliente_beneficiario, cantidad, precio_unitario, subtotal)
VALUES
  (1, 1, 1, 1, 3200.00, 3200.00),
  (1, 3, 1, 1, 350.00, 350.00),
  (2, 1, 3, 1, 3200.00, 3200.00),
  (3, 6, 4, 1, 2800.00, 2800.00),
  (4, 2, 2, 1, 3100.00, 3100.00),
  (4, 4, 2, 1, 400.00, 400.00),
  (5, 6, 8, 1, 2800.00, 2800.00),
  (5, 5, 9, 1, 300.00, 300.00);

-- =========================================================
-- PAGOS
-- =========================================================
INSERT INTO pagos (id_factura, fecha_pago, importe, metodo_pago, estado)
VALUES
  (1, '2023-09-22', 3550.00, 'transferencia', 'confirmado'),
  (2, '2023-08-20', 3200.00, 'tarjeta', 'confirmado'),
  (3, '2023-06-25', 2800.00, 'transferencia', 'confirmado'),
  (4, '2023-12-10', 2000.00, 'efectivo', 'confirmado'),
  (4, '2023-12-15', 1500.00, 'transferencia', 'confirmado'),
  (5, '2024-03-20', 1500.00, 'tarjeta', 'pendiente');

-- =========================================================
-- FIN DE LOS INSERTS DE PRUEBA
-- =========================================================
