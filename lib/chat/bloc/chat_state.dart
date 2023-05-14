part of 'chat_bloc.dart';

class ChatState extends Equatable {

  ChatStatus status;
  Chat? chat;
  String? topic;

  ChatState({this.status = ChatStatus.initial, this.topic, this.chat});

  ChatState copyWith({ChatStatus? status, Chat? chat, String? topic}) {
    return ChatState(
      status: status ?? this.status,
      chat: chat ?? this.chat,
      topic: topic ?? this.topic,
    );
  }

  @override
  List<Object?> get props => [status, chat, topic];

}

enum ChatStatus {
  initial,
  loading,
  loaded,
  emptyRoom,
  error,
}