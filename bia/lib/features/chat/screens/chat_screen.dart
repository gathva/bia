import 'package:flutter/material.dart';
import 'package:bia/features/chat/services/ai_service.dart'; // Importa el servicio de IA

// Modelo simple para un mensaje de chat
class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(text: "¡Hola! Soy BIA, tu asistente de bodega. ¿En qué puedo ayudarte hoy?", isUser: false),
  ];
  final AIService _aiService = AIService(); // Instancia del servicio
  bool _isTyping = false; // Estado para el indicador de "escribiendo"

  Future<void> _handleSubmitted(String text) async {
    if (text.isEmpty) return;
    _textController.clear();

    // Añade el mensaje del usuario a la lista
    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUser: true));
      _isTyping = true; // Muestra el indicador de "escribiendo"
    });

    // Envía el mensaje a la IA y espera la respuesta
    try {
      final aiResponse = await _aiService.sendMessage(text);
      // Añade la respuesta de la IA a la lista
      setState(() {
        _messages.insert(0, ChatMessage(text: aiResponse, isUser: false));
      });
    } catch (e) {
      // Maneja el error y muestra un mensaje
      setState(() {
        _messages.insert(0, ChatMessage(text: "Lo siento, ocurrió un error.", isUser: false));
      });
    } finally {
      setState(() {
        _isTyping = false; // Oculta el indicador
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente BIA'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Lista de mensajes
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _buildMessage(_messages[index]),
            ),
          ),
          if (_isTyping) _buildTypingIndicator(), // Muestra el indicador si la IA está "escribiendo"
          const Divider(height: 1.0),
          // Campo de entrada de texto
          _buildTextComposer(),
        ],
      ),
    );
  }

  // Widget para construir cada burbuja de mensaje
  Widget _buildMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Avatar (opcional, se puede personalizar)
          if (!message.isUser)
            const CircleAvatar(child: Icon(Icons.android)),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message.isUser ? "Tú" : "BIA",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: message.isUser ? Colors.blue[100] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Text(message.text),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (message.isUser)
            const CircleAvatar(child: Icon(Icons.person)),
        ],
      ),
    );
  }

  // Widget para el campo de texto y el botón de enviar
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.primary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                  hintText: "Escribe un mensaje...",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0), // Añade padding vertical
      ),
    );
  }

  // Widget para el indicador de "escribiendo"
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CircleAvatar(child: Icon(Icons.android)),
          const SizedBox(width: 8),
          Text("BIA está escribiendo..."),
        ],
      ),
    );
  }
}