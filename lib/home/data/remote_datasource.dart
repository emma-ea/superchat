import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:superchat/core_utils/chat_exceptions.dart';
import 'package:superchat/core_utils/constants.dart';

class RemoteDataSource {

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  StreamController<int> activeUsersController = StreamController.broadcast();

  Stream<int> get activeUsers => activeUsersController.stream;

  RemoteDataSource() {
    getActiveUsers();
  }
  
  Future<String> createUser() async {
    final user = await auth
      .signInAnonymously()
      .onError((error, stackTrace) => 
        throw UserCreationException(error as String));

    if (user.user?.uid == null) {
      throw const UserCreationException('Couldn\'t access user id');
    }

    return user.user?.uid ?? 'random-11223';
  }

  Future<String> getUser({bool? signOff}) async {
    String uid = '';
    if (auth.currentUser != null) {
      uid = auth.currentUser!.uid;
      await updateActiveUserInfo(uid, isActive: signOff ?? true);
    }
    return uid;
  }

  Future<void> updateActiveUserInfo(String userId, {bool isActive = false}) async {
    db.collection(AppConstants.firestoreUserCollections)
      .doc(userId)
      .set({
        'active': isActive,
        'last_visited': DateTime.now(),
      }).onError((error, stackTrace) => UserInfoUpdateException(error as String));
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
      'userId': await getUser(),
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
