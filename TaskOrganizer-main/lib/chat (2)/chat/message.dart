import 'package:task_app/constants/constants.dart';

class Message {
  final String message;
  final String id;

  Message(this.message, this.id);
  factory Message.fromJson(json) {
    if (json == null) {
      throw FormatException("Invalid JSON format");
    }
    return Message(json[kMessage] ?? "", json['id'] ?? "");
  }
}

