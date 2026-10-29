# Auditoría de Inventario y Ventas — MiniStore

Este proyecto contiene el análisis técnico de datos y la auditoría de integridad para la tienda minorista **MiniStore**, utilizando diferentes tipos de Uniones Externas (*Outer JOINs*) en SQL.

## Respuestas a las Preguntas de Negocio

### 1. ¿Por qué usaste LEFT JOIN para la Consulta 1 y no INNER JOIN? ¿Qué se perdería si usaras INNER JOIN?
Se utilizó **LEFT JOIN** ubicando la tabla `productos` a la izquierda (`FROM productos p LEFT JOIN ventas v`) para conservar la totalidad de los registros del catálogo, independientemente de si tienen o no transacciones asociadas en la tabla `ventas`[cite: 1]. 

Si hubiésemos usado un `INNER JOIN`, el motor de base de datos solo devolvería las filas donde existe coincidencia exacta de `producto_id` en ambas tablas, descartando automáticamente los productos sin movimiento[cite: 1]. En este caso concreto, se habrían perdido los productos **108 (Hub USB-C 7p)** y **109 (Parlante Bluetooth)**, impidiendo que el equipo de operaciones detecte el inventario inactivo o sin rotación[cite: 1].

### 2. ¿Por qué usaste RIGHT JOIN para la Consulta 2? ¿Qué tabla está a la izquierda y cuál a la derecha en tu consulta?
Se utilizó **RIGHT JOIN** porque la pregunta de negocio exigía auditar la tabla de transacciones (`ventas`) para detectar posibles errores de carga o registros huérfanos. 

En la consulta escrita:
* **Tabla a la izquierda:** `productos` (declarada en la cláusula `FROM`).
* **Tabla a la derecha:** `ventas` (declarada tras la cláusula `RIGHT JOIN`).

Al hacer un `RIGHT JOIN`, la consulta garantiza preservar el 100% de las filas de la tabla de la derecha (`ventas`), rellenando con valores `NULL` los campos descriptivos del catálogo cuando una venta contenga un identificador de producto que no exista en `productos`[cite: 1].

### 3. ¿Qué representan los valores NULL en cada resultado?
Los valores `NULL` no representan errores del sistema de base de datos, sino ausencia implícita de relación entre las tablas[cite: 1, 4]:

* **En la Consulta 1 (`venta_id IS NULL`):** Representa que el producto del catálogo está correctamente cargado pero **nunca ha sido registrado en una transacción de venta**[cite: 1, 4]. Por ejemplo, para el producto `producto_id = 108` (`Hub USB-C 7p`), la columna `venta_id` devuelve `NULL`, indicando que no hay registros coincidentes en la tabla `ventas`[cite: 1, 4].
* **En la Consulta 2 (`producto_id IS NULL`):** Representa una **anomalía de integridad referencial** o un registro huérfano. Para la `venta_id = 10`, se registró una transacción con `producto_id = 999`; como ese ID no existe en la tabla `productos`, la consulta rellena el nombre y la categoría del producto con `NULL`, alertando sobre un error en la carga de datos del punto de venta.

### 4. ¿Cuándo usarías FULL OUTER JOIN en un caso real de negocio?
Un `FULL OUTER JOIN` se utiliza en escenarios de **auditoría integral y conciliación de datos entre dos sistemas independientes**[cite: 1]. Se aplica cuando se necesita una vista consolidada sin perder filas de ningún lado, identificando simultáneamente las discordancias de ambas tablas[cite: 1].

**Ejemplo real:** Al realizar un proceso de migración o conciliación contable/de stock a fin de mes entre el sistema de facturación y el sistema de depósito ERP. Un `FULL OUTER JOIN` permite ver en un solo reporte qué productos están en depósito pero no se facturaron (`ventas.id IS NULL`), qué facturas se emitieron sin descuento de stock registrado (`inventario.id IS NULL`), y cuáles concuerdan perfectamente.
