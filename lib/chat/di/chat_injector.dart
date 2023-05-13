import 'package:get_it/get_it.dart';
import 'package:superchat/chat/data/chat_repository_impl.dart';
import 'package:superchat/chat/data/remote_datasource.dart';
import 'package:superchat/chat/repository/chat_repository.dart';

class ChatInjector {

  ChatInjector._();

  static final ChatInjector _instance = ChatInjector._();

  static ChatInjector get instance => _instance;

  static late final GetIt _di;

  static GetIt get di => _di;

  void initialize() {
    _di = GetIt.instance;

    setup();
  }

  void setup() {
    _di.registerSingleton<ChatRepository>(ChatRepositoryImpl(ChatRemoteDatasource()));
  }

}