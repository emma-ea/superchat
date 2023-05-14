part of 'chat_bloc.dart';

class ChatState extends Equatable {

  ChatStatus status;
  Chat? chat;
  String? topic;
  String? roomId;
  String? userId;
  List<Chat>? chats;
  Map<String, dynamic> extra;

  ChatState({this.status = ChatStatus.initial, this.extra = const {}, this.chats, this.userId, this.topic, this.roomId, this.chat});

  ChatState copyWith({ChatStatus? status, Map<String, dynamic>? extra, List<Chat>? chats, String? userId, Chat? chat, String? roomId, String? topic}) {
    return ChatState(
      status: status ?? this.status,
      chat: chat ?? this.chat,
      topic: topic ?? this.topic,
      roomId: roomId ?? this.roomId,
      extra: extra ?? this.extra,
      userId: userId ?? this.userId,
      chats: chats ?? this.chats,
    );
  }

  @override
  List<Object?> get props => [status, chat, chats, roomId, extra, userId, topic];

}

enum ChatStatus {
  initial,
  loading,
  loaded,
  emptyRoom,
  error,
  sendingChat,
  sendingChatError,
}