import 'package:superchat/chat/data/chat.dart';
import 'package:superchat/chat/data/remote_datasource.dart';
import 'package:superchat/chat/repository/chat_repository.dart';

class ChatRepositoryImpl extends ChatRepository {

  final ChatRemoteDatasource _datasource;

  ChatRepositoryImpl(this._datasource);

  @override
  Stream<Chat> getMessages() {
    // TODO: implement getMessages
    throw UnimplementedError();
  }

  @override
  Future<int> sendChat({required String roomId, required Chat chat}) {
    return _datasource.sendChat(roomId, chat);
  }

  @override
  Future<DateTime> setupChatRoom({required String roomId}) {
    return _datasource.setupChatRoom(roomId);
  }
  
  @override
  Stream<String> listenToEmptyRoom() {
    return _datasource.getUserInRoom;
  }
  
  @override
  Future<void> listenToRoom() {
    return _datasource.listenToEmptyRoom();
  }
}