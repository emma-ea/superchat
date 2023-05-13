import 'package:superchat/home/home.dart';

class DIInitializer {

  DIInitializer._();

  static void init() {
    Injector.instance.initialize();
  }

}