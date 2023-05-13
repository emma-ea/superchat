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
  Future<void> sendChat() {
    // TODO: implement sendChat
    throw UnimplementedError();
  }

  @override
  Future<void> setupChatRoom({required String category}) {
    return _datasource.setupChatRoom(category);
  }
}