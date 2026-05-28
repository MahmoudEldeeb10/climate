import 'package:climate/features/chat/presentation/view_model/state/chat_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/message_model.dart';
import '../../../data/services/weather_chat_service.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitial());

  final WeatherChatService _service = WeatherChatService();
  final List<MessageModel> _messages = [];

  // Keeps the raw conversation history for the API (role + content only)
  final List<Map<String, String>> _conversationHistory = [];

  List<MessageModel> get messages => List.unmodifiable(_messages);

  /// Called when the user sends a new message.
  Future<void> sendMessage(String userText) async {
    if (userText.trim().isEmpty) return;

    // 1️⃣ Add user message immediately
    final userMessage = MessageModel(
      message: userText.trim(),
      isUser: true,
      time: DateTime.now(),
    );
    _messages.add(userMessage);
    _conversationHistory.add({'role': 'user', 'content': userText.trim()});

    // 2️⃣ Show typing indicator (loading state)
    emit(ChatLoading(List.from(_messages)));

    try {
      // 3️⃣ Send to API and await response
      final botReply = await _service.sendMessage(List.from(_conversationHistory));

      // 4️⃣ Add bot message
      final botMessage = MessageModel(
        message: botReply,
        isUser: false,
        time: DateTime.now(),
      );
      _messages.add(botMessage);
      _conversationHistory.add({'role': 'assistant', 'content': botReply});

      emit(ChatSuccess(List.from(_messages)));
    } catch (e) {
      emit(ChatError(List.from(_messages), e.toString().replaceFirst('Exception: ', '')));
    }
  }

  /// Clears the entire chat history.
  void clearChat() {
    _messages.clear();
    _conversationHistory.clear();
    emit(ChatInitial());
  }

  /// Dismisses the error and goes back to showing messages.
  void dismissError() {
    emit(ChatSuccess(List.from(_messages)));
  }
}
