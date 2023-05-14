abstract class HomeRepository {

  Future<String> getUser();

  Future<void> deleteUser(String uid);

  Stream<int> getActiveUsers();

  Future<int> generateTopic({required String term});

  Future<void> updateUserStatus({required String userId, required bool isActive, required bool inChat});

}