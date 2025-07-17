class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final DateTime timestamp;

  Message({required this.id, required this.chatId, required this.senderId, required this.content, required this.timestamp});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'],
        chatId: json['chatId'],
        senderId: json['senderId'],
        content: json['content'],
        timestamp: DateTime.parse(json['timestamp']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'chatId': chatId,
        'senderId': senderId,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
      };
}