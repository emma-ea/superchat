import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:superchat/core_utils/chat_exceptions.dart';
import 'package:superchat/core_utils/constants.dart';

class RemoteDataSource {

  FirebaseFirestore db = FirebaseFirestore.instance;

  StreamController<int> activeUsersController = StreamController.broadcast();

  Stream<int> get activeUsers => activeUsersController.stream;

  RemoteDataSource() {
    getActiveUsers();
  }
  
  Future<String> createUser() async {
    return "user-john-doe";
  }

  Future<String> getUser() async {
    return "";
  }

  Future<void> getActiveUsers() async {
    db.collection(AppConstants.firestoreUserCollections)
      .snapshots()
      .listen((event) {
        print(event.docs.first.data());
        activeUsersController.sink.add(event.size);
      });
  }

  int filterActiveUsers() {
    throw UnimplementedError('TODO');
  }

  Future<int> processCategory(String term) async {

    int results = -1;

    final data = {
      'userId': await createUser(),
      'time': DateTime.now(),
    };

    await db.collection(AppConstants.firestoreCategoryCollections)
      .doc(term.toLowerCase())
      .set(data)
      .whenComplete(() => results = 1)
      .onError((error, stackTrace) => 
        throw CategoryCreationException(error as String)
      );

    return results;
  }
  
}
