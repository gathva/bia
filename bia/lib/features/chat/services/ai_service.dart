
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  final GenerativeModel _model;

  AIService()
      : _model = GenerativeModel(
          model: 'gemini-1.5-flash-latest',
          apiKey: dotenv.env['GEMINI_API_KEY']!,
        );

  Future<String> sendMessage(String message) async {
    try {
      final content = [Content.text(message)];
      final response = await _model.generateContent(content);
      return response.text ?? 'No response from AI.';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
