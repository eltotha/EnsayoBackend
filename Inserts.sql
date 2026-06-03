USE control_ventas_db;

-- =========================================================================
-- MÓDULO 1: SEGURIDAD Y ACCESOS
-- =========================================================================

INSERT INTO roles (nombre_rol, descripcion, estado) VALUES
('Administrador', 'Acceso total al sistema y reportes maestros', 1),
('Cajero', 'Acceso exclusivo a facturación y turnos de caja', 1),
('Supervisor', 'Validación de anulaciones y control de inventario', 1),
('Gestor Inventario', 'Control de compras, proveedores y kardex', 1),
('Auditor', 'Solo lectura para reportes financieros y auditorías', 1);

INSERT INTO permisos (nombre_permiso, codigo_permiso) VALUES
('Crear Ventas', 'VENTAS_CREAR'),
('Anular Ventas', 'VENTAS_ANULAR'),
('Gestionar Productos', 'PRODUCTOS_GESTIONAR'),
('Registrar Compras', 'COMPRAS_REGISTRAR'),
('Ver Reportes Estadísticos', 'REPORTES_VER');

INSERT INTO roles_permisos (id_rol, id_permiso) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), -- Admin tiene todos
(2, 1),                                 -- Cajero solo crea ventas
(3, 1), (3, 2),                         -- Supervisor crea y anula
(4, 3), (4, 4),                         -- Gestor maneja productos y compras
(5, 5);                                 -- Auditor solo ve reportes

INSERT INTO usuarios (id_rol, username, password_hash, nombres, apellidos, email, estado) VALUES
(1, 'diego_admin', 'admin', 'Diego', 'Mairena', 'admin@sistema.com', 1),
(2, 'cajero_01', 'admin', 'Juanito', 'Pérez', 'juanito@perez.com', 1),
(2, 'cajero_02', 'admin', 'Carlos', 'García', 'carlos@garcia.com', 1),
(3, 'supervisor_01', 'admin', 'Ana', 'Martínez', 'ana@martinez.com', 1),
(4, 'gestor_inv', 'admin', 'Luis', 'Rodríguez', 'luis@inventario.com', 1);

-- =========================================================================
-- MÓDULO 2: CATÁLOGOS DE PRODUCTOS
-- =========================================================================

INSERT INTO categorias (nombre_categoria, descripcion, estado) VALUES
('Repuestos Motor', 'Pistones, bielas, bujías y empaques', 1),
('Lubricantes', 'Aceites de motor 2T, 4T y líquido de frenos', 1),
('Accesorios', 'Cascos, guantes, espejos y lujos', 1),
('Sistema Eléctrico', 'Baterías, estatores, CDI y pidevías', 1),
('Llantas y Neumáticos', 'Llantas pisteras, montañeras y tubulares', 1);

INSERT INTO marcas (nombre_marca, estado) VALUES
('Honda', 1),
('Suzuki', 1),
('Castrol', 1),
('Yamaha', 1),
('Michelin', 1);

INSERT INTO productos (id_categoria, id_marca, codigo_barras, nombre_producto, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, estado) VALUES
(2, 3, '7411234567890', 'Aceite Castrol Actevo 20W-50 4T', 'Protección continua para motocicletas', 180.00, 240.00, 50, 10, 1),
(5, 5, '7411234567891', 'Llanta Michelin 130/70-17 Pilot Street', 'Excelente agarre en seco y mojado', 1200.00, 1650.00, 12, 3, 1),
(1, 1, '7411234567892', 'Bujía Honda Original CPR7EA-9', 'Bujía de encendido genuina', 95.00, 140.00, 100, 15, 1),
(4, 2, '7411234567893', 'Batería Suzuki AX100 12V', 'Batería de gel sellada libre de mantenimiento', 450.00, 620.00, 20, 5, 1),
(3, 4, '7411234567894', 'Casco Certificado Yamaha Racing', 'Casco integral con certificación DOT', 1500.00, 2100.00, 8, 2, 1);

