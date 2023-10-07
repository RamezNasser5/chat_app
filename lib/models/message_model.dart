import 'package:chat_app/helper/const.dart';

class MessageModel {
  final String message;
  final String id;

  MessageModel(this.message, this.id);

  factory MessageModel.fromJson(Map<String, dynamic> jsonData) {
    final message = jsonData[
        jsonMessage]; // Update jsonMessage to match your field name, e.g., "Messages"
    if (message == null) {
      throw ArgumentError("Field '$jsonMessage' not found in JSON data");
    }
    final id = jsonData[
        'id']; // Update jsonMessage to match your field name, e.g., "id"
    if (id == null) {
      throw ArgumentError("Field id not found in JSON data");
    }
    return MessageModel(message, id);
  }
}
