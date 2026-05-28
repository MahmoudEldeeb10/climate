import 'package:climate/features/chat/data/models/message_model.dart';


abstract class ChatStates {}

class ChatInitial extends ChatStates {}

class ChatLoading extends ChatStates {
  final List<MessageModel> messages;
  ChatLoading(this.messages);
}

class ChatSuccess extends ChatStates {
  final List<MessageModel> messages;
  ChatSuccess(this.messages);
}

class ChatError extends ChatStates {
  final List<MessageModel> messages;
  final String errorMessage;
  ChatError(this.messages, this.errorMessage);
}
