import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            appBar: AppBar(
              title: Row(
                children: [
                  Text(ticket.businessName ?? "Chat"),
                  const SizedBox(width: 8),
                  Icon(
                    state.isConnected ? Icons.circle : Icons.circle_outlined,
                    size: 12,
                    color: state.isConnected ? Colors.green : Colors.red,
                  ),
                ],
              ),
              actions: [
                IconButton(
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
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: "Type your message...",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(12),
                          ),
                        ),
                      ),
                      state.isSending
                          ? const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.send, color: Colors.green),
                              onPressed: () {
                                bloc.add(ChatSendMessage(controller.text));
                                controller.clear();
                              },
                            ),
                    ],
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

    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[messages.length - 1 - index];
        final isMe = msg.senderType == 'user';

        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: isMe
                  ? theme.colorScheme.primary.withOpacity(0.85)
                  : theme.colorScheme.surfaceVariant,
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
            child: Text(
              msg.message ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: isMe ? Colors.white : theme.colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
        );
      },
    );
  }
}
