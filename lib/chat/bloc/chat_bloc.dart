
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:superchat/chat/chat.dart';
import 'package:superchat/chat/data/chat.dart';
import 'package:superchat/chat/repository/chat_repository.dart';

part 'chat_events.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvents, ChatState> {

  final ChatRepository _repository;

  ChatBloc({required ChatRepository repository}) 
  : _repository = repository, 
  super(ChatState()) {
    on<SetupChatRoomEvent>(_setupChatRoom);
    on<ListenForUsersEvent>(_listenForUsers);
  }

  void _listenForUsers(
    ListenForUsersEvent event,
    Emitter<ChatState> emit,
  ) {
    _repository.listenToEmptyRoom().listen((chatRoom) { 
      if (chatRoom.split('-').length == 2) {
        emit(state.copyWith(status: ChatStatus.loaded));
      }
    });
  }

  void listenToRoom() {
    return _repository.listenToRoom();
  }

  Future<void> _setupChatRoom(
    SetupChatRoomEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ChatStatus.loading));
      final res = await _repository.setupChatRoom(category: event.category);
      if (res == 112) {
        emit(state.copyWith(status: ChatStatus.emptyRoom));
      } else {
        emit(state.copyWith(status: ChatStatus.loaded));
      }
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.error));
    }
  }

}