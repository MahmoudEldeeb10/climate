class MessageModel {
  final String message;
  final bool isUser;
  final DateTime time;

  const MessageModel({
    required this.message,
    required this.isUser,
    required this.time,
  });

  MessageModel copyWith({
    String? message,
    bool? isUser,
    DateTime? time,
  }) {
    return MessageModel(
      message: message ?? this.message,
      isUser: isUser ?? this.isUser,
      time: time ?? this.time,
    );
  }
}
