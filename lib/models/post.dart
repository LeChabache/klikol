class Post {
  final String id;
  final String userId;
  final String content;
  final String type; // e.g., text, image, video
  final DateTime timestamp;

  Post({required this.id, required this.userId, required this.content, required this.type, required this.timestamp});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'],
        userId: json['userId'],
        content: json['content'],
        type: json['type'],
        timestamp: DateTime.parse(json['timestamp']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'content': content,
        'type': type,
        'timestamp': timestamp.toIso8601String(),
      };
}