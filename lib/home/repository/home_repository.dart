abstract class HomeRepository {

  Future<String> getUser();

  Stream<int> getActiveUsers();

  Future<int> processCategory({required String term});

}