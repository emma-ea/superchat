
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:superchat/chat/chat.dart';
import 'package:superchat/chat/repository/chat_repository.dart';

part 'chat_events.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvents, ChatState> {

  final ChatRepository _repository;

  ChatBloc({required ChatRepository repository}) 
  : _repository = repository, 
  super(ChatState()) {
    on<SetupChatRoomEvent>(_setupChatRoom);
  }

  Future<void> _setupChatRoom(
    SetupChatRoomEvent event,
    Emitter<ChatState> emit,
  ) async {
    
  }

}