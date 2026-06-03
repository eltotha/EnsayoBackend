drop database if exists	control_ventas_db;
CREATE DATABASE IF NOT EXISTS control_ventas_db;
USE control_ventas_db;

-- =========================================================================
-- MÓDULO 1: SEGURIDAD Y ACCESOS
-- =========================================================================

CREATE TABLE roles (
    id_rol INT AUTO_INCREMENT,
    nombre_rol VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150),
    estado TINYINT(1) DEFAULT 1 NOT NULL, -- 1: Activo, 0: Inactivo
    CONSTRAINT pk_roles PRIMARY KEY (id_rol),
    CONSTRAINT uq_nombre_rol UNIQUE (nombre_rol)
);

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT,
    id_rol INT NOT NULL,
    username VARCHAR(50) NOT NULL,
    password_hash VARCHAR(255) NOT NULL, -- Almacenará el hash cifrado de la contraseña
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    estado TINYINT(1) DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_usuarios PRIMARY KEY (id_usuario),
    CONSTRAINT uq_username UNIQUE (username),
    CONSTRAINT uq_email_usuario UNIQUE (email),
    CONSTRAINT fk_usuarios_roles FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
);

CREATE TABLE permisos (
    id_permiso INT AUTO_INCREMENT,
    nombre_permiso VARCHAR(100) NOT NULL,
    codigo_permiso VARCHAR(50) NOT NULL, -- Ej: 'VENTAS_CREAR', 'REPORTES_VER'
    CONSTRAINT pk_permisos PRIMARY KEY (id_permiso),
    CONSTRAINT uq_codigo_permiso UNIQUE (codigo_permiso)
);

CREATE TABLE roles_permisos (
    id_rol INT NOT NULL,
    id_permiso INT NOT NULL,
    CONSTRAINT pk_roles_permisos PRIMARY KEY (id_rol, id_permiso),
    CONSTRAINT fk_rp_roles FOREIGN KEY (id_rol) REFERENCES roles(id_rol) ON DELETE CASCADE,
    CONSTRAINT fk_rp_permisos FOREIGN KEY (id_permiso) REFERENCES permisos(id_permiso) ON DELETE CASCADE
);

-- =========================================================================
-- MÓDULO 2: CATÁLOGOS DE PRODUCTOS
-- =========================================================================

CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT,
    nombre_categoria VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    estado TINYINT(1) DEFAULT 1 NOT NULL,
    CONSTRAINT pk_categorias PRIMARY KEY (id_categoria),
    CONSTRAINT uq_nombre_cat UNIQUE (nombre_categoria)
);

CREATE TABLE marcas (
    id_marca INT AUTO_INCREMENT,
    nombre_marca VARCHAR(100) NOT NULL,
    estado TINYINT(1) DEFAULT 1 NOT NULL,
    CONSTRAINT pk_marcas PRIMARY KEY (id_marca),
    CONSTRAINT uq_nombre_marca UNIQUE (nombre_marca)
);

CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT,
    id_categoria INT NOT NULL,
    id_marca INT NOT NULL,
    codigo_barras VARCHAR(50) NOT NULL,
    nombre_producto VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio_compra DECIMAL(12,2) NOT NULL,
    precio_venta DECIMAL(12,2) NOT NULL,
    stock_actual INT DEFAULT 0 NOT NULL,
    stock_minimo INT DEFAULT 5 NOT NULL,
    estado TINYINT(1) DEFAULT 1 NOT NULL,
    CONSTRAINT pk_productos PRIMARY KEY (id_producto),
    CONSTRAINT uq_codigo_barras UNIQUE (codigo_barras),
    CONSTRAINT fk_productos_categorias FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),
    CONSTRAINT fk_productos_marcas FOREIGN KEY (id_marca) REFERENCES marcas(id_marca)
);

CREATE TABLE imagenes_producto (
    id_imagen INT AUTO_INCREMENT,
    id_producto INT NOT NULL,
    ruta_url VARCHAR(255) NOT NULL,
    es_principal TINYINT(1) DEFAULT 0 NOT NULL,
    CONSTRAINT pk_imagenes_producto PRIMARY KEY (id_imagen),
    CONSTRAINT fk_imagenes_productos FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE
);

-- =========================================================================
-- MÓDULO 3: ENTIDADES DE NEGOCIO
-- =========================================================================

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT,
    num_documento VARCHAR(20) NOT NULL, -- Cédula, RUC, etc.
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(255),
    email VARCHAR(100),
    CONSTRAINT pk_clientes PRIMARY KEY (id_cliente),
    CONSTRAINT uq_doc_cliente UNIQUE (num_documento)
);

CREATE TABLE proveedores (
    id_proveedor INT AUTO_INCREMENT,
    ruc VARCHAR(20) NOT NULL,
    razon_social VARCHAR(150) NOT NULL,
    nombre_contacto VARCHAR(100),
    telefono VARCHAR(20),
    direccion VARCHAR(255),
    email VARCHAR(100),
    estado TINYINT(1) DEFAULT 1 NOT NULL,
    CONSTRAINT pk_proveedores PRIMARY KEY (id_proveedor),
    CONSTRAINT uq_ruc_proveedor UNIQUE (ruc)
);

-- =========================================================================
-- MÓDULO 4: COMPRAS E INVENTARIO
-- =========================================================================

CREATE TABLE compras (
    id_compra INT AUTO_INCREMENT,
    id_proveedor INT NOT NULL,
    id_usuario INT NOT NULL, -- Usuario que registra la compra
    num_comprobante VARCHAR(50) NOT NULL,
    fecha_compra DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    total DECIMAL(12,2) NOT NULL,
    CONSTRAINT pk_compras PRIMARY KEY (id_compra),
    CONSTRAINT fk_compras_proveedores FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor),
    CONSTRAINT fk_compras_usuarios FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

