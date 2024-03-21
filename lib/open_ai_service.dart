import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Class to interact with OpenAI APIs for chat and image generation.
class OpenAIService {
  /// List of messages used for chat conversations (internal state).
  final List<Map<String, String>> conversationHistory = [];

  /// Checks if a prompt is related to art generation using the chat API.
  Future<String> isArtPrompt(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openApiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              'role': 'user',
              'content':
              'Does this message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with a yes or no.',
            }
          ],
        }),
      );

      print(prompt);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final content = jsonDecode(response.body)['choices'][0]['message']['content'].trim();
        print(content);
        switch (content.toLowerCase()) {
          case 'yes':
            return await generateArtWithDALL_E(prompt);
          default:
            return await chatGPT(prompt);
        }
      }
      return 'An internal error occurred';
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  /// Generates a chat response using the chatGPT model.
  Future<String> chatGPT(String prompt) async {
    conversationHistory.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openApiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": conversationHistory,
        }),
      );

      if (response.statusCode == 200) {
        final content = jsonDecode(response.body)['choices'][0]['message']['content'].trim();
        conversationHistory.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  /// Generates an image using the DALL-E model based on the prompt.
  Future<String> generateArtWithDALL_E(String prompt) async {
    conversationHistory.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openApiKey',
        },
        body: jsonEncode({
          'prompt': prompt,
          'n': 1, // Number of images to generate
        }),
      );

      if (response.statusCode == 200) {
        final imageUrl = jsonDecode(response.body)['data'][0]['url'].trim();
        conversationHistory.add({
          'role': 'assistant',
          'content': imageUrl,
        });
        return imageUrl;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }
}
