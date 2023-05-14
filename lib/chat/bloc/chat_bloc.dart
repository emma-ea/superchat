
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:superchat/chat/chat.dart';
import 'package:superchat/chat/data/chat.dart';
import 'package:superchat/chat/repository/chat_repository.dart';

part 'chat_events.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvents, ChatState> {

  final ChatRepository _repository;
  final String topic;

  ChatBloc({required ChatRepository repository, required this.topic}) 
  : _repository = repository, 
  super(ChatState(topic: topic)) {
    on<ListenForUsersEvent>(_listenForUsers);
    on<FoundChatRoomEvent>(_foundChatRoom);
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

  Future<void> _foundChatRoom(
    FoundChatRoomEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(status: ChatStatus.emptyRoom));
    await Future.delayed(const Duration(seconds: 4));
    _repository.setupChatRoom(roomId: event.roomId);
    emit(state.copyWith(status: ChatStatus.loaded));
  }

  void listenToRoom() {
    _repository.listenToRoom();
  }

}