import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superchat/chat/chat.dart';
import 'package:superchat/chat/data/chat.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  static String route = "/chat";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatBloc>(
      create: (context) => ChatBloc(
        repository: ChatInjector.di.get<ChatRepository>(),
      )..add(SetupChatRoomEvent()),
      child: _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
  _ChatView({super.key});

  final chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.symmetric(horizontal: 100),
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state.status == ChatStatus.loaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // chat lists
                  StreamBuilder<List<Chat>>(
                    initialData: dummy,
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: chatController,
                          decoration: const InputDecoration(
                            hintText: 'Start chatting...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0,),
                        child: IconButton(
                          iconSize: 30.0,
                          onPressed: () {
                            
                          }, 
                          icon: const Icon(Icons.send_outlined),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}