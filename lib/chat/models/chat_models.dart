import 'dart:convert';

import 'package:hive/hive.dart';

part 'chat_models.g.dart';

/// Chat Ticket model
@HiveType(typeId: 0)
class ChatTicket extends HiveObject {
  @HiveField(0)
  String? userUuid;

  @HiveField(1)
  int? appId;

  @HiveField(2)
  int? userId;

  @HiveField(3)
  String? userName;

  @HiveField(4)
  String? userEmail;

  @HiveField(5)
  String? userMobile;

  @HiveField(6)
  String? businessName;

  @HiveField(7)
  String? userAddress;

  @HiveField(8)
  int? adminId;

  @HiveField(9)
  String? chatType;

  @HiveField(10)
  String? chatLevel;

  @HiveField(11)
  String? initiatedBy;

  @HiveField(12)
  String? status;

  @HiveField(13)
  int? businessId;

  /// Local-only field: WebSocket token
  @HiveField(14)
  String? token;
  @HiveField(15)
  int? id;

  ChatTicket({
    this.userUuid,
    this.appId,
    this.id,
    this.userId,
    this.userName,
    this.userEmail,
    this.userMobile,
    this.businessName,
    this.userAddress,
    this.adminId,
    this.chatType,
    this.chatLevel,
    this.initiatedBy,
    this.status,
    this.businessId,
    this.token,
  });
}

/// Chat message model
@HiveType(typeId: 1)
class ChatMessage extends HiveObject {
  @HiveField(0)
  int? chatId;

  @HiveField(1)
  String? senderType; // "user", "staff", "ai"

  @HiveField(2)
  String? message;

  /// JSON string to store attachments (image/video URLs, etc.)
  @HiveField(3)
  String? attachmentsJson;

  Map? get attachments =>
      attachmentsJson == null ? {} : jsonDecode(attachmentsJson!);

  @HiveField(4)
  int? adminId;

  @HiveField(5)
  int? userId;

  @HiveField(6)
  String? userUuid;

  @HiveField(7)
  int? businessId;

  @HiveField(8)
  DateTime timestamp;

  ChatMessage({
    this.chatId,
    this.senderType,
    this.message,
    this.attachmentsJson,
    this.adminId,
    this.userId,
    this.userUuid,
    this.businessId,
    required this.timestamp,
  });
}
