
import 'dart:convert';

import 'package:bia/features/chat/core/tools.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  final GenerativeModel _model;
  final String _systemPrompt;

  AIService()
      : _model = GenerativeModel(
          model: 'gemini-1.5-flash-latest',
          apiKey: dotenv.env['GEMINI_API_KEY']!,
        ),
        _systemPrompt = '''Eres BIA, un asistente de IA para la gestión de bodegas. 
        Tu objetivo es ayudar a los usuarios a interactuar con la base de datos de productos de la forma más eficiente posible.
        A continuación, se describen las herramientas que tienes a tu disposición para interactuar con la base de datos:
        $aplicationTools

        Basado en la conversación, determina si necesitas utilizar una herramienta. Si es así, responde únicamente con un JSON que describa la herramienta a utilizar y los parámetros necesarios. 
        Si no necesitas una herramienta, responde de forma conversacional.
        ''';

  Future<Map<String, dynamic>> sendMessage(String message) async {
    try {
      final content = [Content.text("$_systemPrompt\n\nUser message: $message")];
      final response = await _model.generateContent(content);
      final text = response.text;

      if (text != null) {
        // Intenta decodificar el JSON. Si falla, es una respuesta conversacional.
        try {
          return json.decode(text) as Map<String, dynamic>;
        } catch (e) {
          return {'response': text};
        }
      } else {
        return {'response': 'No response from AI.'};
      }
    } catch (e) {
      return {'response': 'Error: ${e.toString()}'};
    }
  }
}
