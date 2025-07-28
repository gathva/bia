import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:bia/features/chat/core/tools.dart';

// --- Configuración del Modelo ---
// Cambia este valor para probar diferentes modelos de OpenRouter.
const String _defaultModel = 'google/gemini-2.5-flash-lite';
// -----------------------------

class AIService {
  final String _apiKey;
  final String _systemPrompt;

  AIService()
      : _apiKey = dotenv.env['OPENROUTER_API_KEY']!,
        _systemPrompt = """Eres BIA, un asistente de IA para la gestión de bodegas. 
        Tu objetivo es ayudar a los usuarios a interactuar con la base de datos de productos de la forma más eficiente posible.
        A continuación, se describen las herramientas que tienes a tu disposición para interactuar con la base de datos:
        $aplicationTools

        Basado en la conversación, determina si necesitas utilizar una herramienta. Si es así, responde ÚNICAMENTE con un objeto JSON con la siguiente estructura: {"tool": "nombre_de_la_herramienta", "params": {"parametro_1": "valor_1", ...}}.
        Por ejemplo: {"tool": "search_product_by_name", "params": {"product_name": "tornillos"}}
        Si no necesitas una herramienta, responde de forma conversacional.
        """;

  Future<Map<String, dynamic>> sendMessage(String message, {String? model}) async {
    final selectedModel = model ?? _defaultModel;
    
    try {
      final response = await http.post(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': selectedModel,
          'messages': [
            {'role': 'system', 'content': _systemPrompt},
            {'role': 'user', 'content': message},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final body = json.decode(utf8.decode(response.bodyBytes));
        final text = body['choices'][0]['message']['content'];

        // --- LOG DE DEPURACIÓN ---
        print('Respuesta cruda de la IA: $text');
        // -------------------------

        if (text != null) {
          // Intenta decodificar el JSON. Si falla, es una respuesta conversacional.
          try {
            // A veces la IA devuelve el JSON dentro de un bloque de código markdown.
            final cleanedText = text.replaceAll('```json', '').replaceAll('```', '').trim();
            return json.decode(cleanedText) as Map<String, dynamic>;
          } catch (e) {
            return {'response': text};
          }
        } else {
          return {'response': 'No se recibió texto del asistente.'};
        }
      } else {
        final errorBody = json.decode(utf8.decode(response.bodyBytes));
        final errorMessage = errorBody['error']?['message'] ?? 'Error desconocido de la API.';
        print('Error de la API de OpenRouter: ${response.statusCode} - $errorMessage');
        return {'response': 'Error de la API: $errorMessage'};
      }
    } catch (e) {
      print('Error en la llamada a la API: ${e.toString()}');
      return {'response': 'Error de conexión: ${e.toString()}'};
    }
  }
}