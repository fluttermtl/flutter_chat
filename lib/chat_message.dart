import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  ChatMessage({
    required this.time,
    required this.message,
  });

  final int time;
  final String message;

  String get timestamp =>
      '${DateTime.fromMillisecondsSinceEpoch(time).hour}:${DateTime.fromMillisecondsSinceEpoch(time).minute}';

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      time: json['time'],
      message: json['message'],
    );
  }

  static List<ChatMessage> fromQueryDocumentSnapshot(
      List<QueryDocumentSnapshot> docs) {
    return docs
        .map<ChatMessage>(
          (json) => ChatMessage.fromJson(json.data() as Map<String, dynamic>),
        )
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'message': message,
    };
  }
}
