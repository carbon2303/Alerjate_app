class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({
    required this.text,
    required this.isUser,
  });

  Map<String, dynamic> toJson() => {
        "text": text,
        "isUser": isUser,
      };

  static ChatMessage fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json["text"],
      isUser: json["isUser"],
    );
  }
}
