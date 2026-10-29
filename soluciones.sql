-- ══════════════════════════════════════════
-- MiniStore — Soluciones con Outer JOINs
-- Autor: Tomás Melchior
-- Fecha: 28/10/2026
-- ══════════════════════════════════════════

-- ── CONSULTA 1: LEFT JOIN ─────────────────
-- Pregunta de negocio: ¿Qué productos del catálogo nunca fueron vendidos?
-- Mostrá todos los productos y sus ventas asociadas.
-- Los productos sin ventas aparecerán con NULL en las columnas de ventas.

SELECT 
    p.producto_id,
    p.nombre AS producto_nombre,
    p.categoria,
    p.precio,
    v.venta_id,
    v.cantidad,
    v.fecha_venta
FROM productos p
LEFT JOIN ventas v ON p.producto_id = v.producto_id
WHERE v.venta_id IS NULL;


-- ── CONSULTA 2: RIGHT JOIN ────────────────
-- Pregunta de negocio: ¿Existen ventas registradas con productos
-- que no figuran en nuestro catálogo? (posible error de carga de datos)
-- Los registros huérfanos aparecerán con NULL en las columnas de productos.

SELECT 
    v.venta_id,
    v.producto_id AS venta_producto_id,
    v.cliente_id,
    v.cantidad,
    v.fecha_venta,
    p.nombre AS producto_nombre,
    p.categoria
FROM productos p
RIGHT JOIN ventas v ON p.producto_id = v.producto_id
WHERE p.producto_id IS NULL;


-- ── CONSULTA 3: FULL OUTER JOIN ───────────
-- Pregunta de negocio: Vista completa de auditoría que muestre
-- todos los productos y todas las ventas sin perder ninguna fila,
-- identificando tanto productos sin ventas como ventas sin producto.

-- Nota: Si tu motor es PostgreSQL o SQL Server, podés usar FULL OUTER JOIN directamente.
-- Si estás en MySQL, se simula uniendo un LEFT JOIN con un RIGHT JOIN mediante UNION.

-- Opción A: Estándar ANSI SQL (PostgreSQL / SQL Server)
SELECT 
    p.producto_id AS catálogo_producto_id,
    p.nombre AS producto_nombre,
    p.categoria,
    v.venta_id,
    v.producto_id AS venta_producto_id,
    v.cantidad,
    v.fecha_venta
FROM productos p
FULL OUTER JOIN ventas v ON p.producto_id = v.producto_id;

-- Opción B: Compatibilidad para MySQL (descomentar si usás MySQL)
/*
SELECT p.producto_id AS catálogo_producto_id, p.nombre AS producto_nombre, p.categoria, v.venta_id, v.producto_id AS venta_producto_id, v.cantidad, v.fecha_venta
FROM productos p
LEFT JOIN ventas v ON p.producto_id = v.producto_id
UNION
SELECT p.producto_id AS catálogo_producto_id, p.nombre AS producto_nombre, p.categoria, v.venta_id, v.producto_id AS venta_producto_id, v.cantidad, v.fecha_venta
FROM productos p
RIGHT JOIN ventas v ON p.producto_id = v.producto_id;
*/
