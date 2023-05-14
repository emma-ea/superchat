import 'package:shared_preferences/shared_preferences.dart';

class LocalDatasource {

  late SharedPreferences prefs;
  final String kCachedUser = 'user';

  Future<String?> getUser() async {
    prefs = await SharedPreferences.getInstance();
    print('-------------');
    print('getUser');
    print('-------------');
    return prefs.getString(kCachedUser);
  }

  Future<void> saveUser(String userId) async {
    prefs = await SharedPreferences.getInstance();
    print('-------------');
    print('saveUser');
    print('-------------');
    await prefs.setString(kCachedUser, userId);
  }

  Future<void> deleteUser() {
    throw UnimplementedError('TODO');
  }

}