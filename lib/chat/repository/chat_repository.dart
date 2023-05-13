import 'package:superchat/chat/data/chat.dart';

abstract class ChatRepository {
  Future<void> setupChatRoom();
  Future<void> sendChat();
  Stream<Chat> getMessages();
}