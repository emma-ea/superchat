import 'package:superchat/home/data/remote_datasource.dart';
import 'package:superchat/home/repository/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {

  final RemoteDataSource _dataSource;

  HomeRepositoryImpl(this._dataSource);

  @override
  Future<String> createUser() {
    return _dataSource.createUser();
  }

  @override
  Future<void> processCategory() {
    return _dataSource.processCategory();
  }

}