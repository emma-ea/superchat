import 'package:superchat/chat/data/chat.dart';

abstract class ChatRepository {
  Future<void> setupChatRoom({required String category});
  Future<void> sendChat();
  Stream<Chat> getMessages();
}