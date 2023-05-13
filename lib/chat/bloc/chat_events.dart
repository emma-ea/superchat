part of 'chat_bloc.dart';

abstract class ChatEvents {}

class SetupChatRoomEvent extends ChatEvents {
  final String category;
  SetupChatRoomEvent({required this.category});
}