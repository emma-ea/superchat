import 'package:superchat/chat/data/chat.dart';

abstract class ChatRepository {
  Future<DateTime> setupChatRoom({required String roomId});
  Stream<String> listenToEmptyRoom();
  Future<void> listenToRoom();
  Future<void> sendChat();
  Stream<Chat> getMessages();
}