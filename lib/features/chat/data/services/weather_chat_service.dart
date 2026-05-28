import 'package:dio/dio.dart';

class WeatherChatService {
  // ✅ Easy to change — just update these two constants
  static const String apiKey =
      "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";
  static const String model = "openai/gpt-4o-mini";

  static const String _baseUrl = "https://openrouter.ai/api/v1";
  static const String _systemPrompt = """
You are WeatherBot 🌤️, a friendly and knowledgeable weather assistant.
Your role is to:
- Answer all weather-related questions clearly and helpfully
- Provide weather information, forecasts, climate data, and meteorological explanations
- Use emojis to make responses more engaging (☀️ 🌧️ ❄️ 🌪️ 🌈)
- Format responses with **bold**, bullet points, and headers when useful
- Be concise but thorough
- If asked about non-weather topics, gently redirect the conversation to weather

Always respond in the same language the user writes in.
""";

  late final Dio _dio;

  WeatherChatService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://weatherchatbot.app',
          'X-Title': 'Weather Chat Bot',
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    // Add logging interceptor in debug mode
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  /// Sends the full conversation history and returns the bot's reply.
  Future<String> sendMessage(
    List<Map<String, String>> conversationHistory,
  ) async {
    try {
      final messages = [
        {'role': 'system', 'content': _systemPrompt},
        ...conversationHistory,
      ];

      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': model,
          'messages': messages,
          'max_tokens': 1024,
          'temperature': 0.7,
        },
      );

      final content =
          response.data['choices'][0]['message']['content'] as String;
      return content.trim();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(
          '⏱️ Connection timed out. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return Exception(
            '🔑 Invalid API key. Please check your configuration.',
          );
        } else if (statusCode == 429) {
          return Exception(
            '⚡ Rate limit exceeded. Please wait a moment and try again.',
          );
        } else if (statusCode == 500) {
          return Exception('🔧 Server error. Please try again later.');
        }
        return Exception('❌ Server error ($statusCode). Please try again.');
      case DioExceptionType.connectionError:
        return Exception(
          '🌐 No internet connection. Please check your network.',
        );
      default:
        return Exception('Something went wrong. Please try again.');
    }
  }
}
