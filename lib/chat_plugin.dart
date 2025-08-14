
import 'chat_plugin_platform_interface.dart';

class ChatPlugin {
  Future<String?> getPlatformVersion() {
    return ChatPluginPlatform.instance.getPlatformVersion();
  }
}
