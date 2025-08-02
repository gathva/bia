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
    -   `marca` (String)
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
    *   **Error de `minSdkVersion`:** Se aumentó la versión mínima de SDK de Android a 23 en `android/app/build.gradle.kts` para resolver conflictos de dependencias con `firebase-auth`.
    *   **Error de `.env` no encontrado:** Se registró el archivo `.env` como un asset en `pubspec.yaml` para que sea accesible en tiempo de ejecución.
    *   **Errores de Modelos:** Se corrigió la forma en que se asignaban los IDs de Firestore a los modelos `Product` y `Movement`, modificando el constructor `fromMap` para evitar la asignación a un campo `final`.
    *   **Error de `allProducts` no definido:** Se añadió un getter `allProducts` en `DashboardProvider` para permitir el acceso público a la lista de todos los productos, resolviendo un error de compilación en `dashboard_screen.dart`.
*   **Estado:** La aplicación ahora compila correctamente y está lista para continuar con el desarrollo.

### Hito 6: Corrección de `mobile_scanner` (Completado)
*   **Logro:** Se solucionó un error de compilación crítico en `scan_screen.dart` causado por cambios drásticos en la API del paquete `mobile_scanner` (versión 7.0.1).
*   **Estado:** La pantalla de escaneo vuelve a ser funcional y la aplicación compila correctamente.

### Hito 7: Refactorización y Mejoras de Funcionalidad (Completado)
*   **Logro:** Se abordaron varios puntos clave basados en el feedback del usuario para mejorar la funcionalidad y robustez de la aplicación.
*   **Detalles:**
    *   **Activación de Firestore:** Se guió al usuario para habilitar la API de Cloud Firestore y crear la base de datos en modo de prueba, solucionando el error `PERMISSION_DENIED` que impedía guardar nuevos productos.
    *   **Campo "Marca" añadido:** Se modificó el modelo de datos `Product`, el formulario de creación y la lógica de guardado para incluir la marca del producto, un campo esencial para la gestión de inventario.
    *   **Migración a OpenRouter:** Se refactorizó el `AIService` para dejar de usar la API de Gemini y conectarse a OpenRouter. Esto permite una mayor flexibilidad para cambiar de modelo de IA y controlar los costos. El servicio ahora es fácilmente configurable para probar diferentes modelos.
*   **Tecnología:** Flutter, Firestore, `http`, OpenRouter API.

### Hito 8: Lógica de Movimientos de Stock (Completado)
*   **Logro:** Se implementó la funcionalidad completa para registrar entradas y salidas de stock desde la pantalla de detalles del producto.
*   **Detalles:**
    *   **Lógica Transaccional:** Se creó un método en `FirestoreService` que utiliza una transacción de Firestore para registrar el movimiento en la colección `movements` y actualizar el `stock_actual` en la colección `products` de forma atómica, garantizando la integridad de los datos.
    *   **UI/UX:** Se implementó un diálogo (`AlertDialog`) en la pantalla de detalles que permite al usuario introducir la cantidad para la entrada o salida, con validaciones para prevenir errores (ej. sacar más stock del disponible).
*   **Tecnología:** Flutter, Firestore Transactions.

---

## Plan de Acción Actual

### Fase 1: Estabilidad y Funcionalidad Central (Completado)

*   **[COMPLETADO] Paso 1.1: Actualización de Estado del Dashboard:**
    *   **Objetivo:** Hacer que el Dashboard se actualice automáticamente después de registrar un nuevo producto o un movimiento de stock.
    *   **Acción:** Se modificó el `DashboardProvider` para exponer un método `reloadData()`. Este método ahora es llamado desde `NewProductFormScreen` y `ProductDetailScreen` después de una operación exitosa, forzando la recarga de los datos y actualizando la UI.

*   **[COMPLETADO] Paso 1.2: Depuración del Chat de IA:**
    *   **Objetivo:** Solucionar la intermitencia del chat y asegurar que las llamadas a herramientas (ej. "buscar productos con bajo stock") funcionen de manera fiable.
    *   **Acción:** Se mejoró el prompt del sistema en `AIService` para guiar a la IA a usar el formato JSON esperado (`"tool"` y `"params"`). Se hizo el código de `ChatScreen` más robusto para manejar tanto `"tool"` como `"tool_name"` en la respuesta de la IA. Se eliminaron los logs de depuración.

### Fase 2: Mejoras de Experiencia de Usuario (UX) (Completado)

*   **[COMPLETADO] Paso 2.1: Dashboard Interactivo:**
    *   **Objetivo:** Permitir que el usuario pueda hacer clic en las tarjetas de estadísticas ("Total de Productos", "Bajo Stock") para ver una lista detallada.
    *   **Acción:** Se creó la pantalla `ProductListViewScreen` para mostrar listas de productos. Se modificó `dashboard_screen.dart` para navegar a esta pantalla al hacer clic en las estadísticas, pasando la lista de productos correspondiente.

*   **[COMPLETADO] Paso 2.2: Sugerencias en el Chat:**
    *   **Objetivo:** Añadir botones con preguntas frecuentes en la pantalla del chat para guiar al usuario.
    *   **Acción:** Se añadió una `Row` de `ActionChip`s encima del campo de texto del chat con acciones predefinidas como "Bajo stock" o "Buscar producto".

### Fase 3: Nuevas Funcionalidades (Completado)

*   **[COMPLETADO] Paso 3.1: Ingreso Manual de Productos:**
    *   **Objetivo:** Ofrecer una alternativa al escaneo de códigos de barras.
    *   **Acción:** Se añadió un botón "Ingreso Manual" en la `ScanScreen`. Al presionarlo, se muestra un `AlertDialog` pidiendo al usuario que escriba el código de barras. Si el código ya existe, se navega a los detalles; si no, al formulario de nuevo producto.
