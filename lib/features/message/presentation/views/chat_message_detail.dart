import 'package:GreenConnectMobile/features/message/presentation/views/chat_class.dart';
import 'package:GreenConnectMobile/features/message/presentation/views/widges/chat_app_bar.dart';
import 'package:GreenConnectMobile/features/message/presentation/views/widges/chat_input_area.dart';
import 'package:GreenConnectMobile/features/message/presentation/views/widges/chat_message_list.dart';
import 'package:flutter/material.dart';

class ChatDetailScreen extends StatelessWidget {
  final Map<String, dynamic> initialData;

  const ChatDetailScreen({super.key, required this.initialData});

  @override
  Widget build(BuildContext context) {
    final String name = initialData["name"] ?? "Unknown";
    final String avatar = initialData["avatar"] ?? "";
    final List<ChatMessage> messages = initialData["messages"] ?? [];

    return Scaffold(
      appBar: ChatAppBar(name: name, avatar: avatar),
      body: Column(
        children: [
          Expanded(child: ChatMessageList(messages: messages)),
          ChatInputArea(onSend: (text) {}, onAttach: () {}),
        ],
      ),
    );
  }
}
