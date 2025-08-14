library chat_plugin;

import 'package:hive_flutter/hive_flutter.dart';

import 'chat/models/chat_models.dart';
import 'chat_plugin_platform_interface.dart';

export 'chat/chat_bloc/bloc.dart';
export 'chat/chat_bloc/event.dart';
export 'chat/chat_bloc/state.dart';
export 'chat/models/chat_models.dart';
export 'chat/screens/chat_page.dart';
export 'chat/services/chat_service.dart';

class ChatPlugin {
  /// Initialize Hive, register adapters, and prepare storage
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters before opening boxes
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChatTicketAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ChatMessageAdapter());
    }

    // Open your default chat storage box
    await Hive.openBox('gs_rkhvk_chat');
  }

  Future<String?> getPlatformVersion() {
    return ChatPluginPlatform.instance.getPlatformVersion();
  }
}
