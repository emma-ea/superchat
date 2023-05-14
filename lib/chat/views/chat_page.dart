import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superchat/chat/chat.dart';
import 'package:superchat/chat/data/chat.dart';
import 'package:superchat/core_utils/widgets/chat_app_bar.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  static String route = "/chat";

  static Route routeWithParams(String category, String userId) {
    return MaterialPageRoute(
      builder: (context) =>
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(
            repository: ChatInjector.di.get<ChatRepository>(),
            topic: category,
            userId: userId,
          )..add(ListenForUsersEvent()),
          child: const ChatPage(),
        ),
        settings: RouteSettings(
          name: route,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return const _ChatView();
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChatViewState();
  }
}

class _ChatViewState extends State<_ChatView> {

  final chatController = TextEditingController();
  String? category = '';

  @override
  Widget build(BuildContext context) {
    final state = context.select((ChatBloc bloc) => bloc.state);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text('TOPIC: ${state.topic}', style: const TextStyle(color: Colors.black, fontSize: 12),),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.symmetric(horizontal: 100),
        child: BlocConsumer<ChatBloc, ChatState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state.status == ChatStatus.emptyRoom) {
              // context.read<ChatBloc>().add(ListenToRoomEvent());
            }

            if (state.status == ChatStatus.loaded) {
              context.read<ChatBloc>().add(ListenForIncomingMessages());
            }
          },
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            if (state.status == ChatStatus.emptyRoom) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12,),
                    const Text('Waiting for users to join...'),
                    const Spacer(),
                    ChatInput(
                      hintText: 'Start chatting',
                      onTap: () {
                        chatController.text = '';
                      },
                    ),
                  ],
                ),
              );
            }
            if (state.status == ChatStatus.loaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // chat lists
                  const ChatList(),
                  ChatInput(
                    hintText: 'Start chatting...',
                    controller: chatController, 
                    onTap: () {
                      if (chatController.text.trim().isNotEmpty) {
                        final roomId = context.read<ChatBloc>().state.roomId!;
                        final message = chatController.text;
                        final chat = Chat(message: message, sentTime: DateTime.now());
                        context.read<ChatBloc>().add(SendChatEvent(chat: chat, roomId: roomId));
                      }
                    },
                  ),
                  const Center(
                    child: Text('Connected to a random user'),
                  ),
                ],
              );
            }
            if (state.status == ChatStatus.loading) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 12,),
                    Text('Setting up chat room...'),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}