INSERT INTO imagenes_producto (id_producto, ruta_url, es_principal) VALUES
(1, '/uploads/productos/castrol_actevo_principal.png', 1),
(1, '/uploads/productos/castrol_actevo_back.png', 0),
(2, '/uploads/productos/michelin_pilot.png', 1),
(3, '/uploads/productos/bujia_cpr7ea.png', 1),
(5, '/uploads/productos/casco_yamaha.png', 1);

-- =========================================================================
-- MÓDULO 3: ENTIDADES DE NEGOCIO
-- =========================================================================

INSERT INTO clientes (num_documento, nombres, apellidos, telefono, direccion, email) VALUES
('281-150895-0002A', 'Juan', 'López Sánchez', '8888-1111', 'De la UNAN León 2c al norte', 'juan.lopez@gmail.com'),
('001-020399-0044B', 'María', 'Espinoza Gómez', '7777-2222', 'Barrio El Laborío', 'maria.gomez@hotmail.com'),
('281-301190-0005C', 'Josías', 'Blanco Rostrán', '8666-3333', 'Reparto San Juan', 'josias.blanco@outlook.com'),
('Consumidor Final', 'Clientes', 'Varios', '0000-0000', 'León', 'ventas@sistema.com'),
('281-050501-0001X', 'Kevin', 'Rizo Pastrán', '5555-4444', 'Sutiaba, frente a la iglesia', 'kevin.rizo@gmail.com');

INSERT INTO proveedores (ruc, razon_social, nombre_contacto, telefono, direccion, email, estado) VALUES
('J0310000123456', 'Repuestos Atlántico S.A.', 'Manuel Gutiérrez', '2244-1111', 'Managua, Pista Juan Pablo II', 'ventas@repuestosatlantico.com', 1),
('J0310000789101', 'Distribuidora La Genuina', 'Sofía Castillo', '2255-2222', 'Masaya, Entrada Principal 1c al oeste', 'scastillo@lagenuina.com', 1),
('J0310000456123', 'Castrol de Nicaragua', 'Roberto Blandón', '2266-3333', 'Managua, Carretera Norte Km 4.5', 'rblandon@castrol.com.ni', 1),
('J0310000999888', 'Llantas Universales S.A.', 'Elena Rostrán', '2311-4444', 'León, Salida a Managua', 'erostran@llantasuniversales.com', 1),
('J0310000111222', 'MotoPartes Express Nicaragua', 'Carlos Zelaya', '2288-5555', 'Estelí, Frente a la Cotran', 'czelaya@motopartes.com', 1);

-- =========================================================================
-- MÓDULO 4: COMPRAS E INVENTARIO
-- =========================================================================

INSERT INTO compras (id_proveedor, id_usuario, num_comprobante, total) VALUES
(3, 5, 'FAC-00123', 9000.00),  -- Compra de Aceites
(4, 5, 'FAC-00985', 14400.00), -- Compra de Llantas
(2, 5, 'FAC-05521', 9500.00),  -- Compra de Bujías
(5, 5, 'FAC-00147', 9000.00),  -- Compra de Baterías
(1, 5, 'FAC-00369', 12000.00); -- Compra de Cascos

INSERT INTO detalle_compras (id_compra, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 50, 180.00),  -- 50 aceites a 180 c/u
(2, 2, 12, 1200.00), -- 12 llantas a 1200 c/u
(3, 3, 100, 95.00),  -- 100 bujías a 95 c/u
(4, 4, 20, 450.00),  -- 20 baterías a 450 c/u
(5, 5, 8, 1500.00);  -- 8 cascos a 1500 c/u

INSERT INTO kardex_inventario (id_producto, tipo_movimiento, origen, id_referencia, cantidad, stock_anterior, stock_posterior) VALUES
(1, 'ENTRADA', 'COMPRA', 1, 50, 0, 50),
(2, 'ENTRADA', 'COMPRA', 2, 12, 0, 12),
(3, 'ENTRADA', 'COMPRA', 3, 100, 0, 100),
(4, 'ENTRADA', 'COMPRA', 4, 20, 0, 20),
(5, 'ENTRADA', 'COMPRA', 5, 8, 0, 8);

