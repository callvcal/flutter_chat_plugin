import 'dart:convert';

import 'package:chat_plugin/chat/chat_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../chat_bloc/event.dart';
import '../models/chat_models.dart';

typedef ChatMessageCallback = void Function(Map<String, dynamic> message);

class ChatSocketService {
  // 👇 Singleton instance
  static final ChatSocketService _instance = ChatSocketService._internal();

  factory ChatSocketService() => _instance;

  ChatSocketService._internal();

  late IO.Socket socket;
  ChatMessageCallback? onMessage;
  bool isAdmin = false;

  handleFCM(Map data) {
    if (data['type'] == "callvcal-chat") {
      final msgId = data['id']?.toString();
      final createdAt =
          DateTime.tryParse(data['created_at'] ?? '') ?? DateTime.now();
      final msg = ChatMessage(
        chatId: data['chat_id'],
        senderType: data['sender_type'],
        message: data['message'] ?? '',
        attachmentsJson: data['attachments'] != null
            ? jsonEncode(data['attachments'])
            : null,
        adminId: data['admin_id'],
        userId: data['user_id'],
        userUuid: data['user_uuid'],
        businessId: data['business_id'],
        timestamp: createdAt,
      );

      Get.context
          ?.read<ChatBloc>()
          .add(ChatMessageReceived(message: msg, messageId: msgId));
    }
  }

  void connect({
    required String? token,
    required int? appId,
    required int? businessId,
    required int? userId,
    ChatMessageCallback? onMessageReceived,
  }) {
    onMessage = onMessageReceived;

    socket = IO.io(
      'ws://ws.callvcal.com:3008',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'token': token})
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      print("✅ Connected to Socket.IO");

      socket.emit('join_chat', {
        'appId': appId,
        'businessId': businessId,
        'userId': userId,
      });
    });

    socket.on('connected', (msg) => print("ℹ️ Server says: $msg"));
    socket.on(
        'disconnect_reason', (reason) => print("❌ Disconnect reason: $reason"));
    socket.onDisconnect((_) => print("🔌 Disconnected"));
    socket.onError((err) => print("⚠️ Socket error: $err"));

    socket.on('chat_message', (data) {
      print("📩 Chat message: $data");
      if (onMessage != null) {
        onMessage!(Map<String, dynamic>.from(data));
      }
    });

    socket.on('debug_query', (q) => print("🔍 Debug query: $q"));

    socket.connect();
  }

  void sendMessage({
    required String appId,
    required String businessId,
    required String userId,
    required String message,
  }) {}

  void disconnect() {
    socket.disconnect();
  }

  syncConversations(ChatTicket ticket, List? list) async {
    if (list == null) return;
    var messagesBox = await Hive.openBox<ChatMessage>('chat_${ticket.id}');
    list.forEach((data) {
      final createdAt =
          DateTime.tryParse(data['created_at'] ?? '') ?? DateTime.now();
      final msg = ChatMessage(
        chatId: data['chat_id'],
        senderType: data['sender_type'],
        message: data['message'] ?? '',
        attachmentsJson: data['attachments'] != null
            ? jsonEncode(data['attachments'])
            : null,
        adminId: data['admin_id'],
        userId: data['user_id'],
        userUuid: data['user_uuid'],
        businessId: data['business_id'],
        timestamp: createdAt,
      );

      var msgId = "${data['id']}";
      final exists = messagesBox.values.any((m) {
            return m.key == msgId;
          }) ??
          false;

      if (!exists) {
        messagesBox.put(msgId, msg);
      }
    });
  }
}
