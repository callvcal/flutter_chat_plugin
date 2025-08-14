import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../chat_bloc/bloc.dart';
import '../chat_bloc/event.dart';
import '../chat_bloc/state.dart';
import '../models/chat_models.dart';
import '../services/chat_service.dart';

class ChatPage extends StatelessWidget {
  final ChatTicket ticket;

  const ChatPage({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc(ChatSocketService())..add(ChatInit(ticket)),
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          final bloc = context.read<ChatBloc>();
          final controller = TextEditingController();

          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green.shade100,
                    child: Text(
                      (ticket.businessName?.isNotEmpty ?? false)
                          ? ticket.businessName![0].toUpperCase()
                          : "S",
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ticket.businessName ?? "Support",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Icon(
                            state.isConnected
                                ? Icons.circle
                                : Icons.circle_outlined,
                            size: 10,
                            color:
                                state.isConnected ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            state.isConnected ? "Online" : "Offline",
                            style: TextStyle(
                                fontSize: 12,
                                color: state.isConnected
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: "Clear Chat",
                  onPressed: () async {
                    await bloc.messagesBox?.clear();
                    bloc.emit(state.copyWith(messages: []));
                  },
                  icon: const Icon(Icons.delete_forever),
                )
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ChatPageConversations(
                    messages: state.messages,
                  ),
                ),
                SafeArea(
                  child: Container(
                    color: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: "Type your message...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        state.isSending
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : IconButton(
                                icon:
                                    const Icon(Icons.send, color: Colors.green),
                                onPressed: () {
                                  if (controller.text.trim().isNotEmpty) {
                                    bloc.add(ChatSendMessage(controller.text));
                                    controller.clear();
                                  }
                                },
                              ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class ChatPageConversations extends StatelessWidget {
  const ChatPageConversations({
    super.key,
    required this.messages,
  });

  final List<ChatMessage> messages;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Reverse messages so the latest is at the bottom
    final sortedMessages = messages.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: sortedMessages.length,
      itemBuilder: (context, index) {
        final msg = sortedMessages[index];
        final isMe = msg.senderType == 'user';

        // Convert to local time
        final localTime = msg.timestamp.toLocal();
        final formattedTime = DateFormat('hh:mm a').format(localTime);

        // Date separator logic
        bool showDateSeparator = false;
        String? dateLabel;
        if (index == 0) {
          showDateSeparator = true;
        } else {
          final prevMsgDate = sortedMessages[index - 1].timestamp.toLocal();
          if (!isSameDay(localTime, prevMsgDate)) {
            showDateSeparator = true;
          }
        }
        if (showDateSeparator) {
          final now = DateTime.now();
          if (isSameDay(localTime, now)) {
            dateLabel = "Today";
          } else if (isSameDay(
              localTime, now.subtract(const Duration(days: 1)))) {
            dateLabel = "Yesterday";
          } else {
            dateLabel = DateFormat('dd/MM/yyyy').format(localTime);
          }
        }

        return Column(
          children: [
            if (showDateSeparator) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      dateLabel ?? "",
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    isMe ? "You" : "Callvcal",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isMe
                          ? theme.colorScheme.primary.withOpacity(0.85)
                          : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isMe ? 12 : 0),
                        topRight: Radius.circular(isMe ? 0 : 12),
                        bottomLeft: const Radius.circular(12),
                        bottomRight: const Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.message ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: isMe
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedTime,
                          style: TextStyle(
                            fontSize: 10,
                            color: isMe ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
