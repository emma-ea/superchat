import 'package:superchat/chat/data/chat.dart';

abstract class ChatRepository {
  Future<DateTime> setupChatRoom({required String roomId});
  Stream<String> listenToEmptyRoom();
  Future<void> listenToRoom();
  Future<int> sendChat({required String roomId, required Chat chat});
  Stream<Chat> getMessages();
}