-- =========================================================================
-- MÓDULO 5: VENTAS Y CAJA
-- =========================================================================

INSERT INTO cajas (nombre_caja, estado) VALUES
('Caja Principal 01', 'ABIERTA'),
('Caja Rápida 02', 'CERRADA'),
('Caja Taller Norte', 'CERRADA'),
('Caja Sucursal Sutiaba', 'CERRADA'),
('Caja Eventos / Móvil', 'CERRADA');

INSERT INTO turnos_caja (id_caja, id_usuario, monto_apertura, monto_cierre, estado) VALUES
(1, 2, 1000.00, NULL, 1),    -- Turno abierto por Juanito en Caja 1
(1, 3, 1000.00, 4500.00, 0), -- Turno cerrado por Carlos
(2, 2, 500.00, 1200.00, 0),  -- Turno cerrado viejo
(3, 3, 1500.00, 3200.00, 0), -- Turno cerrado viejo
(4, 2, 1000.00, 5800.00, 0); -- Turno cerrado viejo

INSERT INTO ventas (id_cliente, id_usuario, id_turno, num_factura, subtotal, impuesto, descuento, total, estado) VALUES
(1, 2, 1, 'FAC-2026-0001', 480.00, 72.00, 0.00, 552.00, 'PAGADA'),      -- Venta de 2 Aceites
(3, 2, 1, 'FAC-2026-0002', 1650.00, 247.50, 50.00, 1847.50, 'PAGADA'),  -- Venta de 1 Llanta con desc
(2, 2, 1, 'FAC-2026-0003', 280.00, 42.00, 0.00, 322.00, 'PAGADA'),      -- Venta de 2 Bujías
(5, 2, 1, 'FAC-2026-0004', 1240.00, 186.00, 0.00, 1426.00, 'PAGADA'),    -- Venta de 2 Baterías
(4, 2, 1, 'FAC-2026-0005', 2100.00, 315.00, 100.00, 2315.00, 'ANULADA'); -- Venta de Casco (Anulada)

INSERT INTO detalle_ventas 
(id_venta, id_producto, cantidad, precio_unitario, descuento_aplicado) 
VALUES
(1, 1, 2, 240.00, 0.00),         -- 2 aceites
(2, 2, 1, 1650.00, 50.00),       -- 1 llanta con descuento
(3, 3, 2, 140.00, 0.00),         -- 2 bujías
(4, 4, 2, 620.00, 0.00),         -- 2 baterías
(5, 5, 1, 2100.00, 100.00);      -- 1 casco

INSERT INTO metodos_pago (nombre_metodo, estado) VALUES
('EFECTIVO', 1),
('TARJETA CREDITO/DEBITO', 1),
('TRANSFERENCIA BANPRO', 1),
('TRANSFERENCIA LAFISE', 1),
('BILLETERA DIGITAL (PAGO SMART)', 1);

INSERT INTO pagos_venta (id_venta, id_metodo, monto_pagado, detalles_transaccion) VALUES
(1, 1, 552.00, 'Pago exacto en efectivo'),
(2, 2, 1847.50, 'Voucher BAC #456123'),
(3, 1, 400.00, 'Efectivo - Cambio C$ 78.00'),
(4, 3, 1426.00, 'Transferencia Banpro Ref #99825'),
(5, 1, 2315.00, 'Efectivo antes de la anulación');

INSERT INTO devoluciones (id_venta, id_usuario, motivo, monto_devuelto) VALUES
(5, 4, 'Cliente solicitó cambio de talla de casco pero no había stock disponible', 2315.00),
(3, 4, 'Bujía salió defectuosa de fábrica (Cambio inmediato)', 140.00),
(1, 4, 'Cliente se arrepintió de llevar el segundo envase de aceite', 276.00),
(2, 4, 'Ajuste de precio cobrado de más por error del sistema', 50.00),
(4, 4, 'Garantía aplicada por batería que no retenía carga', 1426.00);