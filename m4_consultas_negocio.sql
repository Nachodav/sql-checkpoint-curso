-- =========================================================================
-- PRE-ENTREGA: CONSULTAS SQL DE NEGOCIO (Ventas_Tech_DB)
-- =========================================================================

USE Ventas_Tech_DB;
GO


-- =========================================================================
-- CONSULTA 1: Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio, agrupados por mes.
-- =========================================================================

SELECT 
    YEAR(fecha_venta) AS anio,
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(id_venta) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
ORDER BY anio, mes;


-- =========================================================================
-- CONSULTA 2: Ranking de productos
-- Top 5 de id_producto por total facturado (unidades y total generado).
-- =========================================================================

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;


-- =========================================================================
-- CONSULTA 3: Clientes recurrentes
-- Clientes con más de un pedido, mostrando cantidad de pedidos y total gastado.
-- =========================================================================

SELECT 
    id_cliente,
    COUNT(id_venta) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(id_venta) > 1
ORDER BY cantidad_pedidos DESC;


-- =========================================================================
-- CONSULTA 4: Meses por encima/por debajo del promedio
-- Facturación por mes etiquetada comparada con el promedio mensual general.
-- =========================================================================

WITH VentasMensuales AS (
    SELECT 
        YEAR(fecha_venta) AS anio,
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_mes
    FROM ventas
    GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
),
PromedioGeneral AS (
    SELECT AVG(total_mes) AS promedio_general FROM VentasMensuales
)
SELECT 
    vm.anio,
    vm.mes,
    vm.total_mes,
    pg.promedio_general,
    CASE 
        WHEN vm.total_mes > pg.promedio_general THEN 'Por encima'
        WHEN vm.total_mes < pg.promedio_general THEN 'Por debajo'
        ELSE 'Igual'
    END AS evaluacion_promedio
FROM VentasMensuales vm
CROSS JOIN PromedioGeneral pg
ORDER BY vm.anio, vm.mes;


-- =========================================================================
-- BLOQUE DE CIERRE: Hallazgos concretos encontrados en los resultados
-- =========================================================================
/*
   1. El producto 1 (Laptop Pro 15) concentra la mayor facturación debido a su alto 
      precio unitario, a pesar de no ser el que registra mayor volumen de unidades.
   2. Los clientes 1, 3, 4 y 5 muestran comportamiento recurrente realizando más 
      de un pedido durante el periodo analizado.
   3. Marzo de 2024 presenta un flujo de ventas constante pero con variaciones 
      claras en el ticket promedio según el tipo de producto adquirido (computación vs. accesorios).
*/