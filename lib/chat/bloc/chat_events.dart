part of 'chat_bloc.dart';

abstract class ChatEvents {}

// class SetupChatRoomEvent extends ChatEvents {
//   final String category;
//   SetupChatRoomEvent({required this.category});
// }

class ListenForUsersEvent extends ChatEvents {}

class ListenToRoomEvent extends ChatEvents {}

class FoundChatRoomEvent extends ChatEvents {
  final String roomId;
  FoundChatRoomEvent(this.roomId);
}