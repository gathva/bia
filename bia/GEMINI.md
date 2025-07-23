# Plan de Desarrollo: App de Control de Bodega (BIA)

## Fase 1: Cimientos de la App (Autenticación y Estructura)

1.  **Autenticación de Usuarios:** Crear pantallas de inicio de sesión y registro con Firebase Authentication.
2.  **Estructura de Navegación:** Implementar la `NavigationBar` principal (Dashboard, Scan, Chat).
3.  **Modelos de Datos:** Definir las clases de Dart para `Producto`, `Bodega`, `Usuario` y `Movimiento` para interactuar con Firestore.

## Fase 2: Funcionalidad Principal (CRUD de Inventario)

1.  **Gestión de Productos:** Implementar la funcionalidad del botón `(+)` para escanear, crear, consultar y modificar el stock de productos.
2.  **Dashboard:** Construir la página principal para mostrar estadísticas clave (últimos movimientos, niveles de stock, etc.).

## Fase 3: Inteligencia y Roles Avanzados

1.  **Chat con IA:** Integrar el chat con OpenRouter usando "Function Calling" para consultar la base de datos en Firestore.
2.  **Roles y Permisos:** Implementar la lógica para los roles de usuario (Admin, Editor, Visor).

## Roles de Usuario Sugeridos

*   **Admin:** Control total sobre bodegas, usuarios y productos.
*   **Editor:** Gestiona el inventario en sus bodegas asignadas.
*   **Visor:** Solo puede consultar el inventario y usar el chat.