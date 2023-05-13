import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
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

    await updateActiveUserInfo(user.user!.uid, isActive: true);
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

    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    db.collection(AppConstants.firestoreUserCollections)
      .doc(userId)
      .set({
        'active': isActive,
        'uid': userId,
        'last_visited': DateTime.now(),
        'device': deviceInfo.data.toString(),
      }).onError((error, stackTrace) => UserInfoUpdateException(error as String));
  }

  Future<void> getActiveUsers() async {
    db.collection(AppConstants.firestoreUserCollections)
      .snapshots()
      .listen((documents) {
        if (documents.docs.isNotEmpty) {
          activeUsersController.sink.add(filterActiveUsers(documents));
        }
      });
  }

  int filterActiveUsers(QuerySnapshot<Map<String, dynamic>> documents) {
    final filteredDocs = documents.docs;
    filteredDocs.removeWhere((doc) => doc.id == auth.currentUser!.uid);
    filteredDocs.retainWhere((doc) => (doc.data()['active'] as bool));
    return filteredDocs.length;
  }

  Future<List<String>> getUsersInCategory(String term) async {
    final categories = await db.collection(AppConstants.firestoreCategoryCollections)
      .doc(term.toLowerCase())
      .get()
      .onError((error, stackTrace) => 
        throw CategoryCreationException(error as String)
      );
    if (!categories.exists) { return []; }

    return (categories.data()?[AppConstants.firestoreCategoryWaitingRoom] as List).map((e) => e as String).toList();
  }

  Future<void> removeUserFromWaitingRoom() {
    throw UnimplementedError('TODO');
  }

  Future<int> processCategory(String term) async {

    int results = -1;

    final categories = await getUsersInCategory(term);
    categories.add(await getUser());

    final data = {
      'waiting_users': categories,
      'recent_search': DateTime.now(),
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
