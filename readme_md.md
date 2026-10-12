# RetailPro — Análisis de Ventas (SQL Checkpoint)

Bienvenido al repositorio **sql-checkpoint-curso**. Este proyecto contiene la solución y documentación de las entregas de análisis de datos con SQL para el proyecto **RetailPro**, trabajando sobre la base de datos `Ventas_Tech_DB`.

* **Repositorio:** [Nachodav/sql-checkpoint-curso](https://github.com/Nachodav/sql-checkpoint-curso)

---

## 💡 Preguntas de Negocio que Resuelve este Proyecto

> **Justificación del cambio 1 (Enfoque Comercial):** Se añade esta sección al inicio para demostrar que el proyecto no es solo un ejercicio técnico de código, sino una solución práctica a problemas reales que enfrenta el equipo de ventas e inventario.

* **¿Cuáles son los productos estrella?** Identifica el Top 5 de productos que generan mayores ingresos para priorizar stock y campañas.
* **¿Qué clientes o productos están inactivos?** Detecta clientes sin compras para campañas de reactivación y productos estancados en inventario.
* **¿Cómo evoluciona la facturación mensual frente al promedio?** Compara el rendimiento de cada mes contra la meta media del negocio.
* **¿Cuál es el volumen por canal de venta?** Permite analizar y comparar el rendimiento entre el canal *Online* y el *Presencial*.

---

## 📌 Descripción del Proyecto y Modelo de Datos

**RetailPro** es una solución analítica orientada al sector minorista/tecnológico. El objetivo principal es transformar registros transaccionales en bruto en información clara y accionable para la toma de decisiones comerciales y de inventario.

### Diagrama del Modelo Entidad-Relación (ER)

> **Justificación del cambio 2 (Diagrama Visual):** Se agrega la estructura gráfica de la base de datos para que cualquiera que ingrese al repositorio entienda de un vistazo cómo se conectan las tablas antes de leer los scripts.

```
+------------------+         +--------------------+         +--------------------+
|     CLIENTES     |         |       VENTAS       |         |     PRODUCTOS      |
+------------------+         +--------------------+         +--------------------+
| id_cliente (PK)  | <-----> | id_venta (PK)      | <-----> | id_producto (PK)   |
| nombre           |         | fecha_venta        |         | nombre_producto    |
| email            |         | id_cliente (FK)    |         | precio             |
| ciudad           |         | id_producto (FK)   |         | id_categoria (FK)  |
| fecha_registro   |         | cantidad           |         +---------+----------+
+------------------+         | precio_unitario    |                   |
                             +--------------------+                   v
                                                            +--------------------+
                                                            |     CATEGORIAS     |
                                                            +--------------------+
                                                            | id_categoria (PK)  |
                                                            | nombre_categoria   |
                                                            +--------------------+
```

---

## 🛠️ Herramientas y Tecnologías

* **Base de Datos:** Microsoft SQL Server / Azure Data Studio
* **Lenguaje:** T-SQL (Transact-SQL)
* **Control de Versiones:** Git & GitHub

---

## 📂 Estructura de Scripts e Integración

Los scripts SQL dentro del repositorio abarcan las siguientes consultas clave:

| Consulta | Tipo de Operación | Propósito Comercial |
| :--- | :--- | :--- |
| **Consulta 1** | `INNER JOIN` | Vista general consolidada de ventas por cliente, ubicación y producto. |
| **Consulta 2** | `LEFT JOIN` + `IS NULL` | Identificación de clientes registrados sin historial de compra. |
| **Consulta 3** | `LEFT JOIN` + `IS NULL` | Detección de productos sin rotación/ventas en el período. |
| **Consulta 4 (Optimizada)** | `CASE WHEN` + `GROUP BY` | Segmentación eficiente del facturado por canal (Online vs. Presencial). |
| **Métricas A** | `GROUP BY` / Aggregations | Resumen ejecutivo mensual (facturación total y cantidad de pedidos). |
| **Métricas B** | `TOP 5` + `ORDER BY` | Ranking de productos con mayor facturación (Regla de Pareto). |
| **Métricas C** | `HAVING` | Identificación de clientes recurrentes (fidelización). |
| **Métricas D** | `WITH` (CTEs) + `CROSS JOIN` | Clasificación de meses por encima o por debajo del promedio general. |

---

## ⚡ Optimización Destacada (Consulta 4)

> **Justificación del cambio 3 (Código Limpio y Eficiente):** Reemplazamos la versión anterior que usaba `UNION ALL` y subconsultas por una consulta directa con `CASE WHEN`. Esto simplifica la lectura y optimiza el rendimiento al hacer una sola pasada sobre la tabla `ventas`.

```sql
-- Versión optimizada de consolidado por canal
SELECT 
    CASE 
        WHEN id_cliente IN (1, 2) THEN 'Online'
        ELSE 'Presencial'
    END AS canal,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY 
    CASE 
        WHEN id_cliente IN (1, 2) THEN 'Online'
        ELSE 'Presencial'
    END;
```

---

## 🚀 Cómo Ejecutar los Scripts

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/Nachodav/sql-checkpoint-curso.git
   cd sql-checkpoint-curso
   ```

2. **Cargar la base de datos:**
   * Abre **SQL Server Management Studio (SSMS)** o **Azure Data Studio**.
   * Ejecuta el script de creación e inserción de datos para `Ventas_Tech_DB`.

3. **Ejecutar consultas:**
   * Abre los archivos `.sql` del repositorio y ejecútalos secuencialmente para obtener las métricas de negocio.