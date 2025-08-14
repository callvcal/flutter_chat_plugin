import 'package:flutter_test/flutter_test.dart';
import 'package:chat_plugin/chat_plugin.dart';
import 'package:chat_plugin/chat_plugin_platform_interface.dart';
import 'package:chat_plugin/chat_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockChatPluginPlatform
    with MockPlatformInterfaceMixin
    implements ChatPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ChatPluginPlatform initialPlatform = ChatPluginPlatform.instance;

  test('$MethodChannelChatPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelChatPlugin>());
  });

  test('getPlatformVersion', () async {
    ChatPlugin chatPlugin = ChatPlugin();
    MockChatPluginPlatform fakePlatform = MockChatPluginPlatform();
    ChatPluginPlatform.instance = fakePlatform;

    expect(await chatPlugin.getPlatformVersion(), '42');
  });
}
