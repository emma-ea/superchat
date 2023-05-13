part of 'chat_bloc.dart';

class ChatState extends Equatable {

  ChatStatus status;

  ChatState({this.status = ChatStatus.initial});

  @override
  List<Object?> get props => [];

}

enum ChatStatus {
  initial,
  loading,
  loaded,
  error,
}