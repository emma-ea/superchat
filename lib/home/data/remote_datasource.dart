import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:superchat/core_utils/chat_exceptions.dart';
import 'package:superchat/core_utils/constants.dart';

import 'package:superchat/home/data/local_datasource.dart';
import 'package:uuid/uuid.dart';

class RemoteDataSource {

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  StreamController<int> activeUsersController = StreamController.broadcast();

  Stream<int> get activeUsers => activeUsersController.stream;

  final LocalDatasource _cache;

  RemoteDataSource(this._cache) {
    getActiveUsers();
  }
  
  Future<String> createUser() async {
    final user = await auth
      .signInAnonymously()
      .onError((error, stackTrace) => 
        throw UserCreationException(error as String));

    final uid = user.user?.uid;

    if (uid == null) {
      throw const UserCreationException('Couldn\'t access user id');
    }

    await updateActiveUserInfo(uid, isActive: true, setFirstLogin: true);

    final cachedUid = await _cache.getUser() ?? '';

    if (cachedUid.isNotEmpty && cachedUid != uid) {
      deleteUser(cachedUid);
    }

    await _cache.saveUser(uid);
    return uid;
  }

  Future<String> getUser({bool? signOff}) async {
    String uid = '';

    final cachedUid = await _cache.getUser() ?? '';

    if (auth.currentUser != null) {
      uid = auth.currentUser!.uid;
      await updateActiveUserInfo(uid, isActive: signOff ?? true);
      await _cache.saveUser(uid);
    }

    if (cachedUid.isNotEmpty && cachedUid != uid) {
      deleteUser(cachedUid);
    }

    return uid;
  }

  Future<void> updateActiveUserInfo(String userId, {bool isActive = false, bool inChat = false, bool setFirstLogin = false}) async {

    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    final data = {
      'active': isActive,
      'uid': userId,
      'last_visited': DateTime.now(),
      'in_chat': inChat,
      'device': deviceInfo.data.toString(),
    };

    if (setFirstLogin) {
      data.putIfAbsent('first_login', () => DateTime.now());
      db.collection(AppConstants.firestoreUserCollections)
        .doc(userId)
        .set(data)
        .onError((error, stackTrace) => UserInfoUpdateException(error as String));
    } else {
      db.collection(AppConstants.firestoreUserCollections)
        .doc(userId)
        .update(data)
        .onError((error, stackTrace) => UserInfoUpdateException(error as String));
    }
  }

  Future<void> getActiveUsers() async {
    db.collection(AppConstants.firestoreUserCollections)
      .snapshots()
      .listen((documents) {
        if (documents.docs.isNotEmpty && auth.currentUser != null) {
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

    print('----------getUsersInCategory-------------');
    print(categories.data()![AppConstants.firestoreCategoryWaitingRoom]);
    print('-----------------------');
    if (categories.data()![AppConstants.firestoreCategoryWaitingRoom] == Null) return [];

    return (categories.data()?[AppConstants.firestoreCategoryWaitingRoom] as List).map((e) => e as String).toList();
  }

  Future<void> removeUserFromWaitingRoom() {
    throw UnimplementedError('TODO');
  }

  Future<void> deleteUser(String uid) async {
    db.collection(AppConstants.firestoreUserCollections)
      .doc(uid)
      .delete();
  }

  Future<int> processCategory(String term) async {

    int results = -1;

    List<String> categories = await getUsersInCategory(term);
    categories.add(await getUser());

    categories = categories.toSet().toList();

    final data = {
      'waiting_users': categories,
      'recent_search': DateTime.now(),
    };

    await db.collection(AppConstants.firestoreCategoryCollections)
      .doc(term.toLowerCase())
      .set(data)
      .whenComplete(() => results = AppConstants.addUserToTopic)
      .onError((error, stackTrace) => 
        throw CategoryCreationException(error as String)
      );

    return results;
  }
  
}
