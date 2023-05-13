import 'package:flutter/material.dart';
import 'package:superchat/chat/chat.dart';
import 'package:superchat/chat/data/chat.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Chat>>(
      initialData: [],
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 55.0, bottom: 10.0),
              child: ListView.builder(
                reverse: true,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return ChatItem(chat: snapshot.data?[index]);
                },
              ),
            ),
          );
        }
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Connected with user with id: 11122112'),
        );
      },
    );
  }
}