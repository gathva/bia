# Plan de Desarrollo: App de Control de Bodega (BIA)

## 1. Visión General

Crear una aplicación móvil sencilla para Android con Flutter que facilite el control de inventario de una bodega. La app asistirá al usuario mediante un chat con un modelo de IA para realizar consultas sobre los productos. El objetivo es tener un prototipo funcional y de bajo costo para noviembre de 2025.

## 2. Pila Tecnológica

- **Frontend:** Flutter (para Android inicialmente).
- **Backend:** Firebase (Firestore como base de datos).
- **Inteligencia Artificial:** Un modelo de lenguaje gratuito accedido vía OpenRouter.
- **Hardware:** Lector de código de barras a través de una librería de Flutter.
- **Diseño:** El usuario proveerá diseños de Figma, de los cuales se extraerá la estructura y los recursos.

## 3. Estructura de la Aplicación

La navegación principal se compondrá de tres secciones:

1.  **Dashboard (Inicio):**
    -   Resumen de actividad: últimos productos registrados, últimos movimientos.
    -   Estadísticas clave (ej: productos con bajo stock).
2.  **Scan (Acción Principal):**
    -   Botón central para activar la cámara y escanear códigos de barras.
    -   Permitirá registrar un nuevo producto o consultar la información de uno existente.
3.  **Chat (Asistente IA):**
    -   Interfaz de chat para interactuar con la IA.
    -   El usuario podrá realizar preguntas en lenguaje natural (ej: "buscar producto X", "dame un reporte de las entradas de hoy").

## 4. Estrategia de IA

-   Se utilizará un enfoque de **Function Calling (Uso de Herramientas)**.
-   El flujo será: Usuario pregunta -> La app envía la pregunta a la IA -> La IA determina qué acción realizar y responde con un JSON (ej: `{ "tool": "buscar_producto", "params": { "nombre": "tornillos" } }`) -> La app ejecuta una función interna basada en ese JSON para consultar Firestore.
-   Esto evita que la IA interactúe directamente con la base de datos, aumentando la seguridad y fiabilidad.

## 5. Modelo de Datos (Firestore)

-   **Colección `productos`:**
    -   `nombre` (String)
    -   `codigo_barras` (String)
    -   `descripcion` (String)
    -   `stock_actual` (Number)
    -   `ubicacion` (String)
    -   `fecha_creacion` (Timestamp)
    -   `ultima_actualizacion` (Timestamp)
-   **Colección `movimientos`:**
    -   `producto_id` (Referencia a `productos`)
    -   `tipo` (String: "entrada" | "salida")
    -   `cantidad` (Number)
    -   `fecha` (Timestamp)
    -   `responsable` (String, opcional)

## 6. Manejo de Secretos

-   Todas las claves de API (Firebase, OpenRouter) se gestionarán a través de un archivo `.env` que estará incluido en el `.gitignore`.
