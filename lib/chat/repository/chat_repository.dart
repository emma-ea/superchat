import 'package:superchat/chat/data/chat.dart';

abstract class ChatRepository {
  Future<int> setupChatRoom({required String category});
  Stream<String> listenToEmptyRoom();
  void listenToRoom();
  Future<void> sendChat();
  Stream<Chat> getMessages();
}