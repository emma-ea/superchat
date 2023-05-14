
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:superchat/chat/chat.dart';
import 'package:superchat/chat/data/chat.dart';
import 'package:superchat/chat/repository/chat_repository.dart';
import 'package:superchat/core_utils/chat_exceptions.dart';

part 'chat_events.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvents, ChatState> {

  final ChatRepository _repository;
  final String topic;
  final String userId;

  ChatBloc({required ChatRepository repository, required this.userId, required this.topic}) 
  : _repository = repository, 
  super(ChatState(topic: topic, userId: userId)) {
    on<ListenForUsersEvent>(_listenForUsers);
    on<FoundChatRoomEvent>(_foundChatRoom);
    on<SendChatEvent>(_sendChat);
    on<ListenForIncomingMessages>(_listenForMessages);
  }

  Future<void> _listenForUsers(
    ListenForUsersEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(status: ChatStatus.loading));
    listenToRoom();
    _repository.listenToEmptyRoom().listen((chatRoom) {
      if (chatRoom.isNotEmpty) {
        add(FoundChatRoomEvent(chatRoom));
      }
    });
  }

  Future<void> _listenForMessages(
    ListenForIncomingMessages event,
    Emitter<ChatState> emit,
  ) async {
    _repository.getMessages().listen((chat) { 
      final chats = state.chats;
      chats?.add(chat);
      emit(state.copyWith(chats: chats));
    });
  }

  Future<void> _foundChatRoom(
    FoundChatRoomEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(status: ChatStatus.emptyRoom));
    await Future.delayed(const Duration(seconds: 4));
    _repository.setupChatRoom(roomId: event.roomId);
    emit(state.copyWith(status: ChatStatus.loaded, roomId: event.roomId));
  }

  Future<void> _sendChat(
    SendChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ChatStatus.sendingChat));
      await _repository.sendChat(chat: event.chat, roomId: event.roomId);
    } on SendingChatError catch (e, _) {
      emit(state.copyWith(status: ChatStatus.sendingChatError, /** emit error too */ ));
    } catch (e, _) {
      emit(state.copyWith(status: ChatStatus.error));
    }
  }

  void listenToRoom() {
    _repository.listenToRoom();
  }

}