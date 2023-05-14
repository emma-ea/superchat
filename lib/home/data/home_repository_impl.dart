import 'package:superchat/home/data/remote_datasource.dart';
import 'package:superchat/home/repository/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {

  final RemoteDataSource _dataSource;

  HomeRepositoryImpl(this._dataSource);

  @override
  Future<String> getUser() async {
    final user = await _dataSource.getUser();
    if (user.isEmpty) {
      return _dataSource.createUser();
    }
    return user;
  }

  @override
  Future<int> generateTopic({required String term}) {
    return _dataSource.processCategory(term);
  }
  
  @override
  Stream<int> getActiveUsers() {
    return _dataSource.activeUsers;
  }
  
  @override
  Future<void> updateUserStatus({required String userId, required bool isActive, required bool inChat}) {
    return _dataSource.updateActiveUserInfo(userId, isActive: isActive, inChat: inChat);
  }

}