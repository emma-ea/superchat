part of 'chat_bloc.dart';

class ChatState extends Equatable {

  ChatStatus status;
  Chat? chat;

  ChatState({this.status = ChatStatus.initial, this.chat});

  ChatState copyWith({ChatStatus? status}) {
    return ChatState(
      status: status ?? this.status,
      chat: chat ?? chat,
    );
  }

  @override
  List<Object?> get props => [status, chat];

}

enum ChatStatus {
  initial,
  loading,
  loaded,
  emptyRoom,
  error,
}