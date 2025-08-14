// chat_event.dart
import '../models/chat_models.dart';

abstract class ChatEvent {}

class ChatInit extends ChatEvent {
  final ChatTicket ticket;
  ChatInit(this.ticket);
}

class ChatMessageReceived extends ChatEvent {
  final ChatMessage message;
  final String? messageId;
  ChatMessageReceived({required this.message, this.messageId});
}

class ChatSendMessage extends ChatEvent {
  final String text;
  ChatSendMessage(this.text);
}

class ChatConnectionChanged extends ChatEvent {
  final bool isConnected;
  ChatConnectionChanged(this.isConnected);
}
