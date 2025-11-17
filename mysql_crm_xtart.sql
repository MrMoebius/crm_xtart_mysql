-- CRM XTART - Versión depurada
-- Script MySQL para creación de tablas

CREATE TABLE roles_empleado (
  id_rol INT PRIMARY KEY AUTO_INCREMENT,
  nombre_rol VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE empleados (
  id_empleado INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  telefono VARCHAR(20),
  id_rol INT NOT NULL,
  fecha_ingreso DATE,
  estado VARCHAR(50),
  FOREIGN KEY (id_rol) REFERENCES roles_empleado(id_rol)
);

CREATE TABLE clientes (
  id_cliente INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(150) NOT NULL,
  email VARCHAR(150) UNIQUE,
  telefono VARCHAR(20),
  tipo_cliente VARCHAR(50),
  fecha_alta DATE,
  id_empleado_responsable INT,
  FOREIGN KEY (id_empleado_responsable) REFERENCES empleados(id_empleado)
);

CREATE TABLE productos (
  id_producto INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(150) NOT NULL,
  descripcion TEXT,
  categoria VARCHAR(50),
  precio DECIMAL(10,2),
  activo BOOLEAN
);

CREATE TABLE presupuestos (
  id_presupuesto INT PRIMARY KEY AUTO_INCREMENT,
  id_empleado INT NOT NULL,
  id_cliente_pagador INT NOT NULL,
  id_cliente_beneficiario INT NOT NULL,
  id_producto INT NOT NULL,
  presupuesto DECIMAL(10,2),
  estado VARCHAR(50),
  fecha_apertura DATE,
  fecha_cierre DATE,
  FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado),
  FOREIGN KEY (id_cliente_pagador) REFERENCES clientes(id_cliente),
  FOREIGN KEY (id_cliente_beneficiario) REFERENCES clientes(id_cliente),
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

CREATE TABLE facturas (
  id_factura INT PRIMARY KEY AUTO_INCREMENT,
  num_factura VARCHAR(50) NOT NULL UNIQUE,
  id_cliente_pagador INT NOT NULL,
  id_empleado INT,
  fecha_emision DATE NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  estado VARCHAR(50),
  notas TEXT,
  FOREIGN KEY (id_cliente_pagador) REFERENCES clientes(id_cliente),
  FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

CREATE TABLE factura_productos (
  id_factura_producto INT PRIMARY KEY AUTO_INCREMENT,
  id_factura INT NOT NULL,
  id_producto INT NOT NULL,
  id_cliente_beneficiario INT NOT NULL,
  cantidad INT DEFAULT 1,
  precio_unitario DECIMAL(10,2),
  subtotal DECIMAL(10,2),
  FOREIGN KEY (id_factura) REFERENCES facturas(id_factura),
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
  FOREIGN KEY (id_cliente_beneficiario) REFERENCES clientes(id_cliente)
);

CREATE TABLE pagos (
  id_pago INT PRIMARY KEY AUTO_INCREMENT,
  id_factura INT NOT NULL,
  fecha_pago DATE,
  importe DECIMAL(10,2),
  metodo_pago VARCHAR(50),
  estado VARCHAR(50),
  FOREIGN KEY (id_factura) REFERENCES facturas(id_factura)
);