CREATE TABLE detalle_compras (
    id_detalle_compra INT AUTO_INCREMENT,
    id_compra INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(12,2) NOT NULL,
    CONSTRAINT pk_detalle_compras PRIMARY KEY (id_detalle_compra),
    CONSTRAINT fk_dc_compras FOREIGN KEY (id_compra) REFERENCES compras(id_compra) ON DELETE CASCADE,
    CONSTRAINT fk_dc_productos FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

CREATE TABLE kardex_inventario (
    id_kardex INT AUTO_INCREMENT,
    id_producto INT NOT NULL,
    tipo_movimiento ENUM('ENTRADA', 'SALIDA') NOT NULL,
    origen VARCHAR(50) NOT NULL, -- 'COMPRA', 'VENTA', 'DEVOLUCION', 'AJUSTE'
    id_referencia INT NOT NULL, -- ID de la compra o venta que generó el movimiento
    cantidad INT NOT NULL,
    stock_anterior INT NOT NULL,
    stock_posterior INT NOT NULL,
    fecha_movimiento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_kardex PRIMARY KEY (id_kardex),
    CONSTRAINT fk_kardex_productos FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- =========================================================================
-- MÓDULO 5: VENTAS Y CAJA
-- =========================================================================

CREATE TABLE cajas (
    id_caja INT AUTO_INCREMENT,
    nombre_caja VARCHAR(50) NOT NULL,
    estado VARCHAR(20) DEFAULT 'CERRADA' NOT NULL, -- 'ABIERTA', 'CERRADA'
    CONSTRAINT pk_cajas PRIMARY KEY (id_caja)
);

CREATE TABLE turnos_caja (
    id_turno INT AUTO_INCREMENT,
    id_caja INT NOT NULL,
    id_usuario INT NOT NULL, -- Cajero asignado
    fecha_apertura DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_cierre DATETIME,
    monto_apertura DECIMAL(10,2) NOT NULL,
    monto_cierre DECIMAL(10,2),
    estado TINYINT(1) DEFAULT 1 NOT NULL, -- 1: Abierto, 0: Cerrado
    CONSTRAINT pk_turnos PRIMARY KEY (id_turno),
    CONSTRAINT fk_turnos_cajas FOREIGN KEY (id_caja) REFERENCES cajas(id_caja),
    CONSTRAINT fk_turnos_usuarios FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

CREATE TABLE ventas (
    id_venta INT AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_usuario INT NOT NULL, -- Vendedor/Cajero
    id_turno INT NOT NULL, -- Turno de caja donde se procesó
    num_factura VARCHAR(50) NOT NULL,
    fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL,
    impuesto DECIMAL(12,2) NOT NULL, -- Ej: IVA
    descuento DECIMAL(12,2) DEFAULT 0.00 NOT NULL,
    total DECIMAL(12,2) NOT NULL,
    estado VARCHAR(20) DEFAULT 'PAGADA' NOT NULL, -- 'PAGADA', 'ANULADA'
    CONSTRAINT pk_ventas PRIMARY KEY (id_venta),
    CONSTRAINT uq_num_factura UNIQUE (num_factura),
    CONSTRAINT fk_ventas_clientes FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT fk_ventas_usuarios FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_ventas_turnos FOREIGN KEY (id_turno) REFERENCES turnos_caja(id_turno)
);

CREATE TABLE detalle_ventas (
    id_detalle_venta INT AUTO_INCREMENT,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(12,2) NOT NULL,
    descuento_aplicado DECIMAL(12,2) DEFAULT 0.00 NOT NULL,
    CONSTRAINT pk_detalle_ventas PRIMARY KEY (id_detalle_venta),
    CONSTRAINT fk_dv_ventas FOREIGN KEY (id_venta) REFERENCES ventas(id_venta) ON DELETE CASCADE,
    CONSTRAINT fk_dv_productos FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

CREATE TABLE metodos_pago (
    id_metodo INT AUTO_INCREMENT,
    nombre_metodo VARCHAR(50) NOT NULL, -- 'EFECTIVO', 'TARJETA', 'TRANSFERENCIA'
    estado TINYINT(1) DEFAULT 1 NOT NULL,
    CONSTRAINT pk_metodos PRIMARY KEY (id_metodo),
    CONSTRAINT uq_nombre_metodo UNIQUE (nombre_metodo)
);

CREATE TABLE pagos_venta (
    id_pago INT AUTO_INCREMENT,
    id_venta INT NOT NULL,
    id_metodo INT NOT NULL,
    monto_pagado DECIMAL(12,2) NOT NULL,
    detalles_transaccion VARCHAR(255), -- Número de voucher si es tarjeta
    CONSTRAINT pk_pagos PRIMARY KEY (id_pago),
    CONSTRAINT fk_pagos_ventas FOREIGN KEY (id_venta) REFERENCES ventas(id_venta) ON DELETE CASCADE,
    CONSTRAINT fk_pagos_metodos FOREIGN KEY (id_metodo) REFERENCES metodos_pago(id_metodo)
);

CREATE TABLE devoluciones (
    id_devolucion INT AUTO_INCREMENT,
    id_venta INT NOT NULL,
    id_usuario INT NOT NULL,
    fecha_devolucion DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    motivo TEXT NOT NULL,
    monto_devuelto DECIMAL(12,2) NOT NULL,
    CONSTRAINT pk_devoluciones PRIMARY KEY (id_devolucion),
    CONSTRAINT fk_devoluciones_ventas FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
    CONSTRAINT fk_devoluciones_usuarios FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

