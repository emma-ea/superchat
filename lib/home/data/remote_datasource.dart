class RemoteDataSource {

  Future<String> createUser() async {
    return "user111";
  }

  Future<void> processCategory() async {
    return Future.value();
  }
  
}