import 'dart:convert';

import 'package:chat_plugin/chat/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../models/chat_models.dart';
import '../screens/chat_page.dart';

//  Hive.registerAdapter(ChatMessageAdapter());
//     Hive.registerAdapter(ChatTicketAdapter());
class StartChatButton extends StatelessWidget {
  final int? appId;
  final int? userId;
  final int? businessId;
  final String? userName;
  final String? userEmail;
  final String? userMobile;
  final String? businessName;
  final String? userAddress;
  final String? secret;

  const StartChatButton({
    Key? key,
    required this.appId,
    required this.userId,
    required this.businessId,
    required this.userName,
    required this.userEmail,
    required this.userMobile,
    required this.businessName,
    required this.userAddress,
    required this.secret,
  }) : super(key: key);

  Future<void> _startChat(BuildContext context) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final url = Uri.parse("https://admin.callvcal.com/api/chat/token");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "secure": secret!,
        },
        body: jsonEncode({
          "appId": appId,
          "userId": userId,
          "businessId": businessId,
          "user_name": userName,
          "user_email": userEmail,
          "user_mobile": userMobile,
          "business_name": businessName,
          "user_address": userAddress,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data["token"];
        final ticketData = data["ticket"];

        // Convert API ticket to Hive ChatTicket object
        final chatTicket = ChatTicket(
          userUuid: ticketData["user_uuid"],
          appId: ticketData["app_id"],
          userId: ticketData["user_id"],
          userName: ticketData["user_name"],
          userEmail: ticketData["user_email"],
          userMobile: ticketData["user_mobile"],
          businessName: ticketData["business_name"],
          userAddress: ticketData["user_address"],
          adminId: ticketData["admin_id"],
          chatType: ticketData["chat_type"],
          chatLevel: ticketData["chat_level"],
          initiatedBy: ticketData["initiated_by"],
          status: ticketData["status"],
          businessId: ticketData["business_id"],
          token: token,
        );

        // Store in Hive
        final box = await Hive.openBox<ChatTicket>('chat_tickets');
        await box.put(ticketData["user_uuid"], chatTicket);

        ChatSocketService()
            .syncConversations(chatTicket, data['conversations']);

        Get.back(); // Close loading

        // Navigate to chat page
        Get.to(() => ChatPage(
              ticket: chatTicket,
            ));
      } else {
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.body}")),
        );
      }
    } catch (e) {
      Get.back();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _startChat(context),
      icon: const Icon(Icons.support_agent, color: Colors.white),
      label: const Text(
        "Chat",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
