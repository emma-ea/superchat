import 'package:shared_preferences/shared_preferences.dart';
import 'package:superchat/core_utils/printer.dart';

class LocalDatasource {

  late SharedPreferences prefs;
  final String kCachedUser = 'user';

  Future<String?> getUser() async {
    prefs = await SharedPreferences.getInstance();
    logPrinter('get user from cache', trace: 'localdatasource - getUser()');
    return prefs.getString(kCachedUser);
  }

  Future<void> saveUser(String userId) async {
    prefs = await SharedPreferences.getInstance();
    logPrinter('saving user to cache', trace: 'localdatasource - saveUser()');
    await prefs.setString(kCachedUser, userId);
  }

  Future<void> deleteUser() {
    throw UnimplementedError('TODO');
  }

}