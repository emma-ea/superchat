import 'package:superchat/chat/chat.dart';
import 'package:superchat/home/home.dart';

class DIInitializer {

  DIInitializer._();

  static void init() {
    HomeInjector.instance.initialize();
    ChatInjector.instance.initialize();
  }

}