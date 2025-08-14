// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatTicketAdapter extends TypeAdapter<ChatTicket> {
  @override
  final int typeId = 0;

  @override
  ChatTicket read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatTicket(
      userUuid: fields[0] as String?,
      appId: fields[1] as int?,
      userId: fields[2] as int?,
      userName: fields[3] as String?,
      userEmail: fields[4] as String?,
      userMobile: fields[5] as String?,
      businessName: fields[6] as String?,
      userAddress: fields[7] as String?,
      adminId: fields[8] as int?,
      chatType: fields[9] as String?,
      chatLevel: fields[10] as String?,
      initiatedBy: fields[11] as String?,
      status: fields[12] as String?,
      businessId: fields[13] as int?,
      token: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatTicket obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.userUuid)
      ..writeByte(1)
      ..write(obj.appId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.userName)
      ..writeByte(4)
      ..write(obj.userEmail)
      ..writeByte(5)
      ..write(obj.userMobile)
      ..writeByte(6)
      ..write(obj.businessName)
      ..writeByte(7)
      ..write(obj.userAddress)
      ..writeByte(8)
      ..write(obj.adminId)
      ..writeByte(9)
      ..write(obj.chatType)
      ..writeByte(10)
      ..write(obj.chatLevel)
      ..writeByte(11)
      ..write(obj.initiatedBy)
      ..writeByte(12)
      ..write(obj.status)
      ..writeByte(13)
      ..write(obj.businessId)
      ..writeByte(14)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatTicketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
  @override
  final int typeId = 1;

  @override
  ChatMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMessage(
      chatId: fields[0] as int?,
      senderType: fields[1] as String?,
      message: fields[2] as String?,
      attachmentsJson: fields[3] as String?,
      adminId: fields[4] as int?,
      userId: fields[5] as int?,
      userUuid: fields[6] as String?,
      businessId: fields[7] as int?,
      timestamp: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessage obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.chatId)
      ..writeByte(1)
      ..write(obj.senderType)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.attachmentsJson)
      ..writeByte(4)
      ..write(obj.adminId)
      ..writeByte(5)
      ..write(obj.userId)
      ..writeByte(6)
      ..write(obj.userUuid)
      ..writeByte(7)
      ..write(obj.businessId)
      ..writeByte(8)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
