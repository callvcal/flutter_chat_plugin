#ifndef FLUTTER_PLUGIN_CHAT_PLUGIN_H_
#define FLUTTER_PLUGIN_CHAT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace chat_plugin {

class ChatPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  ChatPlugin();

  virtual ~ChatPlugin();

  // Disallow copy and assign.
  ChatPlugin(const ChatPlugin&) = delete;
  ChatPlugin& operator=(const ChatPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace chat_plugin

#endif  // FLUTTER_PLUGIN_CHAT_PLUGIN_H_
