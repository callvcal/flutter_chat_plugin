// chat_state.dart
import '../models/chat_models.dart';

class ChatState {
  final bool isConnected;
  final bool isSending;
  final List<ChatMessage> messages;

  ChatState({
    this.isConnected = false,
    this.isSending = false,
    this.messages = const [],
  });

  ChatState copyWith({
    bool? isConnected,
    bool? isSending,
    List<ChatMessage>? messages,
  }) {
    return ChatState(
      isConnected: isConnected ?? this.isConnected,
      isSending: isSending ?? this.isSending,
      messages: messages ?? this.messages,
    );
  }
}
