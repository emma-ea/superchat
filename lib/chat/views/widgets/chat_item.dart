import 'package:flutter/material.dart';
import 'package:superchat/chat/data/chat.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({super.key, required this.chat});

  final Chat? chat;

  @override
  Widget build(BuildContext context) {
    return (chat == null) 
      ? const SizedBox.shrink()
      : Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: chat!.sent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(chat!.message),
          Text(chat!.sentTime.toString()),
        ],
      ),
    ); 
  }
}