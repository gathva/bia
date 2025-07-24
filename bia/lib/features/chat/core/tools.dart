
String get aplicationTools => '''
AVAILABLE_TOOLS = [
  {
    "name": "search_product_by_name",
    "description": "Busca un producto en la base de datos por su nombre.",
    "parameters": {
      "type": "object",
      "properties": {
        "product_name": {
          "type": "string",
          "description": "El nombre del producto a buscar."
        }
      },
      "required": ["product_name"]
    }
  },
  {
    "name": "get_low_stock_products",
    "description": "Obtiene una lista de productos con bajo stock.",
    "parameters": {
      "type": "object",
      "properties": {
        "threshold": {
          "type": "integer",
          "description": "El umbral de stock para considerar que un producto tiene bajo stock. Por defecto es 10."
        }
      },
      "required": []
    }
  },
  {
    "name": "get_product_stock",
    "description": "Obtiene el stock de un producto específico.",
    "parameters": {
      "type": "object",
      "properties": {
        "product_name": {
          "type": "string",
          "description": "El nombre del producto a consultar."
        }
      },
      "required": ["product_name"]
    }
  }
]
''';
