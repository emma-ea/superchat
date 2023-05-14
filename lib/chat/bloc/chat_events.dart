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

class SendChatEvent extends ChatEvents {
  final Chat chat;
  final String roomId;
  SendChatEvent({required this.chat, required this.roomId});
}

class ListenForIncomingMessages extends ChatEvents {}
