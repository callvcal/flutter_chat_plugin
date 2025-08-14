import 'package:hive_flutter/hive_flutter.dart';

import 'chat/models/chat_models.dart';
import 'chat_plugin_platform_interface.dart';

class ChatPlugin {
  Future<String?> getPlatformVersion() {
    return ChatPluginPlatform.instance.getPlatformVersion();
  }

  Future<void> init() async {
    // Initialize Hive with Flutter bindings
    await Hive.initFlutter();

    // Register all your Hive adapters
    Hive.registerAdapter(ChatMessageAdapter());
    Hive.registerAdapter(ChatTicketAdapter());

    // Open the boxes AFTER registering adapters
    await Hive.openBox<ChatMessage>('gs_rkhvk_chat_messages');
    await Hive.openBox<ChatTicket>('gs_rkhvk_chat_tickets');
  }
}
