import 'dart:convert';
import 'package:http/http.dart' as http;

/// DeepSeek AI Service - FREE API for text-based AI features
/// Uses DeepSeek V3.2 model for intelligent responses
class DeepSeekService {
  static DeepSeekService? _instance;
  
  // DeepSeek API configuration
  static const String _baseUrl = 'https://api.deepseek.com';
  static const String _model = 'deepseek-chat';
  
  // API key - users should set their own key
  String? _apiKey;
  
  DeepSeekService._();
  
  static DeepSeekService get instance {
    _instance ??= DeepSeekService._();
    return _instance!;
  }
  
  /// Set the API key for DeepSeek
  void setApiKey(String key) {
    _apiKey = key;
  }
  
  /// Check if API key is configured
  bool get isConfigured => _apiKey != null && _apiKey!.isNotEmpty;
  
  /// Generate creative fill prompt suggestions
  /// FREE - Uses DeepSeek chat API
  Future<String?> generateFillPrompt(String userPrompt) async {
    if (!isConfigured) return null;
    
    try {
      final response = await _chatCompletion(
        'You are an AI assistant for a photo editor. Generate a creative and detailed prompt for generative fill based on the user\'s request. Keep it concise but descriptive.\n\nUser request: $userPrompt',
      );
      return response;
    } catch (e) {
      print('DeepSeek generateFillPrompt error: \$e');
      return null;
    }
  }
  
  /// Generate image description/caption
  /// FREE - Uses DeepSeek chat API
  Future<String?> generateCaption(String context) async {
    if (!isConfigured) return null;
    
    try {
      final response = await _chatCompletion(
        'Generate a creative and engaging caption for a photo. Context: $context. Keep it short, catchy, and suitable for social media.',
      );
      return response;
    } catch (e) {
      print('DeepSeek generateCaption error: \$e');
      return null;
    }
  }
  
  /// Get AI-powered editing suggestions
  /// FREE - Uses DeepSeek chat API
  Future<List<String>?> getEditingSuggestions(String imageDescription) async {
    if (!isConfigured) return null;
    
    try {
      final response = await _chatCompletion(
        'You are a photo editing expert. Based on this image description, suggest 3-5 quick editing improvements. Return as a simple list.\n\nImage: $imageDescription',
      );
      if (response != null) {
        return response.split('\n').where((s) => s.trim().isNotEmpty).toList();
      }
      return null;
    } catch (e) {
      print('DeepSeek getEditingSuggestions error: \$e');
      return null;
    }
  }
  
  /// Internal chat completion method
  Future<String?> _chatCompletion(String prompt) async {
    final response = await http.post(
      Uri.parse('\$_baseUrl/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer \$_apiKey',
      },
      body: jsonEncode({
        'model': _model,
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
        'max_tokens': 500,
        'temperature': 0.7,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices']?[0]?['message']?['content'];
    } else {
      print('DeepSeek API error: \${response.statusCode} - \${response.body}');
      return null;
    }
  }
}
