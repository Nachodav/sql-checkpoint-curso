-- =========================================================================
-- PRE-ENTREGA M5: CONSULTAS CON JOINS PARA EL PROYECTO
-- =========================================================================

USE Ventas_Tech_DB;
GO


-- =========================================================================
-- CONSULTA 1 — Vista base del proyecto (INNER JOIN)


SELECT 
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad AS region_cliente,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria;
GO


-- =========================================================================
-- CONSULTA 2 — Clientes sin ventas (LEFT JOIN)


SELECT 
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;
GO


-- =========================================================================
-- CONSULTA 3 — Productos sin ventas (LEFT JOIN)


SELECT 
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;
GO


-- =========================================================================
-- CONSULTA 4 — Consolidado por canal (UNION ALL)


SELECT 
    canal, 
    SUM(total) AS total_facturado
FROM (
SELECT 
        fecha_venta AS fecha, 
        (cantidad * precio_unitario) AS total, 
        'Online' AS canal 
    FROM ventas 
    WHERE id_cliente IN (1, 2)
    
    UNION ALL 
    SELECT 
        fecha_venta AS fecha, 
        (cantidad * precio_unitario) AS total, 
        'Presencial' AS canal 
    FROM ventas 
    WHERE id_cliente NOT IN (1, 2)
) AS ventas_consolidadas
GROUP BY canal;
GO