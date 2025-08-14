#include "include/chat_plugin/chat_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "chat_plugin.h"

void ChatPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  chat_plugin::ChatPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
