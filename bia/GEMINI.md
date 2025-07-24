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

---

# Historial de Avances y Próximos Pasos

### Hito 1: Estructura y Navegación Base (Completado)
*   **Logro:** Se implementó la estructura de navegación principal con `BottomNavigationBar`, permitiendo el acceso a las pantallas de **Dashboard**, **Scan** y **Chat**.
*   **Tecnología:** Flutter.

### Hito 2: Dashboard Funcional con Datos de Firestore (Completado)
*   **Logro:** Se diseñó y conectó el Dashboard a Firestore. Ahora muestra datos en tiempo real, incluyendo **productos con bajo stock**, el **conteo total de productos** y una lista de **movimientos recientes** con nombres y fechas formateadas. Se añadió la función de **actualizar al deslizar**.
*   **Tecnología:** Flutter, Provider, Firestore, `intl`.

### Hito 3: Flujo de Escaneo de Códigos de Barras (Completado)
*   **Logro:** Se implementó la funcionalidad de escaneo de códigos de barras. La aplicación puede **detectar un código**, **buscarlo en Firestore** y **navegar a la pantalla correcta**: a los detalles si el producto existe, o a un formulario si es nuevo.
*   **Tecnología:** Flutter, `mobile_scanner`, Firestore.

### Hito 4: Creación de Nuevos Productos (Completado)
*   **Logro:** Se ha implementado por completo el flujo de creación de nuevos productos. La app ahora presenta un formulario con validaciones cuando se escanea un código de barras no registrado, permitiendo al usuario añadir el nuevo producto (nombre, descripción, stock, ubicación) directamente a la base de datos de Firestore.
*   **Tecnología:** Flutter, Firestore.

### Hito 5: Implementación del Asistente de IA (Completado)
*   **Logro:** Se ha implementado por completo el asistente de IA con capacidad de "Function Calling". La IA puede interpretar las solicitudes del usuario y utilizar un conjunto de herramientas para interactuar con la base de datos de Firestore. 
*   **Herramientas Implementadas:**
    *   `search_product_by_name`: Busca productos por su nombre.
    *   `get_low_stock_products`: Obtiene una lista de productos con bajo stock.
    *   `get_product_stock`: Consulta el stock de un producto específico.
*   **Tecnología:** Flutter, `google_generative_ai`, `flutter_dotenv`, Firestore.

### Mantenimiento: Corrección de Errores de Compilación (Completado)
*   **Logro:** Se solucionaron varios errores críticos que impedían la compilación de la aplicación.
    *   **Errores de Modelos:** Se corrigió la forma en que se asignaban los IDs de Firestore a los modelos `Product` y `Movement`, modificando el constructor `fromMap` para evitar la asignación a un campo `final`.
    *   **Errores de `mobile_scanner`:** Se actualizaron las llamadas a la API del paquete `mobile_scanner` en `scan_screen.dart` para ser compatibles con la versión actual, solucionando problemas con el estado de la linterna/cámara y errores de nulidad.
*   **Estado:** La aplicación ahora compila correctamente y está lista para continuar con el desarrollo.
