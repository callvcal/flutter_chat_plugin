// chat_bloc.dart
import 'dart:convert';

import 'package:chat_plugin/chat/chat_bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../models/chat_models.dart';
import '../services/chat_service.dart';
import 'event.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatSocketService socketService;
  Box<ChatMessage>? messagesBox;
  ChatTicket? ticket;

  ChatBloc(this.socketService) : super(ChatState()) {
    on<ChatInit>(_onInit);
    on<ChatMessageReceived>(_onMessageReceived);
    on<ChatSendMessage>(_onSendMessage);
    on<ChatConnectionChanged>(_onConnectionChanged);
  }

  Future<void> _onInit(ChatInit event, Emitter<ChatState> emit) async {
    ticket = event.ticket;
    messagesBox = await Hive.openBox<ChatMessage>('chat_${ticket!.id}');
    emit(state.copyWith(messages: messagesBox!.values.toList()));

    // Connect socket
    socketService.connect(
      token: ticket!.token!,
      appId: ticket!.appId!,
      businessId: ticket!.businessId!,
      userId: ticket!.userId!,
      onMessageReceived: (data) {
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
        add(ChatMessageReceived(message: msg, messageId: msgId));
      },
    );

    add(ChatConnectionChanged(true));
  }

  void _onMessageReceived(ChatMessageReceived event, Emitter<ChatState> emit) {
    var msgId = event.messageId;
    final exists = messagesBox?.values.any((m) {
          return m.key == msgId;
        }) ??
        false;

    if (!exists) {
      if (event.messageId != null) {
        messagesBox?.put(event.messageId!, event.message);
      } else {
        messagesBox?.add(event.message);
      }
      emit(state.copyWith(messages: messagesBox!.values.toList()));
    }
  }

  Future<void> _onSendMessage(
      ChatSendMessage event, Emitter<ChatState> emit) async {
    if (event.text.trim().isEmpty || state.isSending || ticket == null) return;

    emit(state.copyWith(isSending: true));
    final now = DateTime.now();
    // final tempKey = "temp_${now.microsecondsSinceEpoch}";

    final optimisticMsg = ChatMessage(
      chatId: null,
      senderType: 'user',
      message: event.text.trim(),
      attachmentsJson: null,
      adminId: null,
      userId: ticket!.userId,
      userUuid: ticket!.userUuid,
      businessId: ticket!.businessId,
      timestamp: now,
    );

    // messagesBox?.put(tempKey, optimisticMsg);
    emit(state.copyWith(messages: messagesBox!.values.toList()));

    try {
      final url = Uri.parse("https://admin.callvcal.com/api/chat/send");
      final res = await http.post(url, body: {
        'token': ticket!.token,
        'message': event.text.trim(),
      });

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['conversation'];
        final msgId = data['id']?.toString();
        final createdAt = DateTime.tryParse(data['created_at'] ?? '') ?? now;

        final confirmedMsg = ChatMessage(
          chatId: data['chat_id'],
          senderType: data['sender_type'],
          message: data['message'] ?? '',
          attachmentsJson: data['attachments'] != null
              ? jsonEncode(data['attachments'])
              : null,
          adminId: data['admin_id'],
          userId: int.tryParse("${data['user_id']}"),
          businessId: int.tryParse("${data['businessId']}"),
          userUuid: data['user_uuid'],
          timestamp: createdAt,
        );

        // messagesBox?.delete(tempKey);
        if (msgId != null) {
          messagesBox?.put(msgId, confirmedMsg);
        } else {
          // messagesBox?.put(tempKey, confirmedMsg);
        }
      } else {
        // messagesBox?.delete(tempKey);
      }
    } catch (e) {
      // messagesBox?.delete(tempKey);
    }

    emit(state.copyWith(
      isSending: false,
      messages: messagesBox!.values.toList(),
    ));
  }

  void _onConnectionChanged(
      ChatConnectionChanged event, Emitter<ChatState> emit) {
    emit(state.copyWith(isConnected: event.isConnected));
  }
}
