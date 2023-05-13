import 'package:get_it/get_it.dart';
import 'package:superchat/home/home.dart';

class Injector {

  Injector._();

  static final Injector _instance = Injector._();

  static Injector get instance => _instance;

  static late final GetIt _di;

  static GetIt get di => _di;

  void initialize() {
    _di = GetIt.instance;

    setup();
  }

  void setup() {
    _di.registerSingleton<HomeRepository>(HomeRepositoryImpl(RemoteDataSource()));
  }

}