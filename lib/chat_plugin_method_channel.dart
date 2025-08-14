import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'chat_plugin_platform_interface.dart';

/// An implementation of [ChatPluginPlatform] that uses method channels.
class MethodChannelChatPlugin extends ChatPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('chat_